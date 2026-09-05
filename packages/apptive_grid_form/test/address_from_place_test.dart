import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/google_maps_webservice/google_maps_webservice.dart';
import 'package:apptive_grid_form/src/widgets/address/address_from_place.dart';
import 'package:apptive_grid_form/src/widgets/address/countries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AddressComponent component(String type, String name) =>
      AddressComponent(types: [type], longName: name, shortName: name);

  PlaceDetails place({
    required String name,
    List<String> types = const ['street_address'],
    List<AddressComponent> components = const [],
    Location? location,
  }) =>
      PlaceDetails(
        name: name,
        placeId: 'placeId',
        types: types,
        addressComponents: components,
        geometry: location != null ? Geometry(location: location) : null,
      );

  group('addressFromPlaceDetails', () {
    test('German addresses put the number after the street', () {
      final address = addressFromPlaceDetails(
        place(
          name: 'Musterstraße 1',
          components: [
            component('route', 'Musterstraße'),
            component('street_number', '1'),
            component('locality', 'Berlin'),
            component('postal_code', '12345'),
            component('administrative_area_level_1', 'Berlin'),
            component('country', 'Deutschland'),
          ],
          location: Location(lat: 52.5, lng: 13.4),
        ),
      );

      expect(
        address,
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
    });

    test('Other countries put the number before the street', () {
      final address = addressFromPlaceDetails(
        place(
          name: '1600 Amphitheatre Parkway',
          components: [
            component('route', 'Amphitheatre Parkway'),
            component('street_number', '1600'),
            component('locality', 'Mountain View'),
            component('country', 'United States'),
          ],
        ),
      );

      expect(address.line1, equals('1600 Amphitheatre Parkway'));
      expect(address.city, equals('Mountain View'));
      expect(address.geoLocation, isNull);
    });

    test('Business name becomes line2', () {
      final address = addressFromPlaceDetails(
        place(
          name: 'ZWEIDENKER',
          types: const ['establishment', 'point_of_interest'],
          components: [
            component('route', 'Wilhelmstraße'),
            component('street_number', '80'),
            component('country', 'Germany'),
          ],
        ),
      );

      expect(address.line1, equals('Wilhelmstraße 80'));
      expect(address.line2, equals('ZWEIDENKER'));
    });

    test('Name equal to line1 is not repeated as line2', () {
      final address = addressFromPlaceDetails(
        place(
          name: 'Wilhelmstraße 80',
          types: const ['premise'],
          components: [
            component('route', 'Wilhelmstraße'),
            component('street_number', '80'),
            component('country', 'Germany'),
          ],
        ),
      );

      expect(address.line2, isNull);
    });

    test('Missing components stay null', () {
      final address = addressFromPlaceDetails(
        place(
          name: 'Berlin',
          types: const [
            'locality',
          ],
          components: [
            component('locality', 'Berlin'),
            component('country', 'Deutschland'),
          ],
        ),
      );

      expect(address.line1, isNull);
      expect(address.line2, equals('Berlin'));
      expect(address.postCode, isNull);
      expect(address.state, isNull);
    });
  });

  group('countries', () {
    test('has every country with both names', () {
      expect(kCountries.length, equals(249));
      expect(kCountries.every((c) => c.alpha2.length == 2), isTrue);
      expect(
        kCountries.every((c) => c.nameEn.isNotEmpty && c.nameDe.isNotEmpty),
        isTrue,
      );
    });

    test('countryByName matches English and German names', () {
      expect(countryByName('Germany')?.alpha2, equals('de'));
      expect(countryByName('deutschland')?.alpha2, equals('de'));
      expect(countryByName(' Österreich ')?.alpha2, equals('at'));
      expect(countryByName('Atlantis'), isNull);
      expect(countryByName(null), isNull);
    });

    test('toString() lists code and both names', () {
      expect(
        countryByName('Germany').toString(),
        equals('Country(de, Germany, Deutschland)'),
      );
    });

    test('name() picks the language', () {
      final germany = countryByName('Germany')!;
      expect(germany.name('de'), equals('Deutschland'));
      expect(germany.name('en'), equals('Germany'));
      expect(germany.name(null), equals('Germany'));
    });
  });
}
