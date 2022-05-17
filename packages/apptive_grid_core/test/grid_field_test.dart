import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('is equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      final a = GridField(id: id, name: name, type: type);
      final b = GridField(id: id, name: name, type: type);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('is not equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      final a = GridField(id: id, name: name, type: type);
      final b = GridField(id: name, name: id, type: type);

      expect(a, isNot(b));
      expect(a.hashCode, isNot(b.hashCode));
    });
  });
}
