import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('is equal', () {
      final id = 'id';
      final name = 'name';
      final type = DataType.text;
      final a = GridField(id, name, type);
      final b = GridField(id, name, type);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('is not equal', () {
      final id = 'id';
      final name = 'name';
      final type = DataType.text;
      final a = GridField(id, name, type);
      final b = GridField(name, id, type);

      expect(a, isNot(b));
      expect(a.hashCode, isNot(b.hashCode));
    });
  });
}
