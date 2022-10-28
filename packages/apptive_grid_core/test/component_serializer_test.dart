import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Components', () {
    test('Text', () {
      const options = FormComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponent<StringDataEntity>(
        field: const GridField(id: 'id', name: 'Property', type: DataType.text),
        property: 'Property',
        data: StringDataEntity('Value'),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('Number', () {
      const options = FormComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponent<IntegerDataEntity>(
        field:
            const GridField(id: 'id', name: 'Property', type: DataType.integer),
        property: 'Property',
        data: IntegerDataEntity(1),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('Decimal', () {
      const options = FormComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponent<DecimalDataEntity>(
        field:
            const GridField(id: 'id', name: 'Property', type: DataType.decimal),
        property: 'Property',
        data: DecimalDataEntity(30.0),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('Date', () {
      final options = FormComponentOptions.fromJson({});
      final component = FormComponent<DateDataEntity>(
        field: const GridField(id: 'id', name: 'Property', type: DataType.date),
        property: 'Property',
        data: DateDataEntity(DateTime(2020, 07, 12)),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('DateTime', () {
      final options = FormComponentOptions.fromJson({});
      final component = FormComponent<DateTimeDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.dateTime,
        ),
        property: 'Property',
        data: DateTimeDataEntity(DateTime(2020, 07, 12, 12, 0, 0, 0)),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('Checkbox', () {
      final options = FormComponentOptions.fromJson({});
      final component = FormComponent<BooleanDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.checkbox,
        ),
        property: 'Property',
        data: BooleanDataEntity(false),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });

    test('Enum', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        'type': 'string',
        'enum': ['GmbH', 'AG', 'Freiberuflich']
      };

      final field = GridField(
        id: id,
        name: property,
        type: DataType.singleSelect,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': 'AG',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'selectBox'
      };

      final jsonComponent = FormComponent.fromJson(json, [field]);
      final component = FormComponent<EnumDataEntity>(
        field: const GridField(
          id: id,
          name: property,
          type: DataType.singleSelect,
        ),
        property: property,
        data: EnumDataEntity(
          value: 'AG',
          options: {'GmbH', 'AG', 'Freiberuflich'},
        ),
        required: true,
      );

      expect(
        FormComponent.fromJson(
          jsonComponent.toJson(),
          [field],
        ),
        component,
      );
    });
    test('EnumCollection', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ['GmbH', 'AG', 'Freiberuflich']
        }
      };

      final field = GridField(
        id: id,
        name: property,
        type: DataType.enumCollection,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': ['AG'],
        'required': true,
        'options': <String, dynamic>{},
        'type': 'selectBox'
      };

      final jsonComponent = FormComponent.fromJson(json, [field]);
      final component = FormComponent<EnumCollectionDataEntity>(
        field: const GridField(
          id: id,
          name: property,
          type: DataType.enumCollection,
        ),
        property: property,
        data: EnumCollectionDataEntity(
          value: {'AG'},
          options: {'GmbH', 'AG', 'Freiberuflich'},
        ),
        required: true,
      );

      expect(
        FormComponent.fromJson(
          jsonComponent.toJson(),
          [field],
        ),
        component,
      );
    });
    test('Email', () {
      const options = FormComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponent<EmailDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.email,
        ),
        property: 'Property',
        data: EmailDataEntity('test@test.test'),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });
    test('Phone number', () {
      const options = FormComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponent<PhoneNumberDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.phoneNumber,
        ),
        property: 'Property',
        data: PhoneNumberDataEntity('+123456'),
        options: options,
        required: true,
      );

      expect(
        FormComponent.fromJson(component.toJson(), [component.field]),
        equals(component),
      );
    });
  });
}
