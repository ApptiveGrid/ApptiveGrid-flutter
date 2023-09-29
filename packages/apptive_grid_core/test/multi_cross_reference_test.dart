import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [
            [
              {
                'displayValue': 'Yeah!',
                'uri':
                    '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
              }
            ]
          ],
          '_id': '60d0370e0edfa83071816e12',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        }
      ],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "references",
            "componentTypes": ["multiSelectDropdown"],
          },
          "key": null,
          "name": "Multi Cross",
          "schema": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "displayValue": {"type": "string"},
                "uri": {"type": "string"},
              },
              "required": ["uri"],
              "objectType": "entityreference",
              "gridUri":
                  "/api/users/userId/spaces/spaceId/grids/referencedGridId",
            },
          },
          "id": "628210cb04bd301aa89b7f93",
          "_links": <String, dynamic>{},
        }
      ],
      'name': 'New grid view',
      'id': 'gridId',
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
      final referenceValue = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );
      expect(
        grid.rows![0].entries[0].data,
        equals(referenceValue),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });

    test('GridUri is parsed Correctly', () {
      final dataEntity = Grid.fromJson(rawResponse).rows![0].entries[0].data
          as MultiCrossReferenceDataEntity;

      expect(
        dataEntity.gridUri.toString(),
        (rawResponse['fields'] as List).first['schema']['items']['gridUri'],
      );
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );
      final b = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );
      final c = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: null,
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );
      expect(a, equals(b));
      expect(a, isNot(c));
    });

    test('Hashcode', () {
      final entity = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );

      expect(
        entity.hashCode,
        equals(
          Object.hash(
            entity.value,
            '/api/users/userId/spaces/spaceId/grids/referencedGridId',
          ),
        ),
      );
    });

    test('toString()', () {
      final entity = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );

      expect(
        entity.toString(),
        equals(
          'MultiCrossReferenceDataEntity(references: [CrossReferenceDataEntity(displayValue: Yeah!, entityUri: /api/users/userId/spaces/spaceId/grids/gridId/entities/entityId, gridUri: /api/users/userId/spaces/spaceId/grids/referencedGridId)], gridUri: /api/users/userId/spaces/spaceId/grids/referencedGridId)',
        ),
      );
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithMultiCrossReference = {
        'fields': [
          {
            "type": {
              "name": "references",
              "componentTypes": ["multiSelectDropdown"],
            },
            "schema": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "displayValue": {"type": "string"},
                  "uri": {"type": "string"},
                },
                "required": ["uri"],
                "objectType": "entityreference",
                "gridUri":
                    "/api/users/userId/spaces/spaceId/grids/referencedGridId",
              },
            },
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "name": "name",
            "key": null,
            "_links": <String, dynamic>{},
          }
        ],
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': [
              {
                'displayValue': 'Yeah!',
                'uri':
                    '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
              }
            ],
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'multiSelectDropdown',
          }
        ],
        'name': 'New Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "post",
          },
          "remove": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "delete",
          },
          "self": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "get",
          },
          "update": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "put",
          },
        },
      };

      final formData = FormData.fromJson(responseWithMultiCrossReference);

      final fromJson = formData.components![0];

      final directEntity = MultiCrossReferenceDataEntity.fromJson(
        jsonValue: [
          {
            'displayValue': 'Yeah!',
            'uri':
                '/api/users/userId/spaces/spaceId/grids/gridId/entities/entityId',
          }
        ],
        gridUri: '/api/users/userId/spaces/spaceId/grids/referencedGridId',
      );

      final direct = FormComponent<MultiCrossReferenceDataEntity>(
        property: 'name',
        data: directEntity,
        field: const GridField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          type: DataType.multiCrossReference,
        ),
        type: 'multiSelectDropdown',
      );

      expect(fromJson, equals(direct));
    });

    test('Hashcode', () {
      const field =
          GridField(id: 'id', name: 'property', type: DataType.attachment);

      final directEntity =
          MultiCrossReferenceDataEntity(gridUri: Uri(path: 'gridUri'));
      final component = FormComponent<MultiCrossReferenceDataEntity>(
        property: 'New field',
        data: directEntity,
        field: field,
        type: 'multiSelectDropdown',
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
