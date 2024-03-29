import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final apptiveGridUri = Uri.parse('https://apptivegrid.de');
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': ['https://apptivegrid.de'],
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
          "fieldId": "62bab0b25e92ba8e899edeea",
          "id": "62bab0b25e92ba8e899edeea",
          "name": "name",
          "type": {"name": "uri"},
        },
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
      final referenceValue = UriDataEntity(apptiveGridUri);
      expect(
        grid.rows![0].entries[0].data,
        equals(referenceValue),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = UriDataEntity(apptiveGridUri);
      final b = UriDataEntity.fromJson('https://apptivegrid.de');
      final c = UriDataEntity.fromJson('https://apptivegrid.de/with/path');
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithMultiCrossReference = {
        'fields': [
          {
            "fieldId": "62bab0b25e92ba8e899edeea",
            "id": "62bab0b25e92ba8e899edeea",
            "name": "name",
            "type": {"name": "uri"},
          },
        ],
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': 'https://apptivegrid.de',
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '62bab0b25e92ba8e899edeea',
            'type': 'text',
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

      final directEntity = UriDataEntity(apptiveGridUri);

      final direct = FormComponent<UriDataEntity>(
        property: 'name',
        data: directEntity,
        field: const GridField(
          id: '62bab0b25e92ba8e899edeea',
          name: 'name',
          type: DataType.uri,
        ),
        type: 'text',
      );

      expect(fromJson.cast<UriDataEntity>(), equals(direct));
    });

    test('Hashcode', () {
      const field =
          GridField(id: 'id', name: 'property', type: DataType.attachment);

      final directEntity = UriDataEntity();
      final component = FormComponent<UriDataEntity>(
        property: 'New field',
        data: directEntity,
        field: field,
        type: 'text',
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
