import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  group('CheckBox', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = BooleanFormComponent(
        fieldId: 'id',
        data: BooleanDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: CheckBoxFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label and Description are shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      const description = 'Description';
      final component = BooleanFormComponent(
        fieldId: 'id',
        data: BooleanDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
          description: description,
        ),
      );
      final target = TestApp(
        child: CheckBoxFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });

  group('Date', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = DateFormComponent(
        fieldId: 'id',
        data: DateDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: DateFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label and Description are shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      const description = 'Description';
      final component = DateFormComponent(
        fieldId: 'id',
        data: DateDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
          description: description,
        ),
      );
      final target = TestApp(
        child: DateFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });

  group('DateTime', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = DateTimeFormComponent(
        fieldId: 'id',
        data: DateTimeDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: DateTimeFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label and Description are shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      const description = 'Description';
      final component = DateTimeFormComponent(
        fieldId: 'id',
        data: DateTimeDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
          description: description,
        ),
      );
      final target = TestApp(
        child: DateTimeFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });

  group('Enum', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = EnumFormComponent(
        fieldId: 'id',
        data: EnumDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: EnumFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label and Description are shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      const description = 'Description';
      final component = EnumFormComponent(
        fieldId: 'id',
        data: EnumDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
          description: description,
        ),
      );
      final target = TestApp(
        child: EnumFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });

  group('EnumCollection', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = EnumCollectionFormComponent(
        fieldId: 'id',
        data: EnumCollectionDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: EnumCollectionFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label and Description are shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      const description = 'Description';
      final component = EnumCollectionFormComponent(
        fieldId: 'id',
        data: EnumCollectionDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
          description: description,
        ),
      );
      final target = TestApp(
        child: EnumCollectionFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });
}
