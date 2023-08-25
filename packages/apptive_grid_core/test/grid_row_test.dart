import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('From Json equals direct', () {
      const id = 'id';
      const field = GridField(
        id: 'fieldId',
        name: 'fieldName',
        type: DataType.text,
        schema: {
          {
            'type': 'array',
            'items': [
              {'type': 'string'},
            ],
          },
        },
      );
      const value = 'value';
      final entries = <GridEntry>[
        GridEntry(field, StringDataEntity(value)),
      ];
      final direct = GridRow(id: id, entries: entries, links: {});
      final fromJson = GridRow.fromJson(
        {
          '_id': id,
          'fields': [value],
        },
        [field],
      );

      expect(direct, equals(direct));
      expect(fromJson, equals(fromJson));
      expect(direct, equals(fromJson));
    });

    test('Hashcode', () {
      const id = 'id';
      const field = GridField(
        id: 'fieldId',
        name: 'fieldName',
        type: DataType.text,
        schema: {
          {
            'type': 'array',
            'items': [
              {'type': 'string'},
            ],
          },
        },
      );
      const value = 'value';
      final entries = <GridEntry>[
        GridEntry(field, StringDataEntity(value)),
      ];
      final direct = GridRow(id: id, entries: entries, links: {});

      expect(
        direct.hashCode,
        equals(Object.hash(direct.id, direct.entries, direct.links)),
      );
    });

    test('toString()', () {
      const id = 'id';
      const field = GridField(
        id: 'fieldId',
        name: 'fieldName',
        type: DataType.text,
        schema: {
          {
            'type': 'array',
            'items': [
              {'type': 'string'},
            ],
          },
        },
      );
      const value = 'value';
      final entries = <GridEntry>[
        GridEntry(field, StringDataEntity(value)),
      ];
      final direct = GridRow(id: id, entries: entries, links: {});

      expect(
        direct.toString(),
        equals('GridRow(id: $id, entries: $entries, links: {})'),
      );
    });
  });
}
