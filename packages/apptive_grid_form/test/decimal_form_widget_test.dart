import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(
        id: 'id',
        links: {},
        title: 'title',
        components: [],
        schema: {},
      ),
    );
  });

  group('Input Sanitation', () {
    testWidgets('Wrong Input does not get added', (tester) async {
      final dataEntity = DecimalDataEntity();
      final target = TestApp(
        child: DecimalFormWidget(
          component: DecimalFormComponent(
            data: dataEntity,
            fieldId: 'field',
            property: 'property',
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '47.11.');
      await tester.pumpAndSettle();

      expect(dataEntity.value, equals(47.11));
      expect(find.text('47.11'), findsOneWidget);
    });

    testWidgets(', gets changed to . for valid double', (tester) async {
      final dataEntity = DecimalDataEntity();
      final target = TestApp(
        child: DecimalFormWidget(
          component: DecimalFormComponent(
            data: dataEntity,
            fieldId: 'field',
            property: 'property',
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '47,11');
      await tester.pumpAndSettle();

      expect(dataEntity.value, equals(47.11));
      expect(find.text('47,11'), findsOneWidget);
    });
  });

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          DecimalFormComponent(
            property: 'Property',
            data: DecimalDataEntity(47.11),
            fieldId: 'fieldId',
            required: true,
          )
        ],
        links: {ApptiveLinkType.submit: action},
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.submitForm(action, any()))
          .thenAnswer((_) async => Response('body', 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });
}
