import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mapping', () {
    test('TextComponent', () {
      final component = StringFormComponent(
        fieldId: 'id',
        data: StringDataEntity(),
        property: 'Property',
        required: false,
        options: const TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, TextFormWidget);
    });

    test('NumberComponent', () {
      final component = IntegerFormComponent(
        fieldId: 'id',
        data: IntegerDataEntity(),
        property: 'Property',
        required: false,
        options: const TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, IntegerFormWidget);
    });

    test('DecimalComponent', () {
      final component = DecimalFormComponent(
        fieldId: 'id',
        data: DecimalDataEntity(),
        property: 'Property',
        required: false,
        options: const TextComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, DecimalFormWidget);
    });

    test('DateComponent', () {
      final component = DateFormComponent(
        fieldId: 'id',
        data: DateDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, DateFormWidget);
    });

    test('DateTimeComponent', () {
      final component = DateTimeFormComponent(
        fieldId: 'id',
        data: DateTimeDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, DateTimeFormWidget);
    });

    test('CheckBoxComponent', () {
      final component = BooleanFormComponent(
        fieldId: 'id',
        data: BooleanDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, CheckBoxFormWidget);
    });

    test('EnumComponent', () {
      final component = EnumFormComponent(
        fieldId: 'id',
        data: EnumDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, EnumFormWidget);
    });

    test('CrossReferenceComponent', () {
      final component = CrossReferenceFormComponent(
        fieldId: 'id',
        data: CrossReferenceDataEntity(
            gridUri: GridUri(user: 'user', space: 'space', grid: 'grid')),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, CrossReferenceFormWidget);
    });

    test('ArgumentError', () {
      final component = UnknownComponent();

      expect(() => fromModel(component), throwsArgumentError);
    });
  });
}

class UnknownComponent extends FormComponent<UnknownDataEntity> {
  @override
  FormComponentOptions get options => const FormComponentOptions();

  @override
  String get property => 'Property';

  @override
  bool get required => false;

  @override
  String get fieldId => 'id';

  @override
  UnknownDataEntity get data => UnknownDataEntity();
}

class UnknownDataEntity extends DataEntity<String, String> {

  UnknownDataEntity([String? value]) : super(value);

  @override
  String? get schemaValue => null;
}
