import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [47.11],
          '_id': '60d0370e0edfa83071816e12'
        }
      ],
      'fieldIds': ['3ftoqhqbct15h5o730uknpvp5'],
      'filter': {},
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'number'}
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'New grid view'
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields.length, equals(1));
      expect(grid.rows[0].entries[0].data, equals(DecimalDataEntity(47.11)));
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(fromJson.toJson(), equals(rawResponse));
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = DecimalDataEntity(47.11);
      final b = DecimalDataEntity(47.11);
      final c = DecimalDataEntity(11.47);
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'number',
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': 47.11,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'name': 'New Name',
        'title': 'New title',
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      final fromJson = formData.components[0] as DecimalFormComponent;

      final directEntity = DecimalDataEntity(47.11);

      final direct = DecimalFormComponent(
        property: 'name',
        data: directEntity,
        fieldId: '3ftoqhqbct15h5o730uknpvp5',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
