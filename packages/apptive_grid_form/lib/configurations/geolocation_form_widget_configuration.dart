part of form_widget_configurations;

class GeolocationFormWidgetConfiguration extends FormWidgetConfiguration {
  const GeolocationFormWidgetConfiguration({
    required this.placesApiKey,
    this.geocodingApiKey,
  })  : httpClient = null,
        super();

  const GeolocationFormWidgetConfiguration.withHttpClient({
    required this.placesApiKey,
    this.geocodingApiKey,
    this.httpClient,
  }) : super();

  final http.Client? httpClient;

  final String placesApiKey;
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
