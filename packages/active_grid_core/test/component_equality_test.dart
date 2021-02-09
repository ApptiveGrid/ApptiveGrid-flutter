import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final textA = StringFormComponent(
      fieldId: 'textId',
      property: 'Property',
      data: StringDataEntity('Value'),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: true);
  final textB = StringFormComponent(
      fieldId: 'textId',
      property: 'Property',
      data: StringDataEntity('Value'),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: true);

  final textC = StringFormComponent(
      fieldId: 'textC',
      property: 'Property',
      data: StringDataEntity(),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: false);

  final number = IntegerFormComponent(
      fieldId: 'number',
      property: 'Property',
      data: IntegerDataEntity(),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: false);

  final date = DateFormComponent(
    fieldId: 'date',
    property: 'Property',
    data: DateDataEntity(),
    options: FormComponentOptions(),
    required: false,
  );

  final dateTime = DateTimeFormComponent(
    fieldId: 'dateTime',
    property: 'Property',
    data: DateTimeDataEntity(),
    options: FormComponentOptions(),
    required: false,
  );

  final checkBox = BooleanFormComponent(
    fieldId: 'checkBox',
    property: 'Property',
    data: BooleanDataEntity(),
    options: FormComponentOptions(),
    required: false,
  );

  test('equals', () {
    expect(textA == textB, true);
    expect(textA.hashCode - textB.hashCode == 0, true);
  });
  test('not equals', () {
    expect(textA == textC, false);
    expect(textA.hashCode - textC.hashCode == 0, false);
    expect(textA.hashCode != number.hashCode, true);
    expect(textA.hashCode != date.hashCode, true);
    expect(textA.hashCode != dateTime.hashCode, true);
    expect(textA.hashCode != checkBox.hashCode, true);
  });
}
