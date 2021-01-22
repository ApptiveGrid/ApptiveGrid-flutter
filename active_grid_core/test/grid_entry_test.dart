import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('From Json == Direct', () {
      final field = GridField('id', 'name', DataType.text);
      final value = 'value';

      final direct = GridEntry(field, StringDataEntity(value));
      final fromJson = GridEntry.fromJson(value, field);

      expect(fromJson, direct);
      expect(fromJson.hashCode, direct.hashCode);
    });

    test('UnEqual', () {
      final field = GridField('id', 'name', DataType.text);
      final value = 'value';

      final single = GridEntry(field, StringDataEntity(value));
      final double = GridEntry(field, StringDataEntity(value + value));

      expect(single, isNot(double));
      expect(single.hashCode, isNot(double.hashCode));
    });
  });
}
