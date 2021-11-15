import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/network/authentication/web_auth_enabler/web_auth_enabler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IO implementation works', () async {
    await enableWebAuth(const ApptiveGridOptions());
  });
}
