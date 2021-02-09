import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Components', () {
    test('Text', () {
      final options = TextComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = StringFormComponent(
        property: 'Property',
        data: StringDataEntity('Value'),
        options: options,
        required: true,
      );

      expect(StringFormComponent.fromJson(component.toJson()), component);
    });

    test('Number', () {
      final options = TextComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = IntegerFormComponent(
        property: 'Property',
        data: IntegerDataEntity(1),
        options: options,
        required: true,
      );

      expect(IntegerFormComponent.fromJson(component.toJson()), component);
    });

    test('Date', () {
      final options = FormComponentOptions.fromJson({});
      final component = DateFormComponent(
        property: 'Property',
        data: DateDataEntity(DateTime(2020, 07, 12)),
        options: options,
        required: true,
      );

      expect(DateFormComponent.fromJson(component.toJson()), component);
    });

    test('DateTime', () {
      final options = FormComponentOptions.fromJson({});
      final component = DateTimeFormComponent(
        property: 'Property',
        data: DateTimeDataEntity(DateTime(2020, 07, 12, 12, 0, 0, 0)),
        options: options,
        required: true,
      );

      expect(DateTimeFormComponent.fromJson(component.toJson()), component);
    });

    test('Checkbox', () {
      final options = FormComponentOptions.fromJson({});
      final component = BooleanFormComponent(
        property: 'Property',
        data: BooleanDataEntity(false),
        options: options,
        required: true,
      );

      expect(BooleanFormComponent.fromJson(component.toJson()), component);
    });

    test('Enum', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {
            'type': 'string',
            'enum': ['GmbH', 'AG', 'Freiberuflich']
          }
        },
      };
      final json = {
        'property': property,
        'value': 'AG',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'selectBox'
      };

      final jsonComponent = FormComponent.fromJson(json, schema);
      final component = EnumFormComponent(
        property: property,
        data: EnumDataEntity(
            value: 'AG', options: ['GmbH', 'AG', 'Freiberuflich']),
        required: true,
      );

      expect(
          EnumFormComponent.fromJson(
              jsonComponent.toJson(), schema['properties'][property]),
          component);
    });
  });
}
