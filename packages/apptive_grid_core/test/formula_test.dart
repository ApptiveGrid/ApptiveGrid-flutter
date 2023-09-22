import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Map<DataType, dynamic> supportedTypes = {
    DataType.integer: 2,
    DataType.decimal: 2.5,
    DataType.text: 'olleh',
    DataType.dateTime: DateTime(2000).toIso8601String(),
    DataType.date: DateTime(2000).toIso8601String(),
  };
  for (final valueType in supportedTypes.entries) {
    group('Value type ${valueType.key.backendName}', () {
      final valueGridField =
          GridField(id: 'id', name: 'name', type: valueType.key);
      final valueDataEntity = DataEntity.fromJson(
        json: valueType.value,
        field: valueGridField,
      );
      group('Grid', () {
        final rawResponse = {
          'fieldNames': ['name'],
          'entities': [
            {
              'fields': [
                {
                  'value': valueType.value,
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
              "schema": {},
              "name": "Formula Field",
              "type": {
                "name": "formula",
                "typeName": "formula",
                "expression": "test",
                "valueType": {
                  "name": valueType.key.backendName,
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
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRemove",
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
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRename",
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
          final referenceValue = FormulaDataEntity(value: valueDataEntity);
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
            FormulaField(
              id: 'id',
              name: 'Formula',
              key: 'key',
              links: {},
              expression: 'test',
              valueType: valueType.key,
              schema: {},
            ).toString(),
            'FormulaField(id: id, name: Formula, key: key, expression: test, valueType: ${valueType.key.backendName})',
          );
        });

        test('Hashcode', () {
          final field = FormulaField(
            id: 'id',
            name: 'Formula',
            key: 'key',
            links: {},
            expression: 'test',
            valueType: valueType.key,
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
                'test',
                valueType.key,
              ),
            ),
          );
        });
      });

      group('DataEntity', () {
        test('Equality', () {
          final a = FormulaDataEntity(value: valueDataEntity);
          final b = FormulaDataEntity(value: valueDataEntity);
          final c = FormulaDataEntity(value: StringDataEntity('exeption'));
          expect(a, equals(b));
          expect(a, isNot(c));
        });

        test('Hashcode', () {
          final formula = FormulaDataEntity(value: valueDataEntity);

          expect(
            formula.hashCode,
            Object.hash(
              valueDataEntity,
              null,
            ),
          );
        });

        test('toString()', () {
          final formula = FormulaDataEntity(value: valueDataEntity);

          expect(
            formula.toString(),
            equals(
              'FormulaDataEntity(value: ${valueDataEntity.schemaValue}, error: null)',
            ),
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
                "schema": {},
                "name": "name",
                "type": {
                  "name": "formula",
                  "typeName": "formula",
                  "expression": "test",
                  "valueType": {
                    "name": valueType.key.backendName,
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
                },
              }
            ],
            'schemaObject':
                '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
            'components': [
              {
                'property': 'name',
                'value': {'value': valueType.value},
                'required': false,
                'options': {'label': null, 'description': null},
                'fieldId': '3ftoqhqbct15h5o730uknpvp5',
                'type': 'textfield',
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

          final directEntity = FormulaDataEntity(value: valueDataEntity);

          final direct = FormComponent<FormulaDataEntity>(
            property: 'name',
            data: directEntity,
            field: FormulaField(
              id: '3ftoqhqbct15h5o730uknpvp5',
              name: 'name',
              expression: 'test',
              valueType: valueType.key,
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
              },
              schema: {},
            ),
            type: 'textfield',
          );

          expect(fromJson.cast<FormulaDataEntity>(), equals(direct));
        });

        test('Hashcode', () {
          final directEntity = FormulaDataEntity(value: IntegerDataEntity(2));
          final component = FormComponent<FormulaDataEntity>(
            property: 'New field',
            data: directEntity,
            field: valueGridField,
            type: 'textfield',
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
    });
  }
}
