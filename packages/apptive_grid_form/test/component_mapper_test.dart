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

      expect(widget.runtimeType, equals(TextFormWidget));
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

      expect(widget.runtimeType, equals(IntegerFormWidget));
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

      expect(widget.runtimeType, equals(DecimalFormWidget));
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

      expect(widget.runtimeType, equals(DateFormWidget));
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

      expect(widget.runtimeType, equals(DateTimeFormWidget));
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

      expect(widget.runtimeType, equals(CheckBoxFormWidget));
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

      expect(widget.runtimeType, equals(EnumFormWidget));
    });

    test('EnumCollectionComponent', () {
      final component = EnumCollectionFormComponent(
        fieldId: 'id',
        data: EnumCollectionDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(EnumCollectionFormWidget));
    });

    test('CrossReferenceComponent', () {
      final component = CrossReferenceFormComponent(
        fieldId: 'id',
        data: CrossReferenceDataEntity(
          gridUri: Uri.parse('/api/a/user/spaces/space/grids/grid'),
        ),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(CrossReferenceFormWidget));
    });

    test('MultiCrossReferenceComponent', () {
      final component = MultiCrossReferenceFormComponent(
        fieldId: 'id',
        data: MultiCrossReferenceDataEntity(
          gridUri: Uri.parse('/api/a/user/spaces/space/grids/grid'),
        ),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(MultiCrossReferenceFormWidget));
    });

    test('UserReferenceComponent', () {
      final component = UserReferenceFormComponent(
        fieldId: 'id',
        data: UserReferenceDataEntity(
          const UserReference(
            id: 'userId',
            type: UserReferenceType.user,
            displayValue: 'Jane Doe',
            name: 'jane.doe@2denker.de',
          ),
        ),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(UserReferenceFormWidget));
    });

    test('ArgumentError', () {
      final component = UnknownComponent();

      expect(() => fromModel(component), equals(throwsArgumentError));
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
