import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [
            12345.12,
          ],
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
          "key": null,
          "id": "fieldId",
          "schema": {"type": "number", "format": "float"},
          "name": "Currency Field",
          "type": {
            "name": "currency",
            "typeName": "currency",
            "currency": "USD",
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
            },
            "currencies": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies",
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
      final referenceValue =
          CurrencyDataEntity(currency: 'USD', value: 12345.12);
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

  group('GridFied', () {
    test('CurrencyGridField toString() produces expected Outcome', () {
      expect(
        const CurrencyGridField(
          id: 'id',
          name: 'Currency',
          key: 'key',
          links: {},
          currency: 'USD',
        ).toString(),
        'CurrencyGridField(id: id, name: Currency, key: key, currency: USD)',
      );
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = CurrencyDataEntity(currency: 'USD', value: 12345.12);
      final b = CurrencyDataEntity(currency: 'USD', value: 12345.12);
      final c = CurrencyDataEntity(currency: 'EUR', value: 12345.12);
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithMultiCrossReference = {
        'fields': [
          {
            "key": null,
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "schema": {"type": "number", "format": "float"},
            "name": "name",
            "type": {
              "name": "currency",
              "typeName": "currency",
              "currency": "USD",
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
              },
              "currencies": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies",
                "method": "get"
              }
            }
          }
        ],
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': 12345.12,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'multiSelectDropdown'
          }
        ],
        'name': 'New Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "post"
          },
          "remove": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "delete"
          },
          "self": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "get"
          },
          "update": {
            "href":
                "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
            "method": "put"
          }
        },
      };

      final formData = FormData.fromJson(responseWithMultiCrossReference);

      final fromJson = formData.components![0];

      final directEntity = CurrencyDataEntity(currency: 'USD', value: 12345.12);

      final direct = FormComponent<CurrencyDataEntity>(
        property: 'name',
        data: directEntity,
        field: CurrencyGridField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          currency: 'USD',
          links: {
            ApptiveLinkType.patch: ApptiveLink(
              uri: Uri.parse(
                  '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',),
              method: 'patch',
            ),
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse(
                  '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',),
              method: 'get',
            ),
            ApptiveLinkType.query: ApptiveLink(
              uri: Uri.parse(
                  '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/query',),
              method: 'get',
            ),
            ApptiveLinkType.currencies: ApptiveLink(
              uri: Uri.parse(
                  '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies',),
              method: 'get',
            ),
          },
          schema: {"type": "number", "format": "float"},
        ),
      );

      expect(fromJson.cast<CurrencyDataEntity>(), equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });
}
