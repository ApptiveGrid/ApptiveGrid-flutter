import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final textA = FormComponentText(
      property: 'Property',
      data: StringDataEntity('Value'),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: true);
  final textB = FormComponentText(
      property: 'Property',
      data: StringDataEntity('Value'),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: true);

  final textC = FormComponentText(
      property: 'Property',
      data: StringDataEntity(),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: false);

  final number = FormComponentNumber(
      property: 'Property',
      data: IntegerDataEntity(),
      options: TextComponentOptions(
        label: 'Label',
      ),
      required: false);

  final date = FormComponentDate(
    property: 'Property',
    data: DateDataEntity(),
    options: StubComponentOptions(),
    required: false,
  );

  final dateTime = FormComponentDateTime(
    property: 'Property',
    data: DateTimeDataEntity(),
    options: StubComponentOptions(),
    required: false,
  );

  final checkBox = FormComponentCheckBox(
    property: 'Property',
    data: BooleanDataEntity(),
    options: StubComponentOptions(),
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
