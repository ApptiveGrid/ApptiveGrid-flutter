import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final textA = FormComponent<StringDataEntity>(
    field: GridField(id: 'textId', name: 'Property', type: DataType.text),
    property: 'Property',
    data: StringDataEntity('Value'),
    options: const FormComponentOptions(
      label: 'Label',
    ),
    required: true,
  );
  final textB = FormComponent<StringDataEntity>(
    field: GridField(id: 'textId', name: 'Property', type: DataType.text),
    property: 'Property',
    data: StringDataEntity('Value'),
    options: const FormComponentOptions(
      label: 'Label',
    ),
    required: true,
  );

  final textC = FormComponent<StringDataEntity>(
    field: GridField(id: 'textC', name: 'Property', type: DataType.text),
    property: 'Property',
    data: StringDataEntity(),
    options: const FormComponentOptions(
      label: 'Label',
    ),
    required: false,
  );

  final number = FormComponent<IntegerDataEntity>(
    field: GridField(id: 'number', name: 'Property', type: DataType.integer),
    property: 'Property',
    data: IntegerDataEntity(),
    options: const FormComponentOptions(
      label: 'Label',
    ),
    required: false,
  );

  final date = FormComponent<DateDataEntity>(
    field: GridField(id: 'date', name: 'Property', type: DataType.date),
    property: 'Property',
    data: DateDataEntity(),
    options: const FormComponentOptions(),
    required: false,
  );

  final dateTime = FormComponent<DateTimeDataEntity>(
    field: GridField(id: 'dateTime', name: 'Property', type: DataType.dateTime),
    property: 'Property',
    data: DateTimeDataEntity(),
    options: const FormComponentOptions(),
    required: false,
  );

  final checkBox = FormComponent<BooleanDataEntity>(
    field: GridField(id: 'checkBox', name: 'Property', type: DataType.checkbox),
    property: 'Property',
    data: BooleanDataEntity(),
    options: const FormComponentOptions(),
    required: false,
  );

  test('equals', () {
    expect(textA, equals(textB));
    expect(textA.hashCode, equals(textB.hashCode));
  });
  test('not equals', () {
    expect(textA, isNot(textC));
    expect(textA.hashCode, isNot(textC.hashCode));
    expect(textA.hashCode, isNot(number.hashCode));
    expect(textA.hashCode, isNot(date.hashCode));
    expect(textA.hashCode, isNot(dateTime.hashCode));
    expect(textA.hashCode, isNot(checkBox.hashCode));
  });
}
