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
Address addressFromPlaceDetails(PlaceDetails place) {
  String? component(String type) => place.addressComponents
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
  if (!place.types.contains('street_address') &&
      place.name.isNotEmpty &&
      line1 != place.name) {
    line2 = place.name;
  }

  final location = place.geometry?.location;
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
