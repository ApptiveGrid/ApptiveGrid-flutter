import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'sorting': [],
      'entities': [
        {
          'fields': [
            [
              {
                'smallThumbnail': null,
                'url': 'https://attachment.com/id',
                'largeThumbnail': null,
                'name': '1.jpeg',
                'type': 'image/jpeg'
              }
            ]
          ],
          '_id': '619b63e84a391314968da9a0'
        },
      ],
      'fieldIds': ['80vw5xpimeeuxmoiftfqepbvc'],
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
                  'type': 'object',
                  'properties': {
                    'smallThumbnail': {'type': 'string'},
                    'url': {'type': 'string'},
                    'largeThumbnail': {'type': 'string'},
                    'name': {'type': 'string'},
                    'type': {'type': 'string'}
                  },
                  'required': ['url', 'type'],
                  'objectType': 'attachment'
                }
              }
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Grid 4 View',
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
    final rawResponseWithNullValue = {
      'fieldNames': ['name'],
      'sorting': [],
      'entities': [
        {
          'fields': [
            null,
          ],
          '_id': '619b63e84a391314968da9a0'
        },
      ],
      'fieldIds': ['80vw5xpimeeuxmoiftfqepbvc'],
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
                  'type': 'object',
                  'properties': {
                    'smallThumbnail': {'type': 'string'},
                    'url': {'type': 'string'},
                    'largeThumbnail': {'type': 'string'},
                    'name': {'type': 'string'},
                    'type': {'type': 'string'}
                  },
                  'required': ['url', 'type'],
                  'objectType': 'attachment'
                }
              }
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Grid 4 View',
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
        AttachmentDataEntity.fromJson(
          [
            {
              'smallThumbnail': null,
              'url': 'https://attachment.com/id',
              'largeThumbnail': null,
              'name': '1.jpeg',
              'type': 'image/jpeg'
            }
          ],
        ),
      );
    });

    test('Grid With null value Parses Correctly', () {
      final grid = Grid.fromJson(rawResponseWithNullValue);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        AttachmentDataEntity(),
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
      final responseWithAttachment = {
        'schema': {
          'type': 'object',
          'properties': {
            'c75385nsbbji82k5wntoj6sj2': {
              'type': 'array',
              'items': {
                'type': 'object',
                'properties': {
                  'smallThumbnail': {'type': 'string'},
                  'url': {'type': 'string'},
                  'largeThumbnail': {'type': 'string'},
                  'name': {'type': 'string'},
                  'type': {'type': 'string'}
                },
                'required': ['url', 'type'],
                'objectType': 'attachment'
              }
            },
            '347ps3ra879kvuxivaoy42onw': {'type': 'string'}
          },
          'required': []
        },
        'title': 'New title',
        'name': 'Form 1',
        'components': [
          {
            'property': 'name',
            'value': 'AttachmentTest',
            'required': false,
            'options': {
              'multi': false,
              'placeholder': null,
              'description': null,
              'label': null
            },
            'fieldId': '347ps3ra879kvuxivaoy42onw',
            'type': 'textfield'
          },
          {
            'property': 'New field',
            'value': [
              {
                'smallThumbnail': null,
                'url': 'https://attachment.com/id',
                'largeThumbnail': null,
                'name': 'anakin_cyrille.PNG',
                'type': 'image/png'
              }
            ],
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': 'c75385nsbbji82k5wntoj6sj2',
            'type': null
          }
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ]
      };

      final formData = FormData.fromJson(responseWithAttachment);

      final fromJson = formData.components[1] as AttachmentFormComponent;

      final directEntity = AttachmentDataEntity.fromJson([
        {
          'smallThumbnail': null,
          'url': 'https://attachment.com/id',
          'largeThumbnail': null,
          'name': 'anakin_cyrille.PNG',
          'type': 'image/png'
        }
      ]);

      final direct = AttachmentFormComponent(
        property: 'New field',
        data: directEntity,
        fieldId: 'c75385nsbbji82k5wntoj6sj2',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });

  group('Attachment', () {
    test('Thumbnail Urls are parsed', () {
      final attachment = Attachment.fromJson({
        'smallThumbnail': 'https://attachment.com/id/smallThumbnail',
        'url': 'https://attachment.com/id',
        'largeThumbnail': 'https://attachment.com/id/largeThumbnail',
        'name': 'anakin_cyrille.PNG',
        'type': 'image/png'
      });

      expect(
        attachment.smallThumbnail,
        equals(
          Uri(
            scheme: 'https',
            host: 'attachment.com',
            path: 'id/smallThumbnail',
          ),
        ),
      );
      expect(
        attachment.largeThumbnail,
        equals(
          Uri(
            scheme: 'https',
            host: 'attachment.com',
            path: 'id/largeThumbnail',
          ),
        ),
      );
    });

    test('Equality', () {
      final fromJson = Attachment.fromJson({
        'smallThumbnail': null,
        'url': 'https://attachment.com/id',
        'largeThumbnail': null,
        'name': 'anakin_cyrille.PNG',
        'type': 'image/png'
      });

      final direct = Attachment(
        name: 'anakin_cyrille.PNG',
        url: Uri.parse('https://attachment.com/id'),
        type: 'image/png',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
