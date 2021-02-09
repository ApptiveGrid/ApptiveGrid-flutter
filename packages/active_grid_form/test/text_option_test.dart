import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:active_grid_core/active_grid_model.dart';

import 'common.dart';

void main() {
  group('Text', () {
    testWidgets('Default Label is Property', (tester) async {
      final property = 'Property';
      final component = StringFormComponent(
        data: StringDataEntity(),
        property: property,
        options: TextComponentOptions(),
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
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final component = StringFormComponent(
        data: StringDataEntity(),
        property: property,
        options: TextComponentOptions(
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
      final property = 'Property';
      final component = IntegerFormComponent(
        data: IntegerDataEntity(),
        property: property,
        options: TextComponentOptions(),
      );
      final target = TestApp(
        child: NumberFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(property), findsOneWidget);
    });

    testWidgets('Custom Label is shown', (tester) async {
      final property = 'Property';
      final customLabel = 'CustomLabel';
      final component = IntegerFormComponent(
        data: IntegerDataEntity(),
        property: property,
        options: TextComponentOptions(
          label: customLabel,
        ),
      );
      final target = TestApp(
        child: NumberFormWidget(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
    });
  });
}
