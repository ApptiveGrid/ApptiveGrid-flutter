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
    registerFallbackValue(ApptiveLink(uri: Uri(), method: 'method'));
  });

  group('Default', () {
    group('Validation', () {
      testWidgets('is required but filled sends', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        const field =
            GridField(id: 'fieldId', name: 'name', type: DataType.singleSelect);
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumDataEntity>(
              property: 'Property',
              data: EnumDataEntity(value: 'A', options: {'A', 'B', 'C'}),
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
          (_) =>
              Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
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
    });
  });

  group('List', () {
    group('Validation', () {
      testWidgets('is required but filled sends', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        const field =
            GridField(id: 'fieldId', name: 'name', type: DataType.singleSelect);
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumDataEntity>(
              property: 'Property',
              data: EnumDataEntity(value: 'A', options: {'A', 'B', 'C'}),
              field: field,
              required: true,
              type: 'selectList',
            ),
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) =>
              Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
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

      testWidgets('is required', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        const field =
            GridField(id: 'fieldId', name: 'name', type: DataType.singleSelect);
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumDataEntity>(
              property: 'Property',
              data: EnumDataEntity(options: {'A', 'B', 'C'}),
              field: field,
              required: true,
              type: 'selectList',
            ),
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) =>
              Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
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
          findsOneWidget,
        );
      });

      testWidgets('Prefilled Value', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        const field =
            GridField(id: 'fieldId', name: 'name', type: DataType.singleSelect);
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumDataEntity>(
              property: 'Property',
              data: EnumDataEntity(value: 'A', options: {'A', 'B', 'C'}),
              field: field,
              required: true,
              type: 'selectList',
            ),
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) =>
              Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
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

        verify(
          () => client.submitFormWithProgress(
            action,
            any(
              that: predicate<FormData>(
                (formData) => formData.components!
                    .where((element) => element.data.value == 'A')
                    .isNotEmpty,
              ),
            ),
          ),
        );
      });

      testWidgets('Select Value', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        const field =
            GridField(id: 'fieldId', name: 'name', type: DataType.singleSelect);
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumDataEntity>(
              property: 'Property',
              data: EnumDataEntity(value: 'A', options: {'A', 'B', 'C'}),
              field: field,
              required: true,
              type: 'selectList',
            ),
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) =>
              Stream.value(SubmitCompleteProgressEvent(Response('body', 200))),
        );

        final target = TestApp(
          client: client,
          child: ApptiveGridFormData(
            formData: formData,
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.tap(find.text('B'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        verify(
          () => client.submitFormWithProgress(
            any(),
            any(
              that: predicate<FormData>(
                (formData) => formData.components!
                    .where((element) => element.data.value == 'B')
                    .isNotEmpty,
              ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
