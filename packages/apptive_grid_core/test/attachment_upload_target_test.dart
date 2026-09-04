import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final target = AttachmentUploadTarget(
    presignedUri: Uri.parse('https://storage.com/file?signature=abc'),
    uri: Uri.parse('https://storage.com/file'),
  );

  test('From Json', () {
    final fromJson = AttachmentUploadTarget.fromJson({
      'presignedUri': 'https://storage.com/file?signature=abc',
      'uri': 'https://storage.com/file',
    });

    expect(fromJson, equals(target));
    expect(fromJson.presignedUri.queryParameters['signature'], 'abc');
    expect(fromJson.uri, Uri.parse('https://storage.com/file'));
  });

  group('Equality', () {
    test('Objects are equal', () {
      final other = AttachmentUploadTarget(
        presignedUri: Uri.parse('https://storage.com/file?signature=abc'),
        uri: Uri.parse('https://storage.com/file'),
      );

      expect(target, equals(other));
      expect(target.hashCode, equals(other.hashCode));
    });

    test('Different presignedUri is not equal', () {
      final other = AttachmentUploadTarget(
        presignedUri: Uri.parse('https://storage.com/file?signature=xyz'),
        uri: Uri.parse('https://storage.com/file'),
      );

      expect(target, isNot(other));
      expect(target.hashCode, isNot(other.hashCode));
    });

    test('Different uri is not equal', () {
      final other = AttachmentUploadTarget(
        presignedUri: Uri.parse('https://storage.com/file?signature=abc'),
        uri: Uri.parse('https://storage.com/other'),
      );

      expect(target, isNot(other));
      expect(target.hashCode, isNot(other.hashCode));
    });

    test('Different type is not equal', () {
      expect(target, isNot('AttachmentUploadTarget'));
    });
  });

  test('toString()', () {
    expect(
      target.toString(),
      'AttachmentUploadTarget(presignedUri: https://storage.com/file?signature=abc, uri: https://storage.com/file)',
    );
  });
}
