import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

/// An app theme that styles every border state, like an embedding app may do
///
/// This is what used to leak into Widgets that only set
/// [InputDecoration.border] to [InputBorder.none].
const _visible = OutlineInputBorder(borderSide: BorderSide(width: 3));
final _themeWithBorders = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    border: _visible,
    enabledBorder: _visible,
    disabledBorder: _visible,
    focusedBorder: _visible,
    errorBorder: _visible,
    focusedErrorBorder: _visible,
  ),
);

/// Every border an [InputDecorator] can pick, by the state it is used for
Map<String, InputBorder?> _borders(InputDecoration decoration) => {
      'border (fallback)': decoration.border,
      'enabledBorder': decoration.enabledBorder,
      'disabledBorder': decoration.disabledBorder,
      'focusedBorder': decoration.focusedBorder,
      'errorBorder': decoration.errorBorder,
      'focusedErrorBorder': decoration.focusedErrorBorder,
    };

/// Asserts that no state of the field draws a border, even after Flutter merged
/// the app's [InputDecorationTheme] into the decoration
void _expectBorderless(InputDecoration decoration, String what) {
  final applied =
      decoration.applyDefaults(_themeWithBorders.inputDecorationTheme);
  _borders(applied).forEach((state, border) {
    expect(
      border,
      equals(InputBorder.none),
      reason: '$what still draws a border for $state',
    );
  });
}

void main() {
  group('InputDecorationX', () {
    test('withoutBorder covers every state', () {
      _expectBorderless(const InputDecoration().withoutBorder, 'withoutBorder');
    });

    test('borderInEveryState covers every state', () {
      final decoration = const InputDecoration().borderInEveryState(_visible);
      _borders(decoration.applyDefaults(const InputDecorationTheme()))
          .forEach((state, border) {
        expect(border, equals(_visible), reason: state);
      });
    });

    test('a plain border does not survive a theme, which is why it is needed',
        () {
      // Guards the reason the helper exists: this is the behavior that put a
      // box around the checkbox in an embedding app
      final applied = const InputDecoration(border: InputBorder.none)
          .applyDefaults(_themeWithBorders.inputDecorationTheme);
      expect(applied.enabledBorder, equals(_visible));
    });
  });

  group('Form Widgets stay borderless in an app that styles every state', () {
    // Each Widget is rendered on its own: the form is a lazy ListView, so
    // fields below the fold would never be built
    Future<void> pumpField(
      WidgetTester tester,
      DataType type,
      DataEntity data, {
      String? componentType,
    }) async {
      await tester.binding.setSurfaceSize(const Size(1000, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final field = GridField(id: type.name, name: type.name, type: type);
      await tester.pumpWidget(
        TestApp(
          options: const ApptiveGridOptions(
            formWidgetConfigurations: [
              GeolocationFormWidgetConfiguration(placesApiKey: ''),
            ],
          ),
          child: Theme(
            data: _themeWithBorders,
            child: ApptiveGridFormData(
              formData: FormData(
                id: 'formId',
                title: 'Title',
                components: [
                  FormComponent(
                    property: type.name,
                    data: data,
                    field: field,
                    type: componentType,
                  ),
                ],
                fields: [field],
                links: {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    /// The [InputDecorator] a Widget builds itself, which is the outermost one
    /// below it
    InputDecoration groupDecoration(WidgetTester tester, Type widgetType) =>
        tester
            .widget<InputDecorator>(
              find
                  .descendant(
                    of: find.byType(widgetType),
                    matching: find.byType(InputDecorator),
                  )
                  .first,
            )
            .decoration;

    // The Widget's own type string, where it decides between a boxed single
    // field and a group of options that brings its own layout
    final borderlessGroups = <String, (DataType, DataEntity, Type, String?)>{
      'CheckBoxFormWidget': (
        DataType.checkbox,
        BooleanDataEntity(false),
        CheckBoxFormWidget,
        null,
      ),
      'AttachmentFormWidget': (
        DataType.attachment,
        AttachmentDataEntity(),
        AttachmentFormWidget,
        null,
      ),
      'GeolocationFormWidget': (
        DataType.geolocation,
        GeolocationDataEntity(),
        GeolocationFormWidget,
        null,
      ),
      'AddressFormWidget': (
        DataType.address,
        AddressDataEntity(),
        AddressFormWidget,
        null,
      ),
      'EnumFormWidget': (
        DataType.singleSelect,
        EnumDataEntity(options: {'a', 'b'}),
        EnumFormWidget,
        'selectList',
      ),
      'EnumCollectionFormWidget': (
        DataType.enumCollection,
        EnumCollectionDataEntity(options: {'a', 'b'}),
        EnumCollectionFormWidget,
        null,
      ),
    };

    borderlessGroups.forEach((name, setup) {
      testWidgets('$name draws no box around its content', (tester) async {
        final (type, data, widgetType, componentType) = setup;
        await pumpField(tester, type, data, componentType: componentType);
        _expectBorderless(groupDecoration(tester, widgetType), name);
      });
    });

    testWidgets('A plain single select keeps the box the app asked for',
        (tester) async {
      // The counterpart of the group Widgets: a dropdown is a normal field, so
      // suppressing its border would be just as wrong as boxing in a checkbox
      await pumpField(
        tester,
        DataType.singleSelect,
        EnumDataEntity(options: {'a', 'b'}),
      );

      final decoration = groupDecoration(tester, EnumFormWidget)
          .applyDefaults(_themeWithBorders.inputDecorationTheme);
      expect(decoration.enabledBorder, equals(_visible));
    });

    testWidgets('DateTimeFormWidget keeps its inner fields borderless',
        (tester) async {
      await pumpField(
        tester,
        DataType.dateTime,
        DateTimeDataEntity(DateTime(2026, 9, 13)),
      );

      final innerFields = find.descendant(
        of: find.byType(DateTimeFormWidget),
        matching: find.byType(TextField),
      );
      expect(tester.widgetList(innerFields), hasLength(2));
      for (var i = 0; i < 2; i++) {
        _expectBorderless(
          tester.widget<TextField>(innerFields.at(i)).decoration!,
          'DateTimeFormWidget inner field $i',
        );
      }
    });
  });
}
