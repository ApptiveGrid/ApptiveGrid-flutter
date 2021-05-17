import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('From Json equals direct', () {
      final id = 'id';
      final field = GridField('fieldId', 'fieldName', DataType.text);
      final value = 'value';
      final entries = <GridEntry>[
        GridEntry(field, StringDataEntity(value)),
      ];
      final direct = GridRow(id, entries);
      final fromJson = GridRow.fromJson({
        '_id': id,
        'fields': [value]
      }, [
        field
      ], {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
            ]
          }
        },
      });

      expect(direct.hashCode, fromJson.hashCode);
      expect(direct, direct);
      expect(fromJson, fromJson);
      expect(direct, fromJson);
    });
  });
}
