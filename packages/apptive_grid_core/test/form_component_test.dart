import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Casting', () {
    test('Cast method works', () {
      const field = GridField(
        id: 'id',
        name: 'Property',
        type: DataType.text,
      );

      final jsonComponent = FormComponent.fromJson({
        "fieldId": "id",
        "type": "textfield",
        "value": null,
        "options": {
          "multi": false,
          "placeholder": null,
          "description": null,
          "label": null
        },
        "required": true,
        "property": "Text",
        "_links": <String, dynamic>{}
      }, [
        field
      ]);

      expect(jsonComponent.runtimeType, FormComponent<DataEntity>);
      final castedComponent = jsonComponent.cast<StringDataEntity>();

      expect(castedComponent.runtimeType, FormComponent<StringDataEntity>);
    });
  });

  group('toString()', () {
    test('To String produces expected outcome', () {
      expect(
        FormComponent<StringDataEntity>(
          field: const GridField(
            id: 'id',
            name: 'Property',
            type: DataType.text,
          ),
          data: StringDataEntity(),
          property: 'Property',
          required: false,
          options: const FormComponentOptions(),
          type: 'FormField',
        ).toString(),
        equals(
          'FormComponent('
          'property: Property, '
          'field: GridField(id: id, name: Property, type: DataType.text), '
          'data: StringDataEntity(value: null)}, '
          'options: FormComponentOptions(multi: false, placeholder: null, description: null, label: null), '
          'required: false, '
          'type: FormField)',
        ),
      );
    });
  });
}
