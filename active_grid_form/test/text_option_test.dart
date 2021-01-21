import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:active_grid_core/active_grid_model.dart' as model;

import 'common.dart';

void main() {
  group('Text', () {
    testWidgets('Default Label is Property', (tester) async {
      final property = 'Property';
      final component = model.FormComponentText(
        data: model.StringDataEntity(),
        property: property,
        options: model.TextComponentOptions(),
      );
      final target = TestApp(
        child: FormComponentText(
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
      final component = model.FormComponentText(
        data: model.StringDataEntity(),
        property: property,
        options: model.TextComponentOptions(
          label: customLabel,
        ),
      );
      final target = TestApp(
        child: FormComponentText(
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
      final component = model.FormComponentNumber(
        data: model.IntegerDataEntity(),
        property: property,
        options: model.TextComponentOptions(),
      );
      final target = TestApp(
        child: FormComponentNumber(
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
      final component = model.FormComponentNumber(
        data: model.IntegerDataEntity(),
        property: property,
        options: model.TextComponentOptions(
          label: customLabel,
        ),
      );
      final target = TestApp(
        child: FormComponentNumber(
          component: component,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(customLabel), findsOneWidget);
    });
  });
}
