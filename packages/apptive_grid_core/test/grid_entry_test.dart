import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('From Json == Direct', () {
      const field = GridField(
        id: 'id',
        name: 'name',
        type: DataType.text,
        schema: {
          'properties': [
            {'type': 'string'}
          ]
        },
      );
      const value = 'value';

      final direct = GridEntry(field, StringDataEntity(value));
      final fromJson = GridEntry.fromJson(
        value,
        field,
      );

      expect(fromJson, equals(direct));
    });

    test('UnEqual', () {
      const field = GridField(id: 'id', name: 'name', type: DataType.text);
      const value = 'value';

      final single = GridEntry(field, StringDataEntity(value));
      final double = GridEntry(field, StringDataEntity(value + value));

      expect(single, isNot(double));
    });
  });

  test('Hashcode', () {
    const field = GridField(id: 'id', name: 'name', type: DataType.text);
    const value = 'value';

    final single = GridEntry(field, StringDataEntity(value));

    expect(single.hashCode, equals(Object.hash(field, value)));
  });

  test('toString()', () {
    const field = GridField(id: 'id', name: 'name', type: DataType.text);
    const value = 'value';

    final single = GridEntry(field, StringDataEntity(value));

    expect(
      single.toString(),
      equals('GridEntry(field: $field, data: ${StringDataEntity(value)})'),
    );
  });
}
