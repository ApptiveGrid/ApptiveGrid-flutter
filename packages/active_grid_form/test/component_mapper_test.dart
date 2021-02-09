import 'package:active_grid_core/active_grid_model.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mapping', () {
    test('TextComponent', () {
      final component = StringFormComponent(
        data: StringDataEntity(),
        property: 'Property',
        required: false,
        options: TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, TextFormWidget);
    });

    test('NumberComponent', () {
      final component = IntegerFormComponent(
        data: IntegerDataEntity(),
        property: 'Property',
        required: false,
        options: TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, NumberFormWidget);
    });

    test('DateComponent', () {
      final component = DateFormComponent(
        data: DateDataEntity(),
        property: 'Property',
        required: false,
        options: FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, DateFormWidget);
    });

    test('DateTimeComponent', () {
      final component = DateTimeFormComponent(
        data: DateTimeDataEntity(),
        property: 'Property',
        required: false,
        options: FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, DateTimeFormWidget);
    });

    test('CheckBoxComponent', () {
      final component = BooleanFormComponent(
        data: BooleanDataEntity(),
        property: 'Property',
        required: false,
        options: FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, CheckBoxFormWidget);
    });

    test('EnumComponent', () {
      final component = EnumFormComponent(
        data: EnumDataEntity(),
        property: 'Property',
        required: false,
        options: FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, EnumFormWidget);
    });

    test('ArgumentError', () {
      final component = UnknownComponent();

      expect(() => fromModel(component), throwsArgumentError);
    });
  });
}

class UnknownComponent extends FormComponent<DataEntity<String, String>> {
  @override
  FormComponentOptions get options => FormComponentOptions();

  @override
  String get property => 'Property';

  @override
  bool get required => false;

  @override
  DataEntity<String, String> get data => null;
}
