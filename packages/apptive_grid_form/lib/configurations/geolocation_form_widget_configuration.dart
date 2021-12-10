part of form_widget_configurations;

class GeolocationFormWidgetConfiguration extends FormWidgetConfiguration {

  const GeolocationFormWidgetConfiguration({required this.placesApiKey, this.geocodingApiKey}) : super();

  final String placesApiKey;
  final String? geocodingApiKey;
}