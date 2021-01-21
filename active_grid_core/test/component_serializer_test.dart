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
      final component = FormComponentText(
        property: 'Property',
        data: StringDataEntity('Value'),
        options: options,
        required: true,
      );

      expect(FormComponentText.fromJson(component.toJson()), component);
    });

    test('Number', () {
      final options = TextComponentOptions(
        multi: false,
        placeholder: 'Placeholder',
        label: 'Label',
        description: 'Description',
      );
      final component = FormComponentNumber(
        property: 'Property',
        data: IntegerDataEntity(1),
        options: options,
        required: true,
      );

      expect(FormComponentNumber.fromJson(component.toJson()), component);
    });

    test('Date', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentDate(
        property: 'Property',
        data: DateDataEntity(DateTime(2020, 07, 12)),
        options: options,
        required: true,
      );

      expect(FormComponentDate.fromJson(component.toJson()), component);
    });

    test('DateTime', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentDateTime(
        property: 'Property',
        data: DateTimeDataEntity(DateTime(2020, 07, 12, 12, 0, 0, 0)),
        options: options,
        required: true,
      );

      expect(FormComponentDateTime.fromJson(component.toJson()), component);
    });

    test('Checkbox', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentCheckBox(
        property: 'Property',
        data: BooleanDataEntity(false),
        options: options,
        required: true,
      );

      expect(FormComponentCheckBox.fromJson(component.toJson()), component);
    });
  });
}
