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
        id: 'formId',
        links: {},
        title: 'title',
        components: [],
        fields: [],
      ),
    );
  });
  const field =
      GridField(id: 'id', name: 'name', type: DataType.enumCollection);

  group('Regular', () {
    testWidgets('Options get a chip', (tester) async {
      final component = FormComponent<EnumCollectionDataEntity>(
        property: 'Property',
        data: EnumCollectionDataEntity(
          value: {},
          options: {
            'A',
            'B',
          },
        ),
        field: field,
      );

      final target = TestApp(
        child: EnumCollectionFormWidget(component: component),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      for (final option in component.data.options) {
        expect(
          find.ancestor(
            of: find.text(option),
            matching: find.byType(ChoiceChip),
          ),
          findsOneWidget,
        );
      }
    });
    testWidgets('Tapping on chips updates value', (tester) async {
      final component = FormComponent<EnumCollectionDataEntity>(
        property: 'Property',
        data: EnumCollectionDataEntity(
          value: {},
          options: {
            'A',
            'B',
          },
        ),
        field: field,
      );

      final target = TestApp(
        child: EnumCollectionFormWidget(component: component),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.text('A'));
      await tester.pump();

      expect(component.data.value, equals({'A'}));

      await tester.tap(find.text('A'));
      await tester.pump();

      expect(component.data.value, equals(<String>{}));
    });

    group('Options', () {
      testWidgets('Disabled', (tester) async {
        final component = FormComponent<EnumCollectionDataEntity>(
          property: 'Property',
          data: EnumCollectionDataEntity(
            value: {},
            options: {
              'A',
              'B',
            },
          ),
          field: field,
          enabled: false,
        );

        final target = TestApp(
          child: EnumCollectionFormWidget(
            component: component,
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        expect(
          tester
              .widget<ChoiceChip>(
                find.byType(ChoiceChip).first,
              )
              .onSelected,
          null,
        );
      });
    });

    group('Validation', () {
      testWidgets('is required but filled sends', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumCollectionDataEntity>(
              property: 'Property',
              data: EnumCollectionDataEntity(
                value: {'A', 'B'},
                options: {'A', 'B', 'C'},
              ),
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
          (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
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

      testWidgets('Required Status Updates', (tester) async {
        final component = FormComponent<EnumCollectionDataEntity>(
          property: 'Property',
          data: EnumCollectionDataEntity(
            value: {},
            options: {
              'A',
              'B',
            },
          ),
          field: field,
          required: true,
        );

        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            component,
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
        );
        final attachmentProcessor = MockAttachmentProcessor();
        when(() => client.attachmentProcessor).thenReturn(attachmentProcessor);
        when(() => attachmentProcessor.createAttachment(any())).thenAnswer(
          (invocation) async {
            final name = invocation.positionalArguments.first;
            return Attachment(
              name: name,
              type: name.endsWith('png') ? 'image/png' : 'application/pdf',
              url: Uri.parse(
                '$name.com',
              ),
            );
          },
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
        await tester.pump();

        expect(
          find.text('Property must not be empty', skipOffstage: true),
          findsOneWidget,
        );

        await tester.tap(find.text('A'));
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text('Property must not be empty', skipOffstage: true),
          findsNothing,
        );

        final capturedData = verify(
          () => client.submitFormWithProgress(action, captureAny<FormData>()),
        ).captured.first as FormData;
        expect(capturedData.components!.first.data.value, equals({'A'}));
      });
    });
  });
  group('List', () {
    testWidgets('Options get a CheckBox ListTile', (tester) async {
      final component = FormComponent<EnumCollectionDataEntity>(
        property: 'Property',
        data: EnumCollectionDataEntity(
          value: {},
          options: {
            'A',
            'B',
          },
        ),
        field: field,
        type: 'multiSelectList',
      );

      final target = TestApp(
        child: EnumCollectionFormWidget(component: component),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      for (final option in component.data.options) {
        expect(
          find.ancestor(
            of: find.text(option),
            matching: find.byType(CheckboxListTile),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('Tapping on chips updates value', (tester) async {
      final component = FormComponent<EnumCollectionDataEntity>(
        property: 'Property',
        data: EnumCollectionDataEntity(
          value: {},
          options: {
            'A',
            'B',
          },
        ),
        field: field,
        type: 'multiSelectList',
      );

      final target = TestApp(
        child: EnumCollectionFormWidget(component: component),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.text('A'));
      await tester.pump();

      expect(component.data.value, equals({'A'}));

      await tester.tap(find.text('A'));
      await tester.pump();

      expect(component.data.value, equals(<String>{}));
    });

    group('Options', () {
      testWidgets('Disabled', (tester) async {
        final component = FormComponent<EnumCollectionDataEntity>(
          property: 'Property',
          data: EnumCollectionDataEntity(
            value: {},
            options: {
              'A',
              'B',
            },
          ),
          field: field,
          type: 'multiSelectList',
          enabled: false,
        );

        final target = TestApp(
          child: EnumCollectionFormWidget(
            component: component,
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        expect(
          tester
              .widget<CheckboxListTile>(
                find.byType(CheckboxListTile).first,
              )
              .enabled,
          false,
        );
      });
    });

    group('Validation', () {
      testWidgets('is required but filled sends', (tester) async {
        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            FormComponent<EnumCollectionDataEntity>(
              property: 'Property',
              data: EnumCollectionDataEntity(
                value: {'A', 'B'},
                options: {'A', 'B', 'C'},
              ),
              field: field,
              required: true,
              type: 'multiSelectList',
            ),
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
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

      testWidgets('Required Status Updates', (tester) async {
        final component = FormComponent<EnumCollectionDataEntity>(
          property: 'Property',
          data: EnumCollectionDataEntity(
            value: {},
            options: {
              'A',
              'B',
            },
          ),
          field: field,
          required: true,
          type: 'multiSelectList',
        );

        final action =
            ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
        final formData = FormData(
          id: 'formId',
          title: 'title',
          components: [
            component,
          ],
          links: {ApptiveLinkType.submit: action},
          fields: [field],
        );
        final client = MockApptiveGridClient();
        when(() => client.sendPendingActions())
            .thenAnswer((_) => Future.value([]));
        when(() => client.submitFormWithProgress(action, any())).thenAnswer(
          (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
        );
        final attachmentProcessor = MockAttachmentProcessor();
        when(() => client.attachmentProcessor).thenReturn(attachmentProcessor);
        when(() => attachmentProcessor.createAttachment(any())).thenAnswer(
          (invocation) async {
            final name = invocation.positionalArguments.first;
            return Attachment(
              name: name,
              type: name.endsWith('png') ? 'image/png' : 'application/pdf',
              url: Uri.parse(
                '$name.com',
              ),
            );
          },
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
        await tester.pump();

        expect(
          find.text('Property must not be empty', skipOffstage: true),
          findsOneWidget,
        );

        await tester.tap(find.text('A'));
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text('Property must not be empty', skipOffstage: true),
          findsNothing,
        );

        final capturedData = verify(
          () => client.submitFormWithProgress(action, captureAny<FormData>()),
        ).captured.first as FormData;
        expect(capturedData.components!.first.data.value, equals({'A'}));
      });
    });
  });
}
