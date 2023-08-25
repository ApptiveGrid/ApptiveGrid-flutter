import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
  const field =
      GridField(id: 'fieldId', name: 'name', type: DataType.phoneNumber);
  final formData = FormData(
    id: 'formId',
    title: 'title',
    components: [
      FormComponent<PhoneNumberDataEntity>(
        property: 'Property',
        data: PhoneNumberDataEntity(),
        field: field,
        required: true,
      ),
    ],
    links: {ApptiveLinkType.submit: action},
    fields: [field],
  );
  final formDataFilled = FormData(
    id: 'formId',
    title: 'title',
    components: [
      FormComponent<PhoneNumberDataEntity>(
        property: 'Property',
        data: PhoneNumberDataEntity('+123455'),
        field: field,
        required: true,
      ),
    ],
    links: {ApptiveLinkType.submit: action},
    fields: [field],
  );
  final client = MockApptiveGridClient();

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
    when(() => client.sendPendingActions()).thenAnswer((_) => Future.value([]));
    when(() => client.submitFormWithProgress(action, any())).thenAnswer(
      (_) => Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
    );
  });

  group('Validation', () {
    testWidgets('is required', (tester) async {
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
        findsOneWidget,
      );
    });
    testWidgets('is required but filled sends', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataFilled,
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
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final phonenumberField = find.byType(PhoneNumberFormWidget).first;
      await tester.tap(phonenumberField);
      await tester.pumpAndSettle();

      const invalidPhoneNumber = 'h12345';
      await tester.enterText(phonenumberField, invalidPhoneNumber);
      await tester.pumpAndSettle();

      expect(
        find.text(invalidPhoneNumber, skipOffstage: true),
        findsNothing,
      );

      const incompletePhoneNumber = '12345';
      await tester.enterText(phonenumberField, incompletePhoneNumber);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'International code is required (e.g. +49)',
          skipOffstage: true,
        ),
        findsOneWidget,
      );

      const validPhoneNumber = '+12345';
      await tester.enterText(phonenumberField, validPhoneNumber);
      await tester.pumpAndSettle();

      expect(
        find.text(validPhoneNumber, skipOffstage: true),
        findsOneWidget,
      );
    });
  });

  group('submit', () {
    testWidgets('submit sends correct data', (tester) async {
      const phoneNumberInput = '+12345';

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final phoneNumberField = find.byType(PhoneNumberFormWidget).first;
      await tester.tap(phoneNumberField);
      await tester.pumpAndSettle();

      await tester.enterText(phoneNumberField, phoneNumberInput);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      verify(
        () => client.submitFormWithProgress(
          action,
          any(
            that: predicate((formData) {
              if (formData is FormData) {
                return (formData.components!.first.data.value as String?) ==
                    phoneNumberInput;
              } else {
                return false;
              }
            }),
          ),
        ),
      ).called(1);
    });
  });
}
