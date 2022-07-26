import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['New field'],
      'sorting': [],
      'entities': [
        {
          "_id": "62a848a51c2fa741e99dc63d",
          "fields": [
            {"displayValue": "Example User", "uri": "/api/users/userId"},
          ],
          "_links": {
            "partialUpdate": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a848701c2fa741e99dc62c/entities/62a848a51c2fa741e99dc63d/update",
              "method": "post"
            },
            "self": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a848701c2fa741e99dc62c/entities/62a848a51c2fa741e99dc63d",
              "method": "get"
            },
            "update": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a848701c2fa741e99dc62c/entities/62a848a51c2fa741e99dc63d",
              "method": "put"
            },
            "remove": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a848701c2fa741e99dc62c/entities/62a848a51c2fa741e99dc63d",
              "method": "delete"
            },
            "addEditionLink": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a848701c2fa741e99dc62c/entities/62a848a51c2fa741e99dc63d/EditLink",
              "method": "post"
            }
          }
        }
      ],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "user",
            "componentTypes": ["userSelect"]
          },
          "schema": {
            "type": "object",
            "properties": {
              "displayValue": {"type": "string"},
              "uri": {"type": "string"}
            },
            "required": ["uri"]
          },
          "id": "62a8486f1c2fa741e99dc628",
          "name": "name",
          "key": null,
          "_links": {
            "patch": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a8486f1c2fa741e99dc629/fields/62a8486f1c2fa741e99dc628",
              "method": "patch"
            },
            "query": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a8486f1c2fa741e99dc629/fields/62a8486f1c2fa741e99dc628/query",
              "method": "get"
            },
            "collaborators": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a8486f1c2fa741e99dc629/fields/62a8486f1c2fa741e99dc628/collaborators",
              "method": "get"
            },
            "self": {
              "href":
                  "/api/users/614c5440b50f51e3ea8a2a50/spaces/62a848431c2fa741e99dc625/grids/62a8486f1c2fa741e99dc629/fields/62a8486f1c2fa741e99dc628",
              "method": "get"
            }
          }
        },
      ],
      'name': 'Yeah Ansicht',
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
      expect(grid.rows!.length, equals(1));
    });

    test('User', () {
      final grid = Grid.fromJson(rawResponse);
      expect(
        grid.rows![0].entries.first.data,
        UserDataEntity(
          DataUser(
            displayValue: 'Example User',
            uri: Uri.parse('/api/users/userId'),
          ),
        ),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = UserDataEntity.fromJson({
        'displayValue': 'Jane Doe',
        'uri': '/api/users/userId',
      });
      final b = UserDataEntity.fromJson({
        'displayValue': 'Jane Doe',
        'uri': '/api/users/userId',
      });

      final c = UserDataEntity.fromJson({
        'displayValue': 'John Doe',
        'uri': '/api/users/differentId',
      });
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('DataUser', () {
    test('Equality', () {
      final one = DataUser(
        displayValue: 'Jane Doe',
        uri: Uri.parse('/api/users/userId'),
      );

      final two = DataUser.fromJson(
        {
          'displayValue': 'Jane Doe',
          'uri': '/api/users/userId',
        },
      );

      expect(one, equals(two));
      expect(one.hashCode, equals(two.hashCode));
    });

    test('toString', () {
      final user = DataUser(
        displayValue: 'Jane Doe',
        uri: Uri.parse('/api/users/userId'),
      );

      expect(
        user.toString(),
        equals('DataUser(displayValue: Jane Doe, uri: /api/users/userId)'),
      );
    });
  });
}
