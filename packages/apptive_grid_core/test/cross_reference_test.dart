import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'id': 'gridId',
      'entities': [
        {
          'fields': [
            {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
            }
          ],
          '_id': '60d0370e0edfa83071816e12',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/60d0370e0edfa83071816e12",
              "method": "get",
            },
          },
        }
      ],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "reference",
            "componentTypes": ["entitySelect"],
          },
          "key": null,
          "name": "CrossRef",
          "schema": {
            "type": "object",
            "properties": {
              "displayValue": {"type": "string"},
              "uri": {"type": "string"},
            },
            "required": ["uri"],
            "objectType": "entityreference",
            "gridUri": "/api/users/userId/spaces/spaceId/grids/referencedGrid",
          },
          "id": "628210a604bd30163b9b7f77",
          "_links": <String, dynamic>{},
        }
      ],
      'name': 'New grid view',
      '_links': {
        "addLink": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/AddLink",
          "method": "post",
        },
        "forms": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "get",
        },
        "updateFieldType": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnTypeChange",
          "method": "post",
        },
        "removeField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRemove",
          "method": "post",
        },
        "addEntity": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "post",
        },
        "views": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "get",
        },
        "addView": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "post",
        },
        "self": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "get",
        },
        "updateFieldKey": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnKeyChange",
          "method": "post",
        },
        "query": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/query",
          "method": "get",
        },
        "entities": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "get",
        },
        "updates": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/updates",
          "method": "get",
        },
        "schema": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/schema",
          "method": "get",
        },
        "updateFieldName": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRename",
          "method": "post",
        },
        "addForm": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "post",
        },
        "addField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnAdd",
          "method": "post",
        },
        "rename": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/Rename",
          "method": "post",
        },
        "remove": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "delete",
        },
      },
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        CrossReferenceDataEntity.fromJson(
          jsonValue: {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          },
          gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGrid',
        ),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });

    test('GridUri is parsed Correctly', () {
      final dataEntity = Grid.fromJson(rawResponse).rows![0].entries[0].data
          as CrossReferenceDataEntity;

      expect(
        dataEntity.gridUri.toString(),
        (rawResponse['fields'] as List).first['schema']['gridUri'],
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
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          },
          gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGrid',
        );
        final b = CrossReferenceDataEntity.fromJson(
          jsonValue: {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          },
          gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGrid',
        );
        final c = CrossReferenceDataEntity.fromJson(
          jsonValue: null,
          gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGrid',
        );
        expect(a, equals(b));
        expect(a, isNot(c));

        expect(a.hashCode, isNot(c.hashCode));
      });
    });

    group('Schema Object', () {
      test('Value and EntityUri are set', () {
        final entity = CrossReferenceDataEntity(
          gridUri: Uri.parse('uri'),
          value: 'Display Value',
          entityUri: Uri.parse('entityUri'),
        );

        expect(
          entity.schemaValue,
          equals({
            'displayValue': 'Display Value',
            'uri': 'entityUri',
          }),
        );
      });

      test('No Value still produces object if EntityUri is set', () {
        final entity = CrossReferenceDataEntity(
          gridUri: Uri.parse('uri'),
          value: null,
          entityUri: Uri.parse('entityUri'),
        );

        expect(
          entity.schemaValue,
          equals({
            'displayValue': '',
            'uri': 'entityUri',
          }),
        );
      });

      test('No Entity Uri sends null', () {
        final entity = CrossReferenceDataEntity(
          gridUri: Uri.parse('uri'),
          value: 'Display Value',
          entityUri: null,
        );

        expect(entity.schemaValue, isNull);
      });

      test('toString() produces correct output', () {
        final entity = CrossReferenceDataEntity(
          gridUri: Uri.parse('uri'),
          value: null,
          entityUri: Uri.parse('entityUri'),
        );

        expect(
          entity.toString(),
          'CrossReferenceDataEntity(displayValue: null, entityUri: entityUri, gridUri: uri)',
        );
      });
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithCrossReference = {
        'fields': [
          {
            "type": {
              "name": "reference",
              "componentTypes": ["entitySelect"],
            },
            "schema": {
              "type": "object",
              "properties": {
                "displayValue": {"type": "string"},
                "uri": {"type": "string"},
              },
              "required": ["uri"],
              "objectType": "entityreference",
              "gridUri":
                  "/api/users/userId/spaces/spaceId/grids/referencedGrid",
            },
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "name": "name",
            "key": null,
            "_links": <String, dynamic>{},
          }
        ],
        'schemaObject':
            '/api/users/userId/spaces/spaceId/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
            },
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect',
          }
        ],
        'name': 'New Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post",
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete",
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get",
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put",
          },
        },
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      final fromJson = formData.components![0];

      final directEntity = CrossReferenceDataEntity.fromJson(
        jsonValue: {
          'displayValue': 'Yeah!',
          'uri':
              '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
        },
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGrid',
      );

      final direct = FormComponent<CrossReferenceDataEntity>(
        property: 'name',
        data: directEntity,
        field: const GridField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          type: DataType.crossReference,
        ),
        type: 'entitySelect',
      );

      expect(fromJson, equals(direct));
    });

    test('Hashcode is Correct', () {
      final component = FormComponent<CrossReferenceDataEntity>(
        property: 'name',
        data: CrossReferenceDataEntity(gridUri: Uri(path: '/grid')),
        field: const GridField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          type: DataType.crossReference,
        ),
        type: 'entitySelect',
      );

      expect(
        component.hashCode,
        Object.hash(
          component.field,
          component.property,
          component.data,
          component.options,
          component.required,
          component.type,
          component.enabled,
        ),
      );
    });
  });
}
