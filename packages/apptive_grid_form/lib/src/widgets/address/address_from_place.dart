import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/src/google_maps_webservice/google_maps_webservice.dart';

/// Builds an [Address] from Google Place Details
///
/// Mirrors the web frontend's `AGAddress.fromGooglePlace`:
/// - `route` and `street_number` form line1. For Germany the number follows
///   the street, everywhere else it leads.
/// - The place name becomes line2 when the place is not a plain street
///   address and the name is not already line1 (e.g. a business).
/// - `locality` → city, `postal_code` → postCode,
///   `administrative_area_level_1` → state, `country` → country.
Address addressFromPlaceDetails(PlaceDetails place) => addressFromComponents(
      components: place.addressComponents,
      types: place.types,
      name: place.name,
      location: place.geometry?.location,
    );

/// Builds an [Address] from a reverse geocoding [result]
///
/// Geocoding results carry no place name, so line2 stays empty. [location]
/// overrides the result's own geometry – pass the device position so the
/// stored coordinates are the ones the user actually stands at.
Address addressFromGeocodingResult(
  GeocodingResult result, {
  Geolocation? location,
}) =>
    addressFromComponents(
      components: result.addressComponents,
      types: result.types,
      location: result.geometry.location,
    ).copyWith(geoLocation: location);

/// Picks the reverse geocoding result worth turning into an address
///
/// Google orders results from specific to broad, but the most specific one
/// is not always a street address – at a plaza or a landmark it can be a
/// premise or a plus code without route and number. A `street_address`
/// result is preferred wherever there is one; otherwise the first result.
GeocodingResult? preferredGeocodingResult(List<GeocodingResult> results) {
  for (final result in results) {
    if (result.types.contains('street_address')) {
      return result;
    }
  }
  return results.isEmpty ? null : results.first;
}

/// Shared mapping of Google address components to an [Address]
Address addressFromComponents({
  required List<AddressComponent> components,
  required List<String> types,
  String? name,
  Location? location,
}) {
  String? component(String type) => components
      .cast<AddressComponent?>()
      .firstWhere(
        (component) => component!.types.contains(type),
        orElse: () => null,
      )
      ?.longName;

  final street = component('route');
  final streetNumber = component('street_number');
  final country = component('country');
  final line1 = _streetLine(country, street, streetNumber);

  String? line2;
  if (name != null &&
      name.isNotEmpty &&
      !types.contains('street_address') &&
      line1 != name) {
    line2 = name;
  }

  return Address(
    line1: line1,
    line2: line2,
    city: component('locality'),
    postCode: component('postal_code'),
    state: component('administrative_area_level_1'),
    country: country,
    geoLocation: location != null
        ? Geolocation(latitude: location.lat, longitude: location.lng)
        : null,
  );
}

String? _streetLine(String? country, String? street, String? number) {
  final germany =
      const ['germany', 'deutschland'].contains(country?.toLowerCase());
  final parts = germany ? [street, number] : [number, street];
  final present = parts.whereType<String>().where((part) => part.isNotEmpty);
  return present.isEmpty ? null : present.join(' ');
}
