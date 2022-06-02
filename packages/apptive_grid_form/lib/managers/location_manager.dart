import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/google_maps_web_service/google_maps_web_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart' as geocoding;

/// Manager for handling Location based Requests and Services
class LocationManager {
  /// Creates a new [LocationManager] with [configuration]
  ///
  /// If [configuration.geocodingApiKey] is null [configuration.placesApiKey] is used for Geocoding requests
  /// this allows to use the same Api Key for both Services if the Scopes are set correctly on the Google Developer Console
  /// You can adjust the scopes for the api keys here:
  /// https://console.cloud.google.com/google/maps-apis/credentials
  LocationManager({required GeolocationFormWidgetConfiguration configuration})
      : _googleMapsPlaces = GoogleMapsPlaces(
          apiKey: configuration.placesApiKey,
          httpClient: configuration.httpClient,
        ),
        _googleMapsGeocoding = geocoding.GoogleMapsGeocoding(
          apiKey: configuration.geocodingApiKey ?? configuration.placesApiKey,
          httpClient: configuration.httpClient,
        );

  final GoogleMapsPlaces _googleMapsPlaces;
  final geocoding.GoogleMapsGeocoding _googleMapsGeocoding;

  /// Returns the current User Position using [Geolocator]
  ///
  /// Make sure that the User has given the required permissions
  Future<Position> getCurrentPosition() =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

  /// Queries the GooglePlaces Autocomplete Service
  ///
  /// /// Uses [GoogleMapsPlaces.queryAutocomplete]
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

  /// Queries the GooglePlaces API for Details for [placeId]
  ///
  /// Uses [GoogleMapsPlaces.getDetailsByPlaceId]
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

  /// Queries the GoogleGeocoding API for [location]
  ///
  /// Uses [GoogleMapsGeocoding.getPlaceByLocation]
  Future<geocoding.GeocodingResponse> getPlaceByLocation(
    Geolocation location, {
    String? language,
    List<String> resultType = const [],
    List<String> locationType = const [],
  }) {
    return _googleMapsGeocoding.searchByLocation(
      geocoding.Location(lat: location.latitude, lng: location.longitude),
      language: language,
      resultType: resultType,
      locationType: locationType,
    );
  }
}
