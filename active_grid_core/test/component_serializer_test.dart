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
          value: 'Value',
          options: options,
          required: true,
          type: DataType.text);

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
          value: 1,
          options: options,
          required: true,
          type: DataType.integer);

      expect(FormComponentNumber.fromJson(component.toJson()), component);
    });

    test('Date', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentDate(
          property: 'Property',
          value: DateTime(2020, 07, 12),
          options: options,
          required: true,
          type: DataType.date);

      expect(FormComponentDate.fromJson(component.toJson()), component);
    });

    test('DateTime', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentDateTime(
          property: 'Property',
          value: DateTime(2020, 07, 12, 12, 0, 0, 0),
          options: options,
          required: true,
          type: DataType.dateTime);

      expect(FormComponentDateTime.fromJson(component.toJson()), component);
    });

    test('Checkbox', () {
      final options = StubComponentOptions.fromJson({});
      final component = FormComponentCheckBox(
          property: 'Property',
          value: false,
          options: options,
          required: true,
          type: DataType.checkbox);

      expect(FormComponentCheckBox.fromJson(component.toJson()), component);
    });
  });
}
