import 'dart:convert';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  const signedUrl = 'https://signed.url';
  const signedFormUrl = 'https://signed.form/url';
  final attachmentUrl = Uri.parse('https://attachment.url');

  late AttachmentProcessor processor;
  late http.Client httpClient;
  late ApptiveGridAuthenticator authenticator;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    httpClient = MockHttpClient();
    authenticator = MockApptiveGridAuthenticator();
    processor = AttachmentProcessor(
      const ApptiveGridOptions(),
      authenticator,
      httpClient: httpClient,
    );

    when(
      () => httpClient.get(
        any(
          that: predicate<Uri>(
            (uri) => uri.path.endsWith('config.json'),
          ),
        ),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((invocation) async {
      return http.Response(
        jsonEncode({
          'attachments': {
            "unauthenticatedSignedUrlEndpoint": signedFormUrl,
            "signedUrlEndpoint": signedUrl,
            "apiEndpoint": attachmentUrl.toString(),
          }
        }),
        200,
      );
    });
  });
  group('Create Attachment', () {
    final uuidRegex = RegExp(
      r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$',
      caseSensitive: false,
    );

    test('Image generates thumbnailUrls', () async {
      final attachment = await processor.createAttachment('attachment.png');

      expect(attachment.type, equals('image/png'));
      expect(attachment.name, equals('attachment.png'));

      expect(
        attachment.url,
        predicate<Uri>(
          (uri) =>
              uri.scheme == attachmentUrl.scheme &&
              uri.host == attachmentUrl.host &&
              uuidRegex.hasMatch(uri.pathSegments.last),
        ),
      );

      expect(
        attachment.smallThumbnail,
        predicate<Uri>(
          (uri) =>
              uri.scheme == attachmentUrl.scheme &&
              uri.host == attachmentUrl.host &&
              uuidRegex.hasMatch(uri.pathSegments.last),
        ),
      );

      expect(
        attachment.largeThumbnail,
        predicate<Uri>(
          (uri) =>
              uri.scheme == attachmentUrl.scheme &&
              uri.host == attachmentUrl.host &&
              uuidRegex.hasMatch(uri.pathSegments.last),
        ),
      );
    });

    test('Non image generates no thumbnailUrls', () async {
      final attachment = await processor.createAttachment('attachment.pdf');

      expect(attachment.type, equals('application/pdf'));
      expect(attachment.name, equals('attachment.pdf'));

      expect(
        attachment.url,
        predicate<Uri>(
          (uri) =>
              uri.scheme == attachmentUrl.scheme &&
              uri.host == attachmentUrl.host &&
              uuidRegex.hasMatch(uri.pathSegments.last),
        ),
      );

      expect(
        attachment.smallThumbnail,
        isNull,
      );

      expect(
        attachment.largeThumbnail,
        isNull,
      );
    });
  });

  group('Scale Image', () {
    test('No Image, Returns original bytes', () async {
      final bytes = Uint8List(10);

      expect(
        await processor.scaleImageToMaxSize(
          originalImage: bytes,
          size: 10,
          type: 'image/png',
        ),
        equals(bytes),
      );
    });

    test('Image small enough does not scale', () async {
      // 2x4 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
      );

      expect(
        await processor.scaleImageToMaxSize(
          originalImage: originalImage,
          size: 4,
          type: 'image/png',
        ),
        equals(originalImage),
      );
    });

    test('Scales Portrait Image', () async {
      // 2x4 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
      );

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImage: originalImage,
        size: 2,
        type: 'image/png',
      );
      final image = img.decodeImage(scaledImage)!;

      expect(image.width, equals(1));
      expect(image.height, equals(2));
    });

    test('Scales Horizontal Image', () async {
      // 4x2 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAQAAAACCAYAAAB/qH1jAAAAE0lEQVR42mP8z/C/ngEJMKILAABzTAT9NQTQfQAAAABJRU5ErkJggg==',
      );

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImage: originalImage,
        size: 2,
        type: 'image/png',
      );
      final image = img.decodeImage(scaledImage)!;

      expect(image.width, equals(2));
      expect(image.height, equals(1));
    });
  });
}
