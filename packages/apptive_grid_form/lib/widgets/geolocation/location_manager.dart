import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class LocationManager {
  LocationManager({required String googleApiKey})
      : _googleMapsPlaces = GoogleMapsPlaces(apiKey: googleApiKey),
        _googleMapsGeocoding = GoogleMapsGeocoding(apiKey: googleApiKey);

  final GoogleMapsPlaces _googleMapsPlaces;
  final GoogleMapsGeocoding _googleMapsGeocoding;

  Future<Position> getCurrentPosition() =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

  Future<PlacesAutocompleteResponse> queryAutocomplete(
    String input, {
    num? offset,
    Location? location,
    num? radius,
    String? language,
  }) {
    return _googleMapsPlaces.queryAutocomplete(
      input,
      offset: offset,
      location: location,
      radius: radius,
      language: language,
    );
  }

  Future<PlacesDetailsResponse> getPlaceDetails(
    String placeId, {
    String? sessionToken,
    List<String> fields = const [],
    String? language,
    String? region,
  }) {
    return _googleMapsPlaces.getDetailsByPlaceId(
      placeId,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
      region: region,
    );
  }

  Future<GeocodingResponse> getPlaceByLocation(
    Geolocation location, {
    String? language,
    List<String> resultType = const [],
    List<String> locationType = const [],
  }) {
    return _googleMapsGeocoding.searchByLocation(
      Location(lat: location.latitude, lng: location.longitude),
      language: language,
      resultType: resultType,
      locationType: locationType,
    );
  }
}
