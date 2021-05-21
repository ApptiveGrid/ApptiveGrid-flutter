import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  group('CheckBox', () {
    testWidgets('Default Label is Property', (tester) async {
      final property = 'Property';
      final component = BooleanFormComponent(
        fieldId: 'id',
        data: BooleanDataEntity(),
        property: property,
        options: FormComponentOptions(),
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
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final description = 'Description';
      final component = BooleanFormComponent(
        fieldId: 'id',
        data: BooleanDataEntity(),
        property: property,
        options:
            FormComponentOptions(label: customLabel, description: description),
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
      final property = 'Property';
      final component = DateFormComponent(
        fieldId: 'id',
        data: DateDataEntity(),
        property: property,
        options: FormComponentOptions(),
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
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final description = 'Description';
      final component = DateFormComponent(
        fieldId: 'id',
        data: DateDataEntity(),
        property: property,
        options:
            FormComponentOptions(label: customLabel, description: description),
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
      final property = 'Property';
      final component = DateTimeFormComponent(
        fieldId: 'id',
        data: DateTimeDataEntity(),
        property: property,
        options: FormComponentOptions(),
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
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final description = 'Description';
      final component = DateTimeFormComponent(
        fieldId: 'id',
        data: DateTimeDataEntity(),
        property: property,
        options:
            FormComponentOptions(label: customLabel, description: description),
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
      final property = 'Property';
      final component = EnumFormComponent(
        fieldId: 'id',
        data: EnumDataEntity(),
        property: property,
        options: FormComponentOptions(),
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
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final description = 'Description';
      final component = EnumFormComponent(
        fieldId: 'id',
        data: EnumDataEntity(),
        property: property,
        options:
            FormComponentOptions(label: customLabel, description: description),
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
}
