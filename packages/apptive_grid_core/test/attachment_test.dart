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
          '_id': '619b63e84a391314968da9a0',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
      ],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "attachments",
            "componentTypes": ["filePicker"]
          },
          "key": null,
          "name": "Attachment",
          "schema": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "smallThumbnail": {"type": "string"},
                "url": {"type": "string"},
                "largeThumbnail": {"type": "string"},
                "name": {"type": "string"},
                "type": {"type": "string"}
              },
              "required": ["url", "type"],
              "objectType": "attachment"
            }
          },
          "id": "628210b904bd301aa89b7f81",
          "_links": <String, dynamic>{}
        }
      ],
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
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "attachments",
            "componentTypes": ["filePicker"]
          },
          "key": null,
          "name": "Attachment",
          "schema": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "smallThumbnail": {"type": "string"},
                "url": {"type": "string"},
                "largeThumbnail": {"type": "string"},
                "name": {"type": "string"},
                "type": {"type": "string"}
              },
              "required": ["url", "type"],
              "objectType": "attachment"
            }
          },
          "id": "628210b904bd301aa89b7f81",
          "_links": <String, dynamic>{}
        }
      ],
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

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithAttachment = {
        'fields': [
          {
            "type": {
              "name": "attachments",
              "componentTypes": ["filePicker"]
            },
            "schema": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "smallThumbnail": {"type": "string", "format": "string"},
                  "url": {"type": "string", "format": "string"},
                  "largeThumbnail": {"type": "string", "format": "string"},
                  "name": {"type": "string", "format": "string"},
                  "type": {"type": "string", "format": "string"}
                },
                "required": ["url", "type"],
                "objectType": "attachment"
              }
            },
            "id": "id",
            "name": "property",
            "key": null,
            "_links": <String, dynamic>{}
          }
        ],
        'title': 'New title',
        'name': 'Form 1',
        'components': [
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
            'fieldId': 'id',
            'type': null
          }
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ],
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post"
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete"
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get"
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put"
          }
        },
      };

      final formData = FormData.fromJson(responseWithAttachment);

      final fromJson = formData.components![0];

      final directEntity = AttachmentDataEntity.fromJson([
        {
          'smallThumbnail': null,
          'url': 'https://attachment.com/id',
          'largeThumbnail': null,
          'name': 'anakin_cyrille.PNG',
          'type': 'image/png'
        }
      ]);

      const field =
          GridField(id: 'id', name: 'property', type: DataType.attachment);
      final direct = FormComponent<AttachmentDataEntity>(
        property: 'New field',
        data: directEntity,
        field: field,
      );

      expect(fromJson, equals(direct));
    });

    test('Hashcode', () {
      const field =
          GridField(id: 'id', name: 'property', type: DataType.attachment);

      final directEntity = AttachmentDataEntity.fromJson([
        {
          'smallThumbnail': null,
          'url': 'https://attachment.com/id',
          'largeThumbnail': null,
          'name': 'anakin_cyrille.PNG',
          'type': 'image/png'
        }
      ]);
      final component = FormComponent<AttachmentDataEntity>(
        property: 'New field',
        data: directEntity,
        field: field,
      );

      expect(
        component.hashCode,
        Object.hash(
          component.field,
          component.property,
          component.data,
          component.options,
          component.required,
        ),
      );
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
    });
  });
}
