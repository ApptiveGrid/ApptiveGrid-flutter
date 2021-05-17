import 'package:apptive_grid_core/web_auth_enabler/web_auth_enabler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IO implementation works', () async {
    await enableWebAuth();
  });
}
