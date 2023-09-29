import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  group('ProcessedAttachmentProgressEvent', () {
    test('toString() Produces correct Output', () {
      final event = ProcessedAttachmentProgressEvent(
        Attachment(
          name: 'name',
          url: Uri(path: '/attachment'),
          type: 'image/png',
        ),
      );

      expect(
        event.toString(),
        'ProcessedAttachmentProgressEvent(attachment: Attachment(name: name, url: /attachment, type: image/png, smallThumbnail: null, largeThumbnail: null))',
      );
    });

    test('Equality', () {
      final event1 = ProcessedAttachmentProgressEvent(
        Attachment(
          name: 'name',
          url: Uri(path: '/attachment'),
          type: 'image/png',
        ),
      );
      final event2 = ProcessedAttachmentProgressEvent(
        Attachment(
          name: 'name',
          url: Uri(path: '/attachment'),
          type: 'image/png',
        ),
      );

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });
  });

  group('AttachmentCompleteProgressEvent', () {
    test('toString() Produces correct Output', () {
      final event = AttachmentCompleteProgressEvent(Response('Response', 200));

      expect(
        event.toString(),
        'AttachmentCompleteProgressEvent(response: 200:Response)',
      );
    });

    test('Equality', () {
      final event1 = AttachmentCompleteProgressEvent(Response('Response', 200));
      final event2 = AttachmentCompleteProgressEvent(Response('Response', 200));

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });
  });

  group('UploadFormProgressEvent', () {
    test('toString() Produces correct Output', () {
      final event = UploadFormProgressEvent(
        FormData(
          id: 'id',
          name: 'form',
          components: [],
          fields: [],
          links: {},
        ),
      );

      expect(
        event.toString(),
        'UploadFormProgressEvent(formData: FormData(id: id, name: form, title: null, description: null, components: [], fields: [], links: {}, attachmentActions: {}, properties: null, fieldProperties: []))',
      );
    });

    test('Equality', () {
      final event1 = UploadFormProgressEvent(
        FormData(
          id: 'id',
          name: 'form',
          components: [],
          fields: [],
          links: {},
        ),
      );
      final event2 = UploadFormProgressEvent(
        FormData(
          id: 'id',
          name: 'form',
          components: [],
          fields: [],
          links: {},
        ),
      );

      expect(event1, equals(event2));
    });

    test('Hashcode', () {
      final event1 = UploadFormProgressEvent(
        FormData(
          id: 'id',
          name: 'form',
          components: [],
          fields: [],
          links: {},
        ),
      );

      expect(event1.hashCode, equals(event1.form.hashCode));
    });
  });

  group('SubmitCompleteProgressEvent', () {
    test('toString() Produces correct Output', () {
      final event = SubmitCompleteProgressEvent(Response('Response', 200));

      expect(
        event.toString(),
        'SubmitCompleteProgressEvent(response: 200:Response)',
      );
    });

    test('Equality', () {
      final event1 = SubmitCompleteProgressEvent(Response('Response', 200));
      final event2 = SubmitCompleteProgressEvent(Response('Response', 200));

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });
  });

  group('ErrorProgressEvent', () {
    test('toString() Produces correct Output', () {
      const event = ErrorProgressEvent('Error');

      expect(event.toString(), 'ErrorProgressEvent(error: Error)');
    });

    test('Equality', () {
      const event1 = ErrorProgressEvent('Error');
      // ignore: prefer_const_constructors
      final event2 = ErrorProgressEvent('Error');

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });
  });
}
