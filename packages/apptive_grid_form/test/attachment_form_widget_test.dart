import 'dart:typed_data';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(title: 'title', components: [], schema: null),
    );
  });

  group('Add attachment', () {
    testWidgets('Add Attachment from file picker', (tester) async {
      const filename = 'Filename.png';
      final bytes = Uint8List(10);
      final filePicker = MockFilePicker();
      final attachmentUri = Uri.parse('attachmenturl.com');
      when(
        () => filePicker.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          allowMultiple: true,
          withData: true,
          type: FileType.any,
        ),
      ).thenAnswer(
        (invocation) async => FilePickerResult([
          PlatformFile(
            name: filename,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
        ]),
      );
      FilePicker.platform = filePicker;

      final data = AttachmentDataEntity(
        [Attachment(name: filename, url: attachmentUri, type: 'image/png')],
      );
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'property',
            data: AttachmentDataEntity(),
            fieldId: 'fieldId',
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));
      when(() => client.createAttachmentUrl(filename))
          .thenReturn(attachmentUri);

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.text('Add attachment', skipOffstage: false), findsOneWidget);
      await tester.tap(find.text('Add attachment'));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));

      await tester.pumpAndSettle();

      final captured =
          verify(() => client.performAction(action, captureAny())).captured;
      expect(captured.length, 1);
      final submittedData = captured.first as FormData;
      expect(submittedData.components.first.data, data);
    });

    testWidgets('Multiple Attachments get added', (tester) async {
      const filename1 = 'Filename1.png';
      const filename2 = 'Filename2.pdf';
      final bytes = Uint8List(10);
      final filePicker = MockFilePicker();
      final attachmentUri1 = Uri.parse('$filename1.com');
      final attachmentUri2 = Uri.parse('$filename2.com');
      when(
        () => filePicker.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          allowMultiple: true,
          withData: true,
          type: FileType.any,
        ),
      ).thenAnswer(
        (invocation) async => FilePickerResult([
          PlatformFile(
            name: filename1,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
          PlatformFile(
            name: filename2,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
        ]),
      );
      FilePicker.platform = filePicker;

      final attachment1 =
          Attachment(name: filename1, url: attachmentUri1, type: 'image/png');
      final attachment2 = Attachment(
        name: filename2,
        url: attachmentUri2,
        type: 'application/pdf',
      );
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'property',
            data: AttachmentDataEntity(),
            fieldId: 'fieldId',
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));
      when(() => client.createAttachmentUrl(any())).thenAnswer(
        (invocation) =>
            Uri.parse('${invocation.positionalArguments.first}.com'),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.text('Add attachment', skipOffstage: false), findsOneWidget);
      await tester.tap(find.text('Add attachment'));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));

      await tester.pumpAndSettle();

      final captured =
          verify(() => client.performAction(action, captureAny())).captured;
      expect(captured.length, 1);
      final submittedData =
          captured.first.components.first.data as AttachmentDataEntity;
      expect(submittedData.value!.length, 2);
      expect(submittedData.value!.first, equals(attachment1));
      expect(submittedData.value!.last, equals(attachment2));
    });
  });

  group('Delete Attachments', () {
    testWidgets('Added Attachment get removed', (tester) async {
      const filename = 'Filename.png';
      final bytes = Uint8List(10);
      final filePicker = MockFilePicker();
      final attachmentUri = Uri.parse('attachmenturl.com');
      when(
        () => filePicker.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          allowMultiple: true,
          withData: true,
          type: FileType.any,
        ),
      ).thenAnswer(
        (invocation) async => FilePickerResult([
          PlatformFile(
            name: filename,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
        ]),
      );
      FilePicker.platform = filePicker;

      final data = AttachmentDataEntity(
        [],
      );
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'property',
            data: AttachmentDataEntity(),
            fieldId: 'fieldId',
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));
      when(() => client.createAttachmentUrl(filename))
          .thenReturn(attachmentUri);

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.text('Add attachment', skipOffstage: false), findsOneWidget);
      await tester.tap(find.text('Add attachment'));

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));

      await tester.pumpAndSettle();

      final captured =
          verify(() => client.performAction(action, captureAny())).captured;
      expect(captured.length, 1);
      final submittedData = captured.first as FormData;
      expect(submittedData.components.first.data, data);
    });

    testWidgets('Existing Attachment gets deleted', (tester) async {
      const filename = 'Filename.png';
      final attachmentUri = Uri.parse('attachmenturl.com');

      final attachment = Attachment(
        name: filename,
        url: attachmentUri,
        type: 'image/png',
      );
      final data = AttachmentDataEntity(
        [],
      );
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'property',
            data: AttachmentDataEntity([attachment]),
            fieldId: 'fieldId',
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));

      await tester.pumpAndSettle();

      final captured =
          verify(() => client.performAction(action, captureAny())).captured;
      expect(captured.length, 1);
      final submittedData = captured.first as FormData;
      expect(submittedData.components.first.data, data);
    });
  });

  group('Options', () {
    testWidgets('Attachment is required shows message', (tester) async {
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'Property',
            data: AttachmentDataEntity(),
            fieldId: 'fieldId',
            required: true,
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
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
        findsOneWidget,
      );
    });

    testWidgets('Attachment is required shows message '
        'adding attachment '
        'sends action', (tester) async {
      const filename = 'Filename.png';
      final bytes = Uint8List(10);
      final filePicker = MockFilePicker();
      final attachmentUri = Uri.parse('attachmenturl.com');
      when(
            () => filePicker.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          allowMultiple: true,
          withData: true,
          type: FileType.any,
        ),
      ).thenAnswer(
            (invocation) async => FilePickerResult([
          PlatformFile(
            name: filename,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
        ]),
      );
      FilePicker.platform = filePicker;

      final data = AttachmentDataEntity(
        [Attachment(name: filename, url: attachmentUri, type: 'image/png')],
      );
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          AttachmentFormComponent(
            property: 'Property',
            data: AttachmentDataEntity(),
            fieldId: 'fieldId',
            required: true,
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));
      when(() => client.createAttachmentUrl(filename))
          .thenReturn(attachmentUri);

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

      await tester.tap(find.text('Add attachment'));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedData = verify(() => client.performAction(action, captureAny<FormData>())).captured.first as FormData;
      expect(capturedData.components.first.data, data);
    });
  });
}
