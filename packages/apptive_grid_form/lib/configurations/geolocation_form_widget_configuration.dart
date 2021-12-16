part of form_widget_configurations;

/// [FormWidgetConfiguration] used for [GeolocationFormWidget]
class GeolocationFormWidgetConfiguration extends FormWidgetConfiguration {
  /// Creates a new [GeolocationFormWidgetConfiguration]
  const GeolocationFormWidgetConfiguration({
    required this.placesApiKey,
    this.geocodingApiKey,
  })  : httpClient = null,
        super();

  /// Creates a new [GeolocationFormWidgetConfiguration] with a [httpClient]
  ///
  /// Used for testing in order to set mocks
  @visibleForTesting
  const GeolocationFormWidgetConfiguration.withHttpClient({
    required this.placesApiKey,
    this.geocodingApiKey,
    this.httpClient,
  }) : super();

  /// [http.Client] to be used for the requests
  /// This should normally used only for testing
  final http.Client? httpClient;

  /// Api Key used for request for the Google Places Api
  final String placesApiKey;

  /// Api Key used for requests for Geocoding
  final String? geocodingApiKey;

  @override
  String toString() {
    return 'GeolocationFormWidgetConfiguration(placesApiKey: $placesApiKey, geocodingApiKey: $geocodingApiKey)';
  }

  @override
  bool operator ==(Object other) {
    return other is GeolocationFormWidgetConfiguration &&
        placesApiKey == other.placesApiKey &&
        geocodingApiKey == other.geocodingApiKey;
  }

  @override
  int get hashCode => toString().hashCode;
}
