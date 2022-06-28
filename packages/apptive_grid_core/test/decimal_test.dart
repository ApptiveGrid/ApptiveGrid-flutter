import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [47.11],
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
      'fieldIds': ['3ftoqhqbct15h5o730uknpvp5'],
      'filter': {},
      'fields': [
        {
          "type": {
            "name": "decimal",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "Decimal",
          "schema": {"type": "number", "format": "float"},
          "id": "6282107404bd30163b9b7f44",
          "_links": <String, dynamic>{}
        },
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
      expect(grid.rows![0].entries[0].data, equals(DecimalDataEntity(47.11)));
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), equals(fromJson));
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = DecimalDataEntity(47.11);
      final b = DecimalDataEntity(47.11);
      final c = DecimalDataEntity(11.47);
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithCrossReference = {
        'fields': [
          {
            "type": {
              "name": "decimal",
              "componentTypes": ["textfield"]
            },
            "schema": {"type": "number", "format": "float"},
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "name": "name",
            "key": null,
            "_links": <String, dynamic>{}
          }
        ],
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': 47.11,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'name': 'New Name',
        'title': 'New title',
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

      final formData = FormData.fromJson(responseWithCrossReference);

      final fromJson = formData.components![0];

      final directEntity = DecimalDataEntity(47.11);

      final direct = FormComponent<DecimalDataEntity>(
        property: 'name',
        data: directEntity,
        field: const GridField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          type: DataType.decimal,
        ),
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
