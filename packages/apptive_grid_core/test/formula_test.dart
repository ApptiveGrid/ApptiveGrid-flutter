import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['name'],
      'entities': [
        {
          'fields': [
            {
              'value': 2,
              'error': null,
            },
          ],
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
          "key": null,
          "id": "fieldId",
          "schema": {"type": "number", "format": "float"},
          "name": "Formula Field",
          "type": {
            "name": "formula",
            "typeName": "formula",
            "expression": "1+1",
            "valueType": {
              "name": "integer",
              "componentTypes": ["textfield"],
            },
            "componentTypes": ["textfield"],
          },
          "_links": {
            "patch": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
              "method": "patch",
            },
            "query": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/query",
              "method": "get",
            },
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
              "method": "get",
            },
            "currencies": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies",
              "method": "get",
            },
          },
        }
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
      final referenceValue = FormulaDataEntity(value: IntegerDataEntity(2));
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
    test('FormulaField toString() produces expected Outcome', () {
      expect(
        const FormulaField(
          id: 'id',
          name: 'Formula',
          key: 'key',
          links: {},
          expression: '1+1',
          valueType: DataType.integer,
          schema: {},
        ).toString(),
        'FormulaField(id: id, name: Formula, key: key, expression: 1+1, valueType: integer)',
      );
    });

    test('Hashcode', () {
      const field = FormulaField(
        id: 'id',
        name: 'Formula',
        key: 'key',
        links: {},
        expression: '1+1',
        valueType: DataType.integer,
        schema: {},
      );

      expect(
        field.hashCode,
        equals(
          Object.hash(
            GridField(
              id: field.id,
              name: field.name,
              type: field.type,
              key: field.key,
              links: field.links,
              schema: field.schema,
            ),
            '1+1',
            DataType.integer,
          ),
        ),
      );
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = FormulaDataEntity(value: IntegerDataEntity(2));
      final b = FormulaDataEntity(value: IntegerDataEntity(2));
      final c = FormulaDataEntity(value: StringDataEntity('test'));
      expect(a, equals(b));
      expect(a, isNot(c));
    });

    test('Hashcode', () {
      final formula = FormulaDataEntity(value: IntegerDataEntity(2));

      expect(
        formula.hashCode,
        Object.hash(
          IntegerDataEntity(2),
          null,
        ),
      );
    });

    test('toString()', () {
      final formula = FormulaDataEntity(value: IntegerDataEntity(2));

      expect(
        formula.toString(),
        equals('FormulaDataEntity(value: 2, error: null)'),
      );
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithFormula = {
        'fields': [
          {
            "key": null,
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "schema": {"type": "number", "format": "float"},
            "name": "name",
            "type": {
              "name": "formula",
              "typeName": "formula",
              "expression": "1+1",
              "valueType": {
                "name": "integer",
                "componentTypes": ["textfield"],
              },
              "componentTypes": ["textfield"],
            },
            "_links": {
              "patch": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
                "method": "patch",
              },
              "query": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/query",
                "method": "get",
              },
              "self": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
                "method": "get",
              },
              "currencies": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies",
                "method": "get",
              },
            },
          }
        ],
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': {'value': 2},
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'multiSelectDropdown',
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

      final formData = FormData.fromJson(responseWithFormula);

      final fromJson = formData.components![0];

      final directEntity = FormulaDataEntity(value: IntegerDataEntity(2));

      final direct = FormComponent<FormulaDataEntity>(
        property: 'name',
        data: directEntity,
        field: FormulaField(
          id: '3ftoqhqbct15h5o730uknpvp5',
          name: 'name',
          expression: '1+1',
          valueType: DataType.integer,
          links: {
            ApptiveLinkType.patch: ApptiveLink(
              uri: Uri.parse(
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
              ),
              method: 'patch',
            ),
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse(
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
              ),
              method: 'get',
            ),
            ApptiveLinkType.query: ApptiveLink(
              uri: Uri.parse(
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/query',
              ),
              method: 'get',
            ),
            ApptiveLinkType.currencies: ApptiveLink(
              uri: Uri.parse(
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId/currencies',
              ),
              method: 'get',
            ),
          },
          schema: {"type": "number", "format": "float"},
        ),
        type: 'multiSelectDropdown',
      );

      expect(fromJson.cast<FormulaDataEntity>(), equals(direct));
    });

    test('Hashcode', () {
      const field =
          GridField(id: 'id', name: 'property', type: DataType.attachment);

      final directEntity = FormulaDataEntity(value: IntegerDataEntity(2));
      final component = FormComponent<FormulaDataEntity>(
        property: 'New field',
        data: directEntity,
        field: field,
        type: 'multiSelectDropdown',
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
        ),
      );
    });
  });
}
