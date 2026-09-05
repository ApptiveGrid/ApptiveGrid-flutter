import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/google_maps_webservice/google_maps_webservice.dart';
import 'package:apptive_grid_form/src/widgets/geolocation/geolocation_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(const LocationSettings());
    registerFallbackValue(const CameraPosition(target: LatLng(0, 0)));
    registerFallbackValue(TextDirection.ltr);
    registerFallbackValue(MarkerUpdates.from(const {}, const {}));
    registerFallbackValue(CircleUpdates.from(const {}, const {}));
    registerFallbackValue(PolygonUpdates.from(const {}, const {}));
    registerFallbackValue(PolylineUpdates.from(const {}, const {}));
    registerFallbackValue(ClusterManagerUpdates.from(const {}, const {}));
    registerFallbackValue(HeatmapUpdates.from(const {}, const {}));
    registerFallbackValue(CameraUpdate.newLatLng(const LatLng(0, 0)));
    registerFallbackValue(
      const MapWidgetConfiguration(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
        textDirection: TextDirection.ltr,
      ),
    );
    registerFallbackValue(const MapConfiguration());
    registerFallbackValue(const MapObjects());
    registerFallbackValue(const CameraUpdateAnimationConfiguration());
    registerFallbackValue(GroundOverlayUpdates.from(const {}, const {}));
  });

  const field = GridField(id: 'fieldId', name: 'name', type: DataType.address);

  Widget targetWithComponent(
    FormComponent<AddressDataEntity> component, {
    required Client geolocationHttpClient,
    List<FormFieldProperties> fieldProperties = const [],
  }) {
    return TestApp(
      options: ApptiveGridOptions(
        formWidgetConfigurations: [
          GeolocationFormWidgetConfiguration(
            placesApiKey: 'placesApiKey',
            httpClient: geolocationHttpClient,
          ),
        ],
      ),
      child: ApptiveGridFormData(
        formData: FormData(
          id: 'formId',
          title: 'title',
          components: [component],
          links: {},
          fields: [field],
          fieldProperties: fieldProperties,
        ),
      ),
    );
  }

  /// Stubs the Places endpoints: suggestions for the address line and the
  /// details of the single suggestion. Returns the recorded request URIs.
  List<Uri> stubPlaces(
    Client client, {
    required PlaceDetails details,
    String description = 'Musterstraße 1, 12345 Berlin, Deutschland',
  }) {
    final requests = <Uri>[];
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async {
      final uri = invocation.positionalArguments[0] as Uri;
      requests.add(uri);
      if (uri.path.contains('autocomplete')) {
        final response = PlacesAutocompleteResponse(
          status: 'OK',
          predictions: [
            Prediction(description: description, placeId: 'placeId'),
          ],
        );
        return Response(jsonEncode(response.toJson()), 200);
      }
      if (uri.path.contains('details')) {
        final response = PlacesDetailsResponse(
          status: 'OK',
          result: details,
          htmlAttributions: [],
        );
        return Response(jsonEncode(response.toJson()), 200);
      }
      return Response('', 404);
    });
    return requests;
  }

  AddressComponent placeComponent(String type, String name) =>
      AddressComponent(types: [type], longName: name, shortName: name);

  final berlinPlace = PlaceDetails(
    name: 'Musterstraße 1',
    placeId: 'placeId',
    types: const ['street_address'],
    addressComponents: [
      placeComponent('route', 'Musterstraße'),
      placeComponent('street_number', '1'),
      placeComponent('locality', 'Berlin'),
      placeComponent('postal_code', '12345'),
      placeComponent('administrative_area_level_1', 'Berlin'),
      placeComponent('country', 'Deutschland'),
    ],
    geometry: Geometry(location: Location(lat: 52.5, lng: 13.4)),
  );

  group('Rendering', () {
    testWidgets('Missing GeolocationFormWidgetConfiguration shows error',
        (tester) async {
      final target = TestApp(
        child: ApptiveGridFormData(
          formData: FormData(
            id: 'formId',
            title: 'title',
            components: [
              FormComponent<AddressDataEntity>(
                property: 'property',
                data: AddressDataEntity(),
                field: field,
              ),
            ],
            links: {},
            fields: [field],
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Missing GeolocationFormWidgetConfiguration in ApptiveGrid Widget',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Shows initial values in text fields', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(
          const Address(
            line1: 'Musterstraße 1',
            line2: 'Apt 2',
            city: 'Berlin',
            postCode: '12345',
            state: 'Berlin',
            country: 'Germany',
          ),
        ),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Musterstraße 1'), findsOneWidget);
      expect(find.text('Apt 2'), findsOneWidget);
      expect(find.text('Berlin'), findsNWidgets(2)); // city + state
      expect(find.text('12345'), findsOneWidget);
      expect(find.text('Germany'), findsOneWidget);
    });
  });

  group('Editing', () {
    testWidgets('Editing line1 updates value', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Musterstraße 1',
      );
      await tester.pumpAndSettle();

      expect(component.data.value?.line1, equals('Musterstraße 1'));
    });

    testWidgets('Editing city updates value', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.city')),
        'Berlin',
      );
      await tester.pumpAndSettle();

      expect(component.data.value?.city, equals('Berlin'));
    });
  });

  group('Validation', () {
    testWidgets('Required field lists missing labels', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
        required: true,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        '',
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Address Line 1, City, Post Code, Country must not be empty',
        ),
        findsOneWidget,
      );
    });

    testWidgets('No error when all required fields are filled', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
        required: true,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Musterstraße 1',
      );
      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.city')),
        'Berlin',
      );
      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.postCode')),
        '12345',
      );
      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.country')),
        'Germany',
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('must not be empty'), findsNothing);
    });
  });

  group('Places', () {
    testWidgets('Typing in line1 shows address suggestions', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final client = MockHttpClient();
      stubPlaces(client, details: berlinPlace);
      await tester.pumpWidget(
        targetWithComponent(component, geolocationHttpClient: client),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Muster',
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Musterstraße 1, 12345 Berlin, Deutschland'),
        findsOneWidget,
      );
      // Typing alone already updates the value, a suggestion is optional.
      expect(component.data.value?.line1, equals('Muster'));
    });

    testWidgets('Picking a suggestion fills every field from the place',
        (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final client = MockHttpClient();
      final requests = stubPlaces(client, details: berlinPlace);
      await tester.pumpWidget(
        targetWithComponent(component, geolocationHttpClient: client),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Muster',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Musterstraße 1, 12345 Berlin, Deutschland'));
      await tester.pumpAndSettle();

      expect(
        component.data.value,
        equals(
          const Address(
            line1: 'Musterstraße 1',
            city: 'Berlin',
            postCode: '12345',
            state: 'Berlin',
            country: 'Deutschland',
            geoLocation: Geolocation(latitude: 52.5, longitude: 13.4),
          ),
        ),
      );
      expect(find.text('Berlin'), findsWidgets);
      expect(find.text('12345'), findsOneWidget);
      expect(find.text('Deutschland'), findsOneWidget);
      final detailsRequest =
          requests.firstWhere((uri) => uri.path.contains('details'));
      expect(detailsRequest.queryParameters['placeid'], equals('placeId'));
      expect(
        detailsRequest.queryParameters['fields'],
        equals('address_components,geometry,name,types'),
      );
    });

    testWidgets('Suggestions are restricted to the chosen country',
        (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(const Address(country: 'Germany')),
        field: field,
      );
      final client = MockHttpClient();
      final requests = stubPlaces(client, details: berlinPlace);
      await tester.pumpWidget(
        targetWithComponent(component, geolocationHttpClient: client),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Muster',
      );
      await tester.pumpAndSettle();

      final autocomplete =
          requests.firstWhere((uri) => uri.path.contains('autocomplete'));
      expect(autocomplete.queryParameters['components'], equals('country:de'));
      expect(autocomplete.queryParameters['types'], equals('address'));
      expect(autocomplete.queryParameters['language'], equals('en'));
    });

    testWidgets('Unknown country searches worldwide', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(const Address(country: 'Atlantis')),
        field: field,
      );
      final client = MockHttpClient();
      final requests = stubPlaces(client, details: berlinPlace);
      await tester.pumpWidget(
        targetWithComponent(component, geolocationHttpClient: client),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Muster',
      );
      await tester.pumpAndSettle();

      final autocomplete =
          requests.firstWhere((uri) => uri.path.contains('autocomplete'));
      expect(autocomplete.queryParameters.containsKey('components'), isFalse);
    });

    testWidgets('Failing suggestions keep the typed text', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final client = MockHttpClient();
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('boom', 500));
      await tester.pumpWidget(
        targetWithComponent(component, geolocationHttpClient: client),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.line1')),
        'Musterstraße 1',
      );
      await tester.pumpAndSettle();

      expect(component.data.value?.line1, equals('Musterstraße 1'));
      expect(tester.takeException(), isNull);
    });
  });

  group('Labels', () {
    testWidgets('Custom line labels from FormFieldProperties are used',
        (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
        required: true,
      );
      await tester.pumpWidget(
        targetWithComponent(
          component,
          geolocationHttpClient: MockHttpClient(),
          fieldProperties: [
            FormFieldProperties(
              fieldId: field.id,
              line1Label: 'Straße und Hausnummer',
              line2Label: 'Adresszusatz',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Straße und Hausnummer'), findsOneWidget);
      expect(find.text('Adresszusatz'), findsOneWidget);
      expect(find.text('Address Line 1'), findsNothing);

      // The custom label also names the missing field in the error.
      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.city')),
        'Berlin',
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Straße und Hausnummer, Post Code, Country'),
        findsOneWidget,
      );
    });
  });

  group('Country', () {
    testWidgets('Typing shows matching suggestions', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.country')),
        'German',
      );
      await tester.pumpAndSettle();

      expect(find.text('Germany'), findsOneWidget);
    });

    testWidgets('Selecting a suggestion updates value', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('AddressFormWidget.country')),
        'German',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();

      expect(component.data.value?.country, equals('Germany'));
    });
  });

  group('Geocoding', () {
    testWidgets('Button disabled until address is complete', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(),
        field: field,
      );
      final target = targetWithComponent(
        component,
        geolocationHttpClient: MockHttpClient(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Failed geocoding shows error message', (tester) async {
      final component = FormComponent<AddressDataEntity>(
        property: 'property',
        data: AddressDataEntity(
          const Address(
            line1: 'Musterstraße 1',
            city: 'Berlin',
            postCode: '12345',
            country: 'Germany',
          ),
        ),
        field: field,
      );
      final mockGeolocationHttpClient = MockHttpClient();
      final target = targetWithComponent(
        component,
        geolocationHttpClient: mockGeolocationHttpClient,
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final response = GeocodingResponse(status: 'ZERO_RESULTS', results: []);
        return Response(jsonEncode(response.toJson()), 200);
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Position could not be determined automatically'),
        findsOneWidget,
      );
    });

    group('Map', () {
      late GoogleMapsFlutterPlatform originalPlatform;

      setUp(() {
        originalPlatform = GoogleMapsFlutterPlatform.instance;
        final mockMap = MockMapPlatform();
        GoogleMapsFlutterPlatform.instance = mockMap;
        final initCompleter = Completer();

        when(
          () => mockMap.buildViewWithConfiguration(
            any(),
            any(),
            widgetConfiguration: any(named: 'widgetConfiguration'),
            mapConfiguration: any(named: 'mapConfiguration'),
            mapObjects: any(named: 'mapObjects'),
          ),
        ).thenAnswer((invocation) {
          if (!initCompleter.isCompleted) {
            (invocation.positionalArguments[1] as Function(int))
                .call(invocation.positionalArguments[0]);
          }
          return Container();
        });

        when(() => mockMap.init(any())).thenAnswer(
          (invocation) async =>
              initCompleter.complete(invocation.positionalArguments[0]),
        );
        when(() => mockMap.onMarkerTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onMarkerDrag(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onMarkerDragStart(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onMarkerDragEnd(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onLongPress(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onInfoWindowTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onPolylineTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onPolygonTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onCircleTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(() => mockMap.onClusterTap(mapId: any(named: 'mapId')))
            .thenAnswer((_) => const Stream.empty());
        when(
          () =>
              mockMap.updateClusterManagers(any(), mapId: any(named: 'mapId')),
        ).thenAnswer((_) async {});
        when(() => mockMap.updateHeatmaps(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(
          () => mockMap.updateTileOverlays(
            newTileOverlays: any(named: 'newTileOverlays'),
            mapId: any(named: 'mapId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () =>
              mockMap.updateMapConfiguration(any(), mapId: any(named: 'mapId')),
        ).thenAnswer((_) async {});
        when(() => mockMap.updateMarkers(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(() => mockMap.updateCircles(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(() => mockMap.updatePolygons(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(() => mockMap.updatePolylines(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(() => mockMap.animateCamera(any(), mapId: any(named: 'mapId')))
            .thenAnswer((_) async {});
        when(
          () => mockMap.animateCameraWithConfiguration(
            any(),
            any(),
            mapId: any(named: 'mapId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockMap.updateGroundOverlays(any(), mapId: any(named: 'mapId')),
        ).thenAnswer((_) async {});
      });

      tearDown(() {
        GoogleMapsFlutterPlatform.instance = originalPlatform;
      });

      testWidgets('Successful geocoding shows map', (tester) async {
        final component = FormComponent<AddressDataEntity>(
          property: 'property',
          data: AddressDataEntity(
            const Address(
              line1: 'Musterstraße 1',
              city: 'Berlin',
              postCode: '12345',
              country: 'Germany',
            ),
          ),
          field: field,
        );
        final mockGeolocationHttpClient = MockHttpClient();
        final target = targetWithComponent(
          component,
          geolocationHttpClient: mockGeolocationHttpClient,
        );

        when(
          () => mockGeolocationHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((invocation) async {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 52.52, lng: 13.4)),
                placeId: 'placeId',
                formattedAddress: 'Musterstraße 1, 12345 Berlin',
              ),
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        });

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        expect(find.byType(GeolocationMap), findsNothing);

        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        expect(component.data.value?.geoLocation, isNotNull);
        expect(
          component.data.value?.geoLocation,
          equals(const Geolocation(latitude: 52.52, longitude: 13.4)),
        );
        expect(find.byType(GeolocationMap), findsOneWidget);
      });
    });
  });
}
