import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['multi enum'],
      'sorting': [],
      'entities': [
        {
          'fields': [
            ['A', 'C']
          ],
          '_id': '61af483b85182c9a4e8eee91'
        },
      ],
      'fieldIds': ['8ou8s82tahpyqoowd0izr1nzm'],
      'filter': {},
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {
                'type': 'array',
                'items': {
                  'type': 'string',
                  'enum': ['A', 'B', 'C']
                }
              }
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Name',
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
      expect(
        grid.rows![0].entries[0].data,
        EnumCollectionDataEntity(value: {'A', 'C'}, options: {'A', 'B', 'C'}),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(
        jsonDecode(jsonEncode(fromJson.toJson())),
        equals(jsonDecode(jsonEncode(rawResponse))),
      );
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithEnumCollection = {
        'schema': {
          'type': 'object',
          'properties': {
            'c75385nsbbji82k5wntoj6sj2': {
              'type': 'array',
              'items': {
                'type': 'string',
                'enum': ['GmbH', 'AG', 'Freiberuflich']
              }
            },
          },
          'required': []
        },
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
            'type': null
          },
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ]
      };

      final formData = FormData.fromJson(responseWithEnumCollection);

      final fromJson = formData.components.first as EnumCollectionFormComponent;

      final directEntity = EnumCollectionDataEntity(
        value: {'AG', 'GmbH'},
        options: {
          'GmbH',
          'AG',
          'Freiberuflich',
        },
      );

      final direct = EnumCollectionFormComponent(
        property: 'New field',
        data: directEntity,
        fieldId: 'c75385nsbbji82k5wntoj6sj2',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
