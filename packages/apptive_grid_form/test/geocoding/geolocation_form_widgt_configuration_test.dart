import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart';

void main() {
  test('Configuration equals based on API Keys', () {
    const a = GeolocationFormWidgetConfiguration(
      placesApiKey: 'placesApiKey',
      geocodingApiKey: 'geocodingApiKey',
    );
    final b = GeolocationFormWidgetConfiguration(
      placesApiKey: 'placesApiKey',
      geocodingApiKey: 'geocodingApiKey',
      httpClient: MockHttpClient(),
    );

    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });
}
