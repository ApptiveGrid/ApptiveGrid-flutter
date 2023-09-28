import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
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
        fields: [],
      ),
    );
  });

  testWidgets('Multiline TextFormWidget Displays', (tester) async {
    const value = '''A
multi-line
string''';
    const field = GridField(id: 'Field', name: 'name', type: DataType.text);
    final target = TextFormWidget(
      component: FormComponent<StringDataEntity>(
        property: 'Text',
        data: StringDataEntity(
          value,
        ),
        options: const FormComponentOptions(
          multi: true,
        ),
        field: field,
      ),
    );

    await tester.pumpWidget(
      TestApp(
        child: target,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(value), findsOneWidget);
  });

  testWidgets('Multiline TextFormWidget Displays in FormData Widget',
      (tester) async {
    const value = '''A
multi-line
string''';
    const field = GridField(id: 'Field', name: 'name', type: DataType.text);
    final formData = FormData(
      id: 'formId',
      title: 'Title',
      components: [
        FormComponent<StringDataEntity>(
          property: 'Text',
          data: StringDataEntity(
            value,
          ),
          options: const FormComponentOptions(
            multi: true,
          ),
          field: field,
        ),
      ],
      fields: [field],
      links: {},
    );

    final target = ApptiveGridFormData(
      formData: formData,
    );

    await tester.pumpWidget(
      TestApp(
        child: target,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(value), findsOneWidget);
  });

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      const field = GridField(id: 'fieldId', name: 'name', type: DataType.text);
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<StringDataEntity>(
            property: 'Property',
            data: StringDataEntity('Value'),
            field: field,
            required: true,
          ),
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions())
          .thenAnswer((_) => Future.value([]));
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

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });

  group('Options', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      const field = GridField(id: 'fieldId', name: 'name', type: DataType.text);
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<StringDataEntity>(
            property: 'Property',
            data: StringDataEntity('Value'),
            field: field,
            required: true,
          ),
        ],
        fieldProperties: [
          FormFieldProperties(fieldId: field.id, disabled: true),
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions())
          .thenAnswer((_) => Future.value([]));
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

      expect(
        tester
            .widget<TextFormField>(
              find.byType(TextFormField).first,
            )
            .enabled,
        false,
      );
    });
  });
}
