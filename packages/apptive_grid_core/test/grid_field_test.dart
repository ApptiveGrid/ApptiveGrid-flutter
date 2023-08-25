import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('is equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      const a = GridField(id: id, name: name, type: type);
      const b = GridField(id: id, name: name, type: type);

      expect(a, equals(b));
    });

    test('is not equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      const a = GridField(id: id, name: name, type: type);
      const b = GridField(id: name, name: id, type: type);

      expect(a, isNot(b));
    });
  });

  group('Json Parsing', () {
    test('Parses from and to json', () {
      final json = {
        "type": {
          "name": "enum",
          "options": ["a", "b"],
          "componentTypes": ["selectBox"],
        },
        "key": "keyTest",
        "name": "name",
        "schema": {
          "type": "string",
          "enum": ["a", "b"],
        },
        "id": "ep8m43a1i4v1lgj4q8r31ba2f",
        "_links": <String, dynamic>{},
      };

      final fromJson = GridField.fromJson(json);

      expect(fromJson.id, 'ep8m43a1i4v1lgj4q8r31ba2f');
      expect(fromJson.name, 'name');
      expect(fromJson.key, 'keyTest');
      expect(fromJson.type, DataType.singleSelect);

      expect(GridField.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('CreatedBy type is parsed correctly', () {
      final json = {
        "key": null,
        "id": "fieldId",
        "schema": {
          "type": "object",
          "properties": {
            "displayValue": {"type": "string", "format": "string"},
            "id": {"type": "string", "format": "string"},
            "type": {"type": "string", "format": "string"},
            "name": {"type": "string", "format": "string"},
          },
          "objectType": "userReference",
        },
        "name": "Created by",
        "type": {
          "name": "createdby",
          "typeName": "createdby",
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
      };

      final fromJson = GridField.fromJson(json);

      expect(fromJson.type, DataType.createdBy);
    });
  });
}
