import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('is equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      final a = GridField(id: id, name: name, type: type);
      final b = GridField(id: id, name: name, type: type);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('is not equal', () {
      const id = 'id';
      const name = 'name';
      const type = DataType.text;
      final a = GridField(id: id, name: name, type: type);
      final b = GridField(id: name, name: id, type: type);

      expect(a, isNot(b));
      expect(a.hashCode, isNot(b.hashCode));
    });
  });

  group('Json Parsing', () {
    test('Parses from and to json', () {
      final json = {
        "type": {
          "name": "enum",
          "options": ["a", "b"],
          "componentTypes": ["selectBox"]
        },
        "key": "keyTest",
        "name": "name",
        "schema": {
          "type": "string",
          "enum": ["a", "b"]
        },
        "id": "ep8m43a1i4v1lgj4q8r31ba2f",
        "_links": <String, dynamic>{}
      };

      final fromJson = GridField.fromJson(json);

      expect(fromJson.id, 'ep8m43a1i4v1lgj4q8r31ba2f');
      expect(fromJson.name, 'name');
      expect(fromJson.key, 'keyTest');
      expect(fromJson.type, DataType.singleSelect);

      expect(GridField.fromJson(fromJson.toJson()), equals(fromJson));
    });
  });
}
