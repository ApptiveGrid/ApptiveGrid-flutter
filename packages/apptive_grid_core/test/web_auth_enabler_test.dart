import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IO implementation works', () async {
    await enableWebAuth(const ApptiveGridOptions());
  });
}
