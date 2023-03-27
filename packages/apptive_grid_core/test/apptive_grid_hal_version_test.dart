import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('v1', () {
    final header = ApptiveGridHalVersion.v1.header;
    expect(header.key, 'Accept');
    expect(header.value, 'application/vnd.apptivegrid.hal');
  });
  test('v2', () {
    final header = ApptiveGridHalVersion.v2.header;
    expect(header.key, 'Accept');
    expect(header.value, 'application/vnd.apptivegrid.hal;version=2');
  });
}
