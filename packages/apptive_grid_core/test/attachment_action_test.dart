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
      expect(action.hashCode, equals(restored.hashCode));
    });

    test('Delete Action parses and restores', () {
      final action = DeleteAttachmentAction(attachment: attachment);
      final restored =
          AttachmentAction.fromJson(jsonDecode(jsonEncode(action.toJson())));

      expect(action, equals(restored));
      expect(action.hashCode, equals(restored.hashCode));
    });

    test('Rename Action parses and restores', () {
      final action =
          RenameAttachmentAction(newName: 'newName', attachment: attachment);
      final restored =
          AttachmentAction.fromJson(jsonDecode(jsonEncode(action.toJson())));

      expect(action, equals(restored));
      expect(action.hashCode, equals(restored.hashCode));
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
}
