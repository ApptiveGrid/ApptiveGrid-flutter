import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['multi enum'],
      'sorting': [],
      'entities': [
        {
          'fields': [
            ['A', 'C'],
          ],
          '_id': '61af483b85182c9a4e8eee91',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        },
      ],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "enumcollection",
            "componentTypes": ["multiSelectDropdown"],
          },
          "key": null,
          "name": "MultiSelect",
          "schema": {
            "type": "array",
            "items": {
              "type": "string",
              "enum": ["A", "B", "C"],
            },
          },
          "id": "6282109204bd30163b9b7f5f",
          "_links": <String, dynamic>{},
        },
      ],
      'name': 'Name',
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
      expect(
        grid.rows![0].entries[0].data,
        EnumCollectionDataEntity(value: {'A', 'C'}, options: {'A', 'B', 'C'}),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithEnumCollection = {
        'fields': [
          {
            "type": {
              "name": "enumcollection",
              "componentTypes": ["multiSelectDropdown"],
            },
            "schema": {
              "type": "array",
              "items": {
                "type": "string",
                "enum": [
                  'GmbH',
                  'AG',
                  'Freiberuflich',
                ],
              },
            },
            "id": "c75385nsbbji82k5wntoj6sj2",
            "name": "name",
            "key": null,
            "_links": <String, dynamic>{},
          }
        ],
        'title': 'New title',
        'name': 'Form 1',
        'components': [
          {
            'property': 'New field',
            'value': [
              "AG",
              "GmbH",
            ],
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': 'c75385nsbbji82k5wntoj6sj2',
            'type': null,
          },
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'},
        ],
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

      final formData = FormData.fromJson(responseWithEnumCollection);

      final fromJson = formData.components!.first;

      final directEntity = EnumCollectionDataEntity(
        value: {'AG', 'GmbH'},
        options: {
          'GmbH',
          'AG',
          'Freiberuflich',
        },
      );

      final direct = FormComponent<EnumCollectionDataEntity>(
        property: 'New field',
        data: directEntity,
        field: const GridField(
          id: 'c75385nsbbji82k5wntoj6sj2',
          name: 'name',
          type: DataType.enumCollection,
        ),
      );

      expect(fromJson, equals(direct));
    });
  });
}
