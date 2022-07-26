import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mapping', () {
    test('TextComponent', () {
      final component = FormComponent<StringDataEntity>(
        field: const GridField(
          id: 'String',
          name: 'Property',
          type: DataType.text,
        ),
        data: StringDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(TextFormWidget));
    });

    test('NumberComponent', () {
      final component = FormComponent<IntegerDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.integer,
        ),
        data: IntegerDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(IntegerFormWidget));
    });

    test('DecimalComponent', () {
      final component = FormComponent<DecimalDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.decimal,
        ),
        data: DecimalDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(DecimalFormWidget));
    });

    test('DateComponent', () {
      final component = FormComponent<DateDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.date,
        ),
        data: DateDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(DateFormWidget));
    });

    test('DateTimeComponent', () {
      final component = FormComponent<DateTimeDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.dateTime,
        ),
        data: DateTimeDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(DateTimeFormWidget));
    });

    test('CheckBoxComponent', () {
      final component = FormComponent<BooleanDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.checkbox,
        ),
        data: BooleanDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(CheckBoxFormWidget));
    });

    test('EnumComponent', () {
      final component = FormComponent<EnumDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.singleSelect,
        ),
        data: EnumDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(EnumFormWidget));
    });

    test('EnumCollectionComponent', () {
      final component = FormComponent<EnumCollectionDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.enumCollection,
        ),
        data: EnumCollectionDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(EnumCollectionFormWidget));
    });

    test('CrossReferenceComponent', () {
      final component = FormComponent<CrossReferenceDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.crossReference,
        ),
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
      final component = FormComponent<MultiCrossReferenceDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.multiCrossReference,
        ),
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

    test('CreatedByComponent', () {
      final component = FormComponent<CreatedByDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.createdBy,
        ),
        data: CreatedByDataEntity(
          const CreatedBy(
            id: 'userId',
            type: CreatedByType.user,
            displayValue: 'Jane Doe',
            name: 'jane.doe@2denker.de',
          ),
        ),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(CreatedByFormWidget));
    });

    test('UserComponent', () {
      final component = FormComponent<UserDataEntity>(
        field: const GridField(
          id: 'id',
          name: 'Property',
          type: DataType.user,
        ),
        data: UserDataEntity(),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(UserFormWidget));
      expect((widget as UserFormWidget).component, equals(component));
    });

    test('Currency', () {
      final component = FormComponent<CurrencyDataEntity>(
        field: const CurrencyGridField(
          id: 'id',
          name: 'Property',
          currency: 'EUR',
          links: {},
        ),
        data: CurrencyDataEntity(currency: 'EUR'),
        property: 'Property',
        required: false,
        options: const FormComponentOptions(),
      );

      final widget = fromModel(component);

      expect(widget.runtimeType, equals(CurrencyFormWidget));
      expect((widget as CurrencyFormWidget).component, equals(component));
    });
  });
}
