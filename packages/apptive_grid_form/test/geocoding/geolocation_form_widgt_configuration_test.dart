import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Configuration equals based on API Keys', () {
    const a = GeolocationFormWidgetConfiguration(
      placesApiKey: 'placesApiKey',
      geocodingApiKey: 'geocodingApiKey',
    );
    const b = GeolocationFormWidgetConfiguration.withHttpClient(
      placesApiKey: 'placesApiKey',
      geocodingApiKey: 'geocodingApiKey',
    );

    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });
}
