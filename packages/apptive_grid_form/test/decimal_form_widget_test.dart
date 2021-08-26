import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  group('Input Sanitation', () {
    testWidgets('Wrong Input does not get added', (tester) async {
      final dataEntity = DecimalDataEntity();
      final target = TestApp(
        child: DecimalFormWidget(
          component: DecimalFormComponent(
              data: dataEntity, fieldId: 'field', property: 'property'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '47.11.');
      await tester.pumpAndSettle();

      expect(dataEntity.value, 47.11);
      expect(find.text('47.11'), findsOneWidget);
    });

    testWidgets(', gets changed to . for valid double', (tester) async {
      final dataEntity = DecimalDataEntity();
      final target = TestApp(
        child: DecimalFormWidget(
          component: DecimalFormComponent(
              data: dataEntity, fieldId: 'field', property: 'property'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '47,11');
      await tester.pumpAndSettle();

      expect(dataEntity.value, 47.11);
      expect(find.text('47,11'), findsOneWidget);
    });
  });
}
