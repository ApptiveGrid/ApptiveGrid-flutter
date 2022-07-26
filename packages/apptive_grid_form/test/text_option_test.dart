import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  group('Text', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = FormComponent<StringDataEntity>(
        field: const GridField(
          id: 'String',
          name: 'Property',
          type: DataType.text,
        ),
        data: StringDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: TextFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label is shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      final component = FormComponent<StringDataEntity>(
        field: const GridField(
          id: 'String',
          name: 'Property',
          type: DataType.text,
        ),
        data: StringDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
        ),
      );
      final target = TestApp(
        child: TextFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
    });
  });

  group('Number', () {
    testWidgets('Default Label is Property', (tester) async {
      const property = 'Property';
      final component = FormComponent<IntegerDataEntity>(
        field:
            const GridField(id: 'id', name: 'Property', type: DataType.integer),
        data: IntegerDataEntity(),
        property: property,
        options: const FormComponentOptions(),
      );
      final target = TestApp(
        child: IntegerFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label is shown', (tester) async {
      const property = 'Property';
      const customLabel = 'CustomLabel';
      final component = FormComponent<IntegerDataEntity>(
        field:
            const GridField(id: 'id', name: 'Property', type: DataType.integer),
        data: IntegerDataEntity(),
        property: property,
        options: const FormComponentOptions(
          label: customLabel,
        ),
      );
      final target = TestApp(
        child: IntegerFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
    });
  });
}
