import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uriString returns uri as String', () {
    final uri = FormUri.fromUri('/api/a/1234');

    // ignore: deprecated_member_use_from_same_package
    expect(uri.uriString, equals(uri.uri.toString()));
  });
}