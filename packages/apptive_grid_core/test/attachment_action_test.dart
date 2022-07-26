import 'dart:convert';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Json Parsing', () {
    late final Attachment attachment;

    setUpAll(() {
      attachment = Attachment(name: 'name', url: Uri(), type: 'type');
    });

    test('Add Action parses and restores', () {
      final action =
          AddAttachmentAction(byteData: Uint8List(8), attachment: attachment);
      final restored =
          AttachmentAction.fromJson(jsonDecode(jsonEncode(action.toJson())));

      expect(action, equals(restored));
    });

    test('Delete Action parses and restores', () {
      final action = DeleteAttachmentAction(attachment: attachment);
      final restored =
          AttachmentAction.fromJson(jsonDecode(jsonEncode(action.toJson())));

      expect(action, equals(restored));
    });

    test('Rename Action parses and restores', () {
      final action =
          RenameAttachmentAction(newName: 'newName', attachment: attachment);
      final restored =
          AttachmentAction.fromJson(jsonDecode(jsonEncode(action.toJson())));

      expect(action, equals(restored));
    });

    test('Unknown ActionType throws Error', () {
      expect(
        () => AttachmentAction.fromJson({
          'attachment': attachment.toJson(),
          'type': 'unknwonType',
        }),
        throwsA(isInstanceOf<ArgumentError>()),
      );
    });
  });

  group('Hashcode', () {
    final attachment = Attachment(
        name: 'name', url: Uri(path: 'attachment'), type: 'image/png');
    test('AddAttachmentAction', () {
      final action =
          AddAttachmentAction(attachment: attachment, path: '/path/toFile');

      expect(action.hashCode,
          equals(Object.hash(attachment, action.path, action.byteData)));
    });

    test('DeleteAttachmentAction', () {
      final action = DeleteAttachmentAction(attachment: attachment);

      expect(action.hashCode, equals(attachment.hashCode));
    });
    test('RenameAttachmentAction', () {
      final action = RenameAttachmentAction(
          attachment: attachment, newName: '/path/toFile');

      expect(action.hashCode, equals(Object.hash(attachment, action.newName)));
    });
  });

  group('toString()', () {
    final attachment = Attachment(
        name: 'name', url: Uri(path: 'attachment'), type: 'image/png');
    test('AddAttachmentAction', () {
      final action =
          AddAttachmentAction(attachment: attachment, path: '/path/toFile');

      expect(
          action.toString(),
          equals(
              'AddAttachmentAction(attachment: $attachment, path: /path/toFile, byteData(byteSize): null)'));
    });

    test('DeleteAttachmentAction', () {
      final action = DeleteAttachmentAction(attachment: attachment);

      expect(action.toString(),
          equals('DeleteAttachmentAction(attachment: $attachment)'));
    });
    test('RenameAttachmentAction', () {
      final action = RenameAttachmentAction(
          attachment: attachment, newName: '/path/toFile');

      expect(
          action.toString(),
          equals(
              'RenameAttachmentAction(newName: /path/toFile, attachment: $attachment)'));
    });
  });
}
