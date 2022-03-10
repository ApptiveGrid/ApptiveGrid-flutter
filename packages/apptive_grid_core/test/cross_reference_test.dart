import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [
            {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
            }
          ],
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
              {
                'type': 'object',
                'properties': {
                  'displayValue': {'type': 'string'},
                  'uri': {'type': 'string'}
                },
                'required': ['uri'],
                'objectType': 'entityreference',
                'gridUri':
                    '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
              }
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
      expect(
        grid.rows[0].entries[0].data,
        CrossReferenceDataEntity.fromJson(
          jsonValue: {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
          },
          gridUri:
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        ),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(fromJson.toJson(), equals(rawResponse));
    });

    test('GridUri is parsed Correctly', () {
      final dataEntity = Grid.fromJson(rawResponse).rows[0].entries[0].data
          as CrossReferenceDataEntity;

      expect(
        dataEntity.gridUri.uri.toString(),
        (rawResponse['schema'] as Map)['properties']['fields']['items'][0]
            ['gridUri'],
      );
    });
  });

  group('DataEntity', () {
    group('Equality', () {
      test('Equality', () {
        final a = CrossReferenceDataEntity.fromJson(
          jsonValue: {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
          },
          gridUri:
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        );
        final b = CrossReferenceDataEntity.fromJson(
          jsonValue: {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
          },
          gridUri:
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        );
        final c = CrossReferenceDataEntity.fromJson(
          jsonValue: null,
          gridUri:
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        );
        expect(a, equals(b));
        expect(a, isNot(c));

        expect(a.hashCode, equals(b.hashCode));
        expect(a.hashCode, isNot(c.hashCode));
      });
    });

    group('Schema Object', () {
      test('Value and EntityUri are set', () {
        final entity = CrossReferenceDataEntity(
            gridUri: GridUri.fromUri('uri'),
            value: 'Display Value',
            entityUri: EntityUri.fromUri('entityUri'));

        expect(
            entity.schemaValue,
            equals({
              'displayValue': 'Display Value',
              'uri': 'entityUri',
            }));
      });

      test('No Value still produces object if EntityUri is set', () {
        final entity = CrossReferenceDataEntity(
            gridUri: GridUri.fromUri('uri'),
            value: null,
            entityUri: EntityUri.fromUri('entityUri'));

        expect(
            entity.schemaValue,
            equals({
              'displayValue': '',
              'uri': 'entityUri',
            }));
      });

      test('No Entity Uri sends null', () {
        final entity = CrossReferenceDataEntity(
            gridUri: GridUri.fromUri('uri'),
            value: 'Display Value',
            entityUri: null);

        expect(entity.schemaValue, isNull);
      });
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'uri': {'type': 'string'}
              },
              'required': ['uri'],
              'objectType': 'entityreference',
              'gridUri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
            },
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

      final fromJson = formData.components[0] as CrossReferenceFormComponent;

      final directEntity = CrossReferenceDataEntity.fromJson(
        jsonValue: {
          'displayValue': 'Yeah!',
          'uri':
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
        },
        gridUri:
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
      );

      final direct = CrossReferenceFormComponent(
        property: 'name',
        data: directEntity,
        fieldId: '3ftoqhqbct15h5o730uknpvp5',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
