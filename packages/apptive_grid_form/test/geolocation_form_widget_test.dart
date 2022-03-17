import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(const LocationSettings());
    registerFallbackValue(const CameraPosition(target: LatLng(0, 0)));
    registerFallbackValue(TextDirection.ltr);
    registerFallbackValue(MarkerUpdates.from({}, {}));
    registerFallbackValue(CircleUpdates.from({}, {}));
    registerFallbackValue(PolygonUpdates.from({}, {}));
    registerFallbackValue(PolylineUpdates.from({}, {}));
    registerFallbackValue(CameraUpdate.newLatLng(const LatLng(0, 0)));
    registerFallbackValue(FormData(title: '', components: [], schema: {}));
  });

  group('TextInput', () {
    testWidgets('Initial Location Geocodes to address', (tester) async {
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: GeolocationDataEntity(
                  const Geolocation(latitude: 47, longitude: 11),
                ),
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('ZWEIDENKER'), findsOneWidget);
    });

    testWidgets('Search with initial location uses location for results',
        (tester) async {
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: GeolocationDataEntity(
                  const Geolocation(latitude: 47, longitude: 11),
                ),
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Z');
      await tester.pumpAndSettle();

      final capturedUri = verify(
        () => mockGeolocationHttpClient.get(
          captureAny<Uri>(
            that: predicate<Uri>(
              (uri) => uri.path.contains('queryautocomplete'),
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).captured.first as Uri;

      expect(capturedUri.queryParameters['location'], equals('47.0,11.0'));
    });

    testWidgets('Filled Textfield shows clear button, click clears button',
        (tester) async {
      final geolocationDataEntity = GeolocationDataEntity(
        const Geolocation(latitude: 47, longitude: 11),
      );
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationDataEntity,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(geolocationDataEntity.value, equals(null));
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'Z');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('Search for location updates location', (tester) async {
      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Z');
      await tester.pumpAndSettle();

      await tester.tap(find.text('ZWEIDENKER'));

      expect(
        geolocationData.value,
        equals(const Geolocation(latitude: 47, longitude: 11)),
      );
    });

    testWidgets('No Results for Location shows message', (tester) async {
      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response =
              PlacesAutocompleteResponse(status: 'OK', predictions: []);
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Z');
      await tester.pumpAndSettle();

      expect(find.text('No results'), findsOneWidget);
    });
  });

  group('My Location Button', () {
    testWidgets('Click on my location updates location', (tester) async {
      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.granted);

      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(Icons.my_location),
      );
      await tester.pumpAndSettle();

      expect(
        geolocationData.value,
        equals(const Geolocation(latitude: 47, longitude: 11)),
      );
      // Verify My Location is Geocoded
      expect(find.text('ZWEIDENKER'), findsOneWidget);
    });

    testWidgets(
        'Geocoding returns no results '
        'shows LatLng Coordinates', (tester) async {
      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.granted);

      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(status: 'OK', results: []);
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(Icons.my_location),
      );
      await tester.pumpAndSettle();

      expect(
        geolocationData.value,
        equals(const Geolocation(latitude: 47, longitude: 11)),
      );

      expect(find.text('47.0, 11.0'), findsOneWidget);
    });

    testWidgets('Click on my location requests permission if necessary',
        (tester) async {
      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.denied);

      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(Icons.my_location),
      );
      await tester.pumpAndSettle();

      verify(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).called(1);
    });
  });

  group('Map', () {
    late GoogleMapsFlutterPlatform originalPlatform;

    late StreamController<MapTapEvent> mapTapStream;
    late StreamController<MarkerDragEndEvent> markerDragEndStream;

    late Set<MarkerId> markers;

    setUp(() {
      markers = {};
      originalPlatform = GoogleMapsFlutterPlatform.instance;
      final mockMap = MockMapPlatform();
      GoogleMapsFlutterPlatform.instance = mockMap;
      final initCompleter = Completer();

      when(
        () => mockMap.buildViewWithTextDirection(
          any(),
          any(),
          initialCameraPosition: any(named: 'initialCameraPosition'),
          textDirection: any(named: 'textDirection'),
          markers: any(named: 'markers'),
          polygons: any(named: 'polygons'),
          polylines: any(named: 'polylines'),
          circles: any(named: 'circles'),
          tileOverlays: any(named: 'tileOverlays'),
          gestureRecognizers: any(named: 'gestureRecognizers'),
          mapOptions: any(named: 'mapOptions'),
        ),
      ).thenAnswer((invocation) {
        if (!initCompleter.isCompleted) {
          (invocation.positionalArguments[1] as Function(int))
              .call(invocation.positionalArguments[0]);
        }
        markers = invocation.namedArguments[const Symbol('markers')]
            .map<MarkerId>((e) => (e as Marker).markerId)
            .toSet();
        return Container();
      });

      when(() => mockMap.init(any())).thenAnswer(
        (invocation) async =>
            initCompleter.complete(invocation.positionalArguments[0]),
      );
      final markerTapStream = StreamController<MarkerTapEvent>.broadcast();
      when(() => mockMap.onMarkerTap(mapId: any(named: 'mapId')))
          .thenAnswer((_) {
        return markerTapStream.stream;
      });
      final markerDragStream = StreamController<MarkerDragEvent>.broadcast();
      when(() => mockMap.onMarkerDrag(mapId: any(named: 'mapId')))
          .thenAnswer((_) => markerDragStream.stream);
      final markerDragStartStream =
          StreamController<MarkerDragStartEvent>.broadcast();
      when(() => mockMap.onMarkerDragStart(mapId: any(named: 'mapId')))
          .thenAnswer((_) => markerDragStartStream.stream);
      markerDragEndStream = StreamController<MarkerDragEndEvent>.broadcast();
      when(() => mockMap.onMarkerDragEnd(mapId: any(named: 'mapId')))
          .thenAnswer((_) => markerDragEndStream.stream);
      mapTapStream = StreamController<MapTapEvent>.broadcast();
      when(() => mockMap.onTap(mapId: any(named: 'mapId'))).thenAnswer((_) {
        return mapTapStream.stream;
      });
      final mapLongPressStream =
          StreamController<MapLongPressEvent>.broadcast();
      when(() => mockMap.onLongPress(mapId: any(named: 'mapId')))
          .thenAnswer((_) => mapLongPressStream.stream);
      final infoWindowTapStream =
          StreamController<InfoWindowTapEvent>.broadcast();
      when(() => mockMap.onInfoWindowTap(mapId: any(named: 'mapId')))
          .thenAnswer((_) => infoWindowTapStream.stream);
      final polylineTapStream = StreamController<PolylineTapEvent>.broadcast();
      when(() => mockMap.onPolylineTap(mapId: any(named: 'mapId')))
          .thenAnswer((_) => polylineTapStream.stream);
      final polygonTapStream = StreamController<PolygonTapEvent>.broadcast();
      when(() => mockMap.onPolygonTap(mapId: any(named: 'mapId')))
          .thenAnswer((_) => polygonTapStream.stream);
      final circleTapStream = StreamController<CircleTapEvent>.broadcast();
      when(() => mockMap.onCircleTap(mapId: any(named: 'mapId')))
          .thenAnswer((_) => circleTapStream.stream);

      when(
        () => mockMap.updateTileOverlays(
          newTileOverlays: any(named: 'newTileOverlays'),
          mapId: any(named: 'mapId'),
        ),
      ).thenAnswer((_) async {});
      when(() => mockMap.updateMapOptions(any(), mapId: any(named: 'mapId')))
          .thenAnswer((_) async {});
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
    });

    tearDown(() {
      GoogleMapsFlutterPlatform.instance = originalPlatform;
    });

    testWidgets('Click on Map updates location', (tester) async {
      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      mapTapStream.add(MapTapEvent(0, const LatLng(47, 11)));

      await tester.pumpAndSettle();
      expect(find.text('ZWEIDENKER'), findsOneWidget);
      expect(
        geolocationData.value,
        equals(const Geolocation(latitude: 47, longitude: 11)),
      );
    });

    testWidgets('Drag Marker updates Location', (tester) async {
      final geolocationData =
          GeolocationDataEntity(const Geolocation(latitude: 47, longitude: 11));
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          late final GeocodingResponse response;
          if (requestUri.queryParameters['latlng'] == '47.0,11.0') {
            response = GeocodingResponse(
              status: 'OK',
              results: [
                GeocodingResult(
                  geometry: Geometry(location: Location(lat: 47, lng: 11)),
                  placeId: 'placeId',
                  formattedAddress: 'ZWEIDENKER',
                )
              ],
            );
          } else {
            response = GeocodingResponse(
              status: 'OK',
              results: [
                GeocodingResult(
                  geometry: Geometry(location: Location(lat: 11, lng: 47)),
                  placeId: 'placeId',
                  formattedAddress: 'PharoPro',
                )
              ],
            );
          }
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      markerDragEndStream
          .add(MarkerDragEndEvent(0, const LatLng(11, 47), markers.first));

      await tester.pumpAndSettle();
      expect(find.text('PharoPro'), findsOneWidget);
      expect(
        geolocationData.value,
        equals(const Geolocation(latitude: 11, longitude: 47)),
      );
    });
  });

  group('General', () {
    testWidgets('Missing Geolocation Configuration shows Error',
        (tester) async {
      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.denied);

      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: const ApptiveGridOptions(formWidgetConfigurations: []),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Missing GeolocationFormWidgetConfiguration in ApptiveGrid Widget',
        ),
        findsOneWidget,
      );
    });
  });

  group('Decoration', () {
    testWidgets('Required shows hint and updates message if changed',
        (tester) async {
      final action = FormAction('actionUri', 'POST');

      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.granted);

      final geolocationData = GeolocationDataEntity();
      final mockGeolocationHttpClient = MockHttpClient();
      final target = TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: mockGeolocationHttpClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
                required: true,
              ),
            ],
            actions: [action],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final scrollable = find.ancestor(
        of: find.byType(ActionButton, skipOffstage: false),
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.byType(ActionButton, skipOffstage: false),
        400,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      const requiredString = 'property must not be empty';
      expect(find.text(requiredString), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byIcon(Icons.my_location, skipOffstage: false),
        -400,
        scrollable: scrollable,
      );
      await tester.pump();
      await tester.tap(
        find.byIcon(Icons.my_location),
      );
      await tester.pumpAndSettle();

      expect(find.text(requiredString), findsNothing);
    });

    testWidgets('Prefilled Required Form is validated', (tester) async {
      final action = FormAction('actionUri', 'POST');

      final mockGeolocator = MockGeolocator();
      GeolocatorPlatform.instance = mockGeolocator;
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer(
        (invocation) async => Position(
          latitude: 47,
          longitude: 11,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );

      final mockPermission = MockPermissionHandler();
      PermissionHandlerPlatform.instance = mockPermission;
      when(
        () => mockPermission.requestPermissions([Permission.locationWhenInUse]),
      ).thenAnswer(
        (invocation) async =>
            {Permission.locationWhenInUse: PermissionStatus.granted},
      );
      when(
        () =>
            mockPermission.checkPermissionStatus(Permission.locationWhenInUse),
      ).thenAnswer((invocation) async => PermissionStatus.granted);

      final geolocationData =
          GeolocationDataEntity(const Geolocation(latitude: 47, longitude: 11));
      final mockGeolocationHttpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      final options = ApptiveGridOptions(
        formWidgetConfigurations: [
          GeolocationFormWidgetConfiguration(
            placesApiKey: 'placesApiKey',
            httpClient: mockGeolocationHttpClient,
          ),
        ],
      );
      final target = TestApp(
        client: apptiveGridClient,
        child: ApptiveGridFormData(
          formData: FormData(
            title: 'title',
            components: [
              GeolocationFormComponent(
                property: 'property',
                data: geolocationData,
                fieldId: 'fieldId',
                required: true,
              ),
            ],
            actions: [action],
            schema: null,
          ),
        ),
      );

      when(
        () => mockGeolocationHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        final requestUri = invocation.positionalArguments.first as Uri;

        if (requestUri.path.contains('queryautocomplete')) {
          final response = PlacesAutocompleteResponse(
            status: 'OK',
            predictions: [
              Prediction(
                description: 'ZWEIDENKER',
                placeId: 'placeId',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('details')) {
          final response = PlacesDetailsResponse(
            status: 'OK',
            result: PlaceDetails(
              name: 'ZWEIDENKER',
              placeId: 'placeId',
              geometry: Geometry(location: Location(lat: 47, lng: 11)),
            ),
            htmlAttributions: [],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        if (requestUri.path.contains('geocode')) {
          final response = GeocodingResponse(
            status: 'OK',
            results: [
              GeocodingResult(
                geometry: Geometry(location: Location(lat: 47, lng: 11)),
                placeId: 'placeId',
                formattedAddress: 'ZWEIDENKER',
              )
            ],
          );
          return Response(jsonEncode(response.toJson()), 200);
        }

        throw 'MissingMockResponse for GET $requestUri';
      });

      when(() => apptiveGridClient.options).thenReturn(options);
      when(() => apptiveGridClient.sendPendingActions())
          .thenAnswer((_) async {});
      when(
        () => apptiveGridClient.performAction(
          action,
          any(),
          saveToPendingItems: any(named: 'saveToPendingItems'),
        ),
      ).thenAnswer((_) async => Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final scrollable = find.ancestor(
        of: find.byType(ActionButton, skipOffstage: false),
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.byType(ActionButton, skipOffstage: false),
        400,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      const requiredString = 'property must not be empty';

      expect(find.text(requiredString), findsNothing);
      verify(
        () => apptiveGridClient.performAction(
          action,
          any(),
          saveToPendingItems: any(named: 'saveToPendingItems'),
        ),
      ).called(1);
    });
  });
}
