import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
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
        fields: [],
      ),
    );
  });

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      const field =
          GridField(id: 'fieldId', name: 'name', type: DataType.email);
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<EmailDataEntity>(
            property: 'Property',
            data: EmailDataEntity('email'),
            field: field,
            required: true,
          )
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.submitFormWithProgress(action, any())).thenAnswer(
        (_) => Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
      );
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

    testWidgets('input validation', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      const field =
          GridField(id: 'fieldId', name: 'name', type: DataType.email);
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<EmailDataEntity>(
            property: 'Property',
            data: EmailDataEntity(),
            field: field,
            required: true,
          )
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.submitFormWithProgress(action, any())).thenAnswer(
        (_) => Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
      );
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final emailField = find.byType(EmailFormWidget).first;
      await tester.tap(emailField);
      await tester.pumpAndSettle();

      await tester.enterText(emailField, 'text.text@text');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Invalid email', skipOffstage: true),
        findsOneWidget,
      );
    });
  });
}
