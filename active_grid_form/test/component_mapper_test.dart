import 'package:active_grid_core/active_grid_model.dart' as model;
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mapping', () {
    test('TextComponent', () {
      final component = model.FormComponentText(
        property: 'Property',
        required: false,
        options: model.TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, FormComponentText);
    });

    test('NumberComponent', () {
      final component = model.FormComponentNumber(
        property: 'Property',
        required: false,
        options: model.TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, FormComponentNumber);
    });

    test('DateComponent', () {
      final component = model.FormComponentDate(
        property: 'Property',
        required: false,
        options: model.StubComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, FormComponentDate);
    });

    test('DateTimeComponent', () {
      final component = model.FormComponentDateTime(
        property: 'Property',
        required: false,
        options: model.StubComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, FormComponentDateTime);
    });

    test('CheckBoxComponent', () {
      final component = model.FormComponentCheckBox(
        property: 'Property',
        required: false,
        options: model.StubComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, FormComponentCheckBox);
    });

    test('ArgumentError', () {
      // This won't work once everything is migrated to Null-Safety
      final component = UnknownComponent();

      expect(() => fromModel(component), throwsArgumentError);
    });
  });
}

class UnknownComponent extends model.FormComponent<String, String> {
  @override
  model.FormComponentOptions get options => model.StubComponentOptions();

  @override
  String get property => 'Property';

  @override
  bool get required => false;

  @override
  String get schemaValue => 'Value';

  @override
  model.FormType get type => null;

  @override
  String get value => 'Value';
}
