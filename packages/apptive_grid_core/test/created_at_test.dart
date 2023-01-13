import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': ["2023-01-13T09:22:04.783888+00:00"],
          '_id': '60d0370e0edfa83071816e12',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        }
      ],
      'filter': {},
      'fields': [
        {
          "key": null,
          "id": "fieldId",
          "schema": {"type": "string", "format": "date-time"},
          "name": "Created At",
          "type": {
            "name": "createdat",
            "typeName": "createdat",
            "componentTypes": ["textfield"]
          },
          "_links": {
            "patch": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
              "method": "patch"
            },
            "query": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/query",
              "method": "get"
            },
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
              "method": "get"
            }
          }
        }
      ],
      'name': 'New grid view',
      'id': 'gridId',
      '_links': {
        "addLink": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/AddLink",
          "method": "post"
        },
        "forms": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "get"
        },
        "updateFieldType": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnTypeChange",
          "method": "post"
        },
        "removeField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRemove",
          "method": "post"
        },
        "addEntity": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "post"
        },
        "views": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "get"
        },
        "addView": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "post"
        },
        "self": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "get"
        },
        "updateFieldKey": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnKeyChange",
          "method": "post"
        },
        "query": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/query",
          "method": "get"
        },
        "entities": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "get"
        },
        "updates": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/updates",
          "method": "get"
        },
        "schema": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/schema",
          "method": "get"
        },
        "updateFieldName": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRename",
          "method": "post"
        },
        "addForm": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "post"
        },
        "addField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnAdd",
          "method": "post"
        },
        "rename": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/Rename",
          "method": "post"
        },
        "remove": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "delete"
        }
      },
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields!.length, equals(1));
      expect(grid.fields!.first.type, equals(DataType.createdAt));
      expect(
        grid.rows![0].entries[0].data,
        equals(
          DateTimeDataEntity.fromJson("2023-01-13T09:22:04.783888+00:00"),
        ),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), equals(fromJson));
    });
  });
}
