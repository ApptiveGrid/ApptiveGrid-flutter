import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/google_maps_web_service/google_maps_web_service.dart';
import 'package:apptive_grid_form/managers/location_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  late LocationManager locationManager;

  late MockHttpClient httpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(
      const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: null,
      ),
    );
  });

  setUp(() {
    httpClient = MockHttpClient();
    locationManager = LocationManager(
      configuration: GeolocationFormWidgetConfiguration(
        placesApiKey: 'placesApiKey',
        httpClient: httpClient,
      ),
    );
  });

  group('getCurrentPosition', () {
    test('LocationManager passes LocationRequest to Geolocator Plugin',
        () async {
      final geolocator = MockGeolocator();
      GeolocatorPlatform.instance = geolocator;

      final position = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 12,
        altitude: 12,
        heading: 12,
        speed: 12,
        speedAccuracy: 12,
      );
      when(
        () => geolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer((_) async => position);

      expect(await locationManager.getCurrentPosition(), equals(position));

      verify(
        () => geolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).called(1);
    });
  });

  group('queryAutocomplete', () {
    test('queryAutocomplete calls places service', () async {
      final response =
          PlacesAutocompleteResponse(status: 'OK', predictions: []);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => Response(jsonEncode(response.toJson()), 200),
      );

      expect(
        (await locationManager.queryAutocomplete('input')).toJson(),
        equals(response.toJson()),
      );

      final capturedUri = verify(
        () => httpClient.get(captureAny<Uri>(), headers: any(named: 'headers')),
      ).captured.first as Uri;

      expect(capturedUri.host, equals('maps.googleapis.com'));
      expect(
        capturedUri.pathSegments,
        ['maps', 'api', 'place', 'queryautocomplete', 'json'],
      );
    });
  });

  group('getPlaceDetails', () {
    test('getPlaceDetails calls places service', () async {
      final response = PlacesDetailsResponse(
        status: 'OK',
        result: PlaceDetails(name: 'name', placeId: 'placeId'),
        htmlAttributions: [],
      );

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => Response(jsonEncode(response.toJson()), 200),
      );

      expect(
        (await locationManager.getPlaceDetails('input')).toJson().toString(),
        equals(response.toJson().toString()),
      );

      final capturedUri = verify(
        () => httpClient.get(captureAny<Uri>(), headers: any(named: 'headers')),
      ).captured.first as Uri;

      expect(capturedUri.host, equals('maps.googleapis.com'));
      expect(
        capturedUri.pathSegments,
        ['maps', 'api', 'place', 'details', 'json'],
      );
    });
  });

  group('getPlaceByLocation', () {
    test('getPlaceByLocation calls places service', () async {
      final response = GeocodingResponse(status: 'OK', results: []);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => Response(jsonEncode(response.toJson()), 200),
      );

      expect(
        (await locationManager.getPlaceByLocation(
          const Geolocation(latitude: 0, longitude: 0),
        ))
            .toJson(),
        equals(response.toJson()),
      );

      final capturedUri = verify(
        () => httpClient.get(captureAny<Uri>(), headers: any(named: 'headers')),
      ).captured.first as Uri;

      expect(capturedUri.host, equals('maps.googleapis.com'));
      expect(
        capturedUri.pathSegments,
        equals(['maps', 'api', 'geocode', 'json']),
      );
    });
  });
}
