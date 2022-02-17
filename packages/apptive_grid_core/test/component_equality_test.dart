import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final textA = StringFormComponent(
    fieldId: 'textId',
    property: 'Property',
    data: StringDataEntity('Value'),
    options: const TextComponentOptions(
      label: 'Label',
    ),
    required: true,
  );
  final textB = StringFormComponent(
    fieldId: 'textId',
    property: 'Property',
    data: StringDataEntity('Value'),
    options: const TextComponentOptions(
      label: 'Label',
    ),
    required: true,
  );

  final textC = StringFormComponent(
    fieldId: 'textC',
    property: 'Property',
    data: StringDataEntity(),
    options: const TextComponentOptions(
      label: 'Label',
    ),
    required: false,
  );

  final number = IntegerFormComponent(
    fieldId: 'number',
    property: 'Property',
    data: IntegerDataEntity(),
    options: const TextComponentOptions(
      label: 'Label',
    ),
    required: false,
  );

  final date = DateFormComponent(
    fieldId: 'date',
    property: 'Property',
    data: DateDataEntity(),
    options: const FormComponentOptions(),
    required: false,
  );

  final dateTime = DateTimeFormComponent(
    fieldId: 'dateTime',
    property: 'Property',
    data: DateTimeDataEntity(),
    options: const FormComponentOptions(),
    required: false,
  );

  final checkBox = BooleanFormComponent(
    fieldId: 'checkBox',
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
