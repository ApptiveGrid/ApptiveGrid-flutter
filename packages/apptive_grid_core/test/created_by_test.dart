import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['New field'],
      'sorting': [],
      'entities': [
        {
          'fields': [null],
          '_id': '61eeab7586c4f19eee92f1a6',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        },
        {
          'fields': [
            {
              'name': 'jane.doe@2denker.de',
              'displayValue': 'Jane Doe',
              'id': 'userId',
              'type': 'user',
            }
          ],
          '_id': '61eeab8286c4f19eee92f1e0',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        },
        {
          'fields': [
            {
              'name': '',
              'displayValue': '',
              'id': '61eeac4686c4f1d22992f260',
              'type': 'link',
            }
          ],
          '_id': '61eeac6486c4f1885092f263',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        },
        {
          'fields': [
            {
              'name': '',
              'displayValue': '',
              'id': '61eeac4686c4f1d22992f263',
              'type': 'accesscredentials',
            }
          ],
          '_id': '61eeac6486c4f1885092f263',
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
            "name": "createdby",
            "componentTypes": ["textfield"],
          },
          "key": null,
          "name": "UserRef",
          "schema": {
            "type": "object",
            "properties": {
              "displayValue": {"type": "string", "format": "string"},
              "id": {"type": "string", "format": "string"},
              "type": {"type": "string", "format": "string"},
              "name": {"type": "string", "format": "string"},
            },
            "objectType": "userReference",
          },
          "id": "628210d604bd30b6b19b7f9d",
          "_links": <String, dynamic>{},
        },
      ],
      'name': 'Yeah Ansicht',
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
      expect(grid.rows!.length, equals(4));
    });

    group('CreatedBy Type', () {
      final grid = Grid.fromJson(rawResponse);

      test('Null', () {
        expect(
          grid.rows![0].entries.first.data,
          CreatedByDataEntity(),
        );
      });

      test('User', () {
        expect(
          grid.rows![1].entries.first.data,
          CreatedByDataEntity(
            const CreatedBy(
              id: 'userId',
              type: CreatedByType.user,
              displayValue: 'Jane Doe',
              name: 'jane.doe@2denker.de',
            ),
          ),
        );
      });

      test('Form Link', () {
        expect(
          grid.rows![2].entries.first.data,
          CreatedByDataEntity(
            const CreatedBy(
              id: '61eeac4686c4f1d22992f260',
              type: CreatedByType.formLink,
              displayValue: '',
              name: '',
            ),
          ),
        );
      });

      test('Api Key', () {
        expect(
          grid.rows![3].entries.first.data,
          CreatedByDataEntity(
            const CreatedBy(
              id: '61eeac4686c4f1d22992f263',
              type: CreatedByType.apiCredentials,
              displayValue: '',
              name: '',
            ),
          ),
        );
      });
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = CreatedByDataEntity.fromJson({
        'name': 'jane.doe@2denker.de',
        'displayValue': 'Jane Doe',
        'id': 'userId',
        'type': 'user',
      });
      final b = CreatedByDataEntity.fromJson({
        'name': 'jane.doe@2denker.de',
        'displayValue': 'Jane Doe',
        'id': 'userId',
        'type': 'user',
      });
      final c = CreatedByDataEntity.fromJson({
        'name': '',
        'displayValue': '',
        'id': 'userId',
        'type': 'accesscredentials',
      });
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('CreatedBy', () {
    test('Equality', () {
      const one = CreatedBy(
        id: 'userId',
        type: CreatedByType.user,
        displayValue: 'Jane Doe',
        name: 'jane.doe@2denker.de',
      );

      final two = CreatedBy.fromJson(
        {
          'name': 'jane.doe@2denker.de',
          'displayValue': 'Jane Doe',
          'id': 'userId',
          'type': 'user',
        },
      );

      expect(one, equals(two));
      expect(one.hashCode, equals(two.hashCode));
    });

    test('toString()', () {
      const createdBy = CreatedBy(
        id: 'userId',
        type: CreatedByType.user,
        displayValue: 'Jane Doe',
        name: 'jane.doe@2denker.de',
      );

      expect(
        createdBy.toString(),
        equals(
          'CreatedBy(displayValue: Jane Doe, id: userId, name: jane.doe@2denker.de, type: user)',
        ),
      );
    });
  });
}
