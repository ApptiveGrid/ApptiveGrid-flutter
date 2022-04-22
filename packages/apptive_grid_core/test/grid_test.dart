import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    final json = {
      'fieldNames': [
        'TextC',
        'NumberC',
        'DateTimeC',
        'DateC',
        'New field',
        'New field 2',
        'CheckmarkC',
        'Enums',
      ],
      'entities': [
        {
          'fields': [
            'Hello',
            1,
            '2020-12-08T01:00:00.000Z',
            '2020-12-13',
            null,
            null,
            true,
            'Enum1'
          ],
          '_id': '3ojhtqm2bgtwzpdbktuv6syv5'
        },
        {
          'fields': [
            'Hola Web',
            1,
            '2020-12-14T09:12:00.000Z',
            '2020-12-15',
            null,
            null,
            true,
            'Enum2'
          ],
          '_id': '6bs7tqexlcy88cry3qzzvjbyz'
        },
        {
          'fields': [null, null, null, null, null, null, false, null],
          '_id': '6bs7tqf61rppn1nixxb6cr7se'
        },
        {
          'fields': [
            'AAA',
            null,
            '2020-12-14T11:42:00.000Z',
            '2020-12-17',
            null,
            null,
            true,
            'Enum2'
          ],
          '_id': 'bxzfxf43vaeefhje6xcmnofa8'
        },
        {
          'fields': [
            'TTTTTTT',
            12312344,
            '2020-12-14T06:00:00.000Z',
            '2020-12-16',
            null,
            null,
            true,
            null
          ],
          '_id': 'bxzfxf72k3j4d5fcmk6w0pa4s'
        },
      ],
      'fieldIds': [
        '4zc4l45nmww7ujq7y4axlbtjg',
        '4zc4l48ffin5v8pa2emyx9s15',
        '4zc4l4c5coyi7qh6q1ozrg54u',
        '4zc4l49to77dhfagr844flaey',
        '4zc4l48ez9l3p0gni56z9obo4',
        '4zc4l4ale6sfv3y40hly478z9',
        '4zc4l456pca5ursrt9rxefpsc',
        '4zc4l456pca5ursrt9rxef123'
      ],
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
              {'type': 'integer'},
              {'type': 'string', 'format': 'date-time'},
              {'type': 'string', 'format': 'date'},
              {'type': 'string'},
              {'type': 'string'},
              {'type': 'boolean'},
              {
                'type': 'string',
                'enum': [
                  'Enum1',
                  'Enum2',
                ]
              },
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'New grid',
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

    test('Parses json Response', () {
      final grid = Grid.fromJson(json);

      expect(grid.name, equals('New grid'));
      expect(grid.schema, isNot(null));
      expect(grid.fields!.length, equals(8));
      expect(grid.rows!.length, equals(5));

      final firstRow = grid.rows![0];
      expect(firstRow.entries[0].data.value, equals('Hello'));
      expect(firstRow.entries[1].data.value, equals(1));
      expect(firstRow.entries[7].data.value, equals('Enum1'));
      expect(
        (firstRow.entries[7].data as EnumDataEntity).options,
        ['Enum1', 'Enum2'],
      );
    });

    test('From Json == To Json -> FromJson', () {
      final initialData = Grid.fromJson(json);
      final saved = initialData.toJson();
      final restored = Grid.fromJson(saved);

      expect(saved, equals(json));
      expect(restored, equals(initialData));
      expect(restored.hashCode, equals(initialData.hashCode));
    });
  });
}
