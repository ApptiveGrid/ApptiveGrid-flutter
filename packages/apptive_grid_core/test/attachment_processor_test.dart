import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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
      const ApptiveGridOptions(
        attachmentConfigurations: {
          ApptiveGridEnvironment.production: AttachmentConfiguration(
            attachmentApiEndpoint: 'attachmentEndpoint.com/',
            signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
          )
        },
      ),
      authenticator,
      httpClient: httpClient,
    );

    when(() => authenticator.isAuthenticated)
        .thenAnswer((invocation) async => false);
    when(
      () => authenticator.checkAuthentication(
        requestNewToken: any(named: 'requestNewToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => authenticator.header).thenReturn('');

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
    test('No Image, Returns null', () async {
      final bytes = Uint8List(10);

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImageBytes: bytes,
        sizes: [2],
        type: 'image/png',
        id: 'id',
      );

      expect(
        scaledImage,
        isNull,
      );
    });

    test('Image small enough does not scale', () async {
      // 2x4 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
      );

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImageBytes: originalImage,
        sizes: [4],
        type: 'image/png',
        id: 'id',
      );
      final file = await File(scaledImage!.first).readAsBytes();

      expect(
        originalImage,
        equals(file),
      );
    });

    test('Scales Portrait Image', () async {
      // 2x4 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
      );

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImageBytes: originalImage,
        sizes: [2],
        type: 'image/png',
        id: 'id',
      );
      final file = await File(scaledImage!.first).readAsBytes();
      final image = img.decodeImage(file)!;

      expect(image.width, equals(1));
      expect(image.height, equals(2));
    });

    test('Scales Horizontal Image', () async {
      // 4x2 Image from https://png-pixel.com/#:~:text=So%20a%20base64%20encoded%201x1%20PNG%20pixel%20wastes%2028%20bytes.
      final originalImage = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAQAAAACCAYAAAB/qH1jAAAAE0lEQVR42mP8z/C/ngEJMKILAABzTAT9NQTQfQAAAABJRU5ErkJggg==',
      );

      final scaledImage = await processor.scaleImageToMaxSize(
        originalImageBytes: originalImage,
        sizes: [2],
        type: 'image/png',
        id: 'id',
      );
      final file = await File(scaledImage!.first).readAsBytes();
      final image = img.decodeImage(file)!;

      expect(image.width, equals(2));
      expect(image.height, equals(1));
    });
  });

  group('From File Path', () {
    setUp(() {
      final getResponse =
          Response('{"uploadURL":"${attachmentUrl.toString()}"}', 200);
      final putResponse = Response('Success', 200);

      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => getResponse);
      when(
        () => httpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer((_) async => putResponse);
    });

    final directory = Directory.systemTemp;

    test('Image from File', () async {
      final attachment = Attachment(
        name: 'name',
        url: Uri(path: 'attachment/url'),
        type: 'image/png',
        smallThumbnail: Uri(path: 'attachment/small/url'),
        largeThumbnail: Uri(path: 'attachment/large/url'),
      );

      final file = File('${directory.path}/attachment.png');
      await file.writeAsBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
        ),
      );

      final action =
          AddAttachmentAction(attachment: attachment, path: file.path);

      await processor.uploadAttachment(action);

      verify(
        () => httpClient.get(
          any(that: predicate<Uri>((uri) => !uri.path.endsWith('config.json'))),
          headers: any(named: 'headers'),
        ),
      ).called(3);
      verify(
        () => httpClient.put(
          attachmentUrl,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).called(3);
    });

    test('Unsizable Image from File', () async {
      final attachment = Attachment(
        name: 'name',
        url: Uri(path: 'attachment/url'),
        type: 'image/png',
        smallThumbnail: Uri(path: 'attachment/small/url'),
        largeThumbnail: Uri(path: 'attachment/large/url'),
      );

      final file = File('${directory.path}/attachment.png');
      await file.writeAsBytes(Uint8List(10));

      final action =
          AddAttachmentAction(attachment: attachment, path: file.path);

      await processor.uploadAttachment(action);

      verify(
        () => httpClient.get(
          any(that: predicate<Uri>((uri) => !uri.path.endsWith('config.json'))),
          headers: any(named: 'headers'),
        ),
      ).called(1);
      verify(
        () => httpClient.put(
          attachmentUrl,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).called(1);
    });

    test('Main Upload succeeds, thumbnails fail, returns mainUpload', () async {
      final attachment = Attachment(
        name: 'name',
        url: Uri(path: 'attachment/url'),
        type: 'image/png',
        smallThumbnail: Uri(path: 'attachment/small/url'),
        largeThumbnail: Uri(path: 'attachment/large/url'),
      );

      final successResponse = Response('Success', 200);
      when(
        () => httpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer((invocation) async {
        final url = invocation.positionalArguments.first as Uri;

        if (url.path.contains('small') || url.path.contains('large')) {
          return Response('Error', 500);
        } else {
          return successResponse;
        }
      });

      final file = File('${directory.path}/attachment.png');
      await file.writeAsBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
        ),
      );

      final action =
          AddAttachmentAction(attachment: attachment, path: file.path);

      expect(await processor.uploadAttachment(action), successResponse);

      verify(
        () => httpClient.get(
          any(that: predicate<Uri>((uri) => !uri.path.endsWith('config.json'))),
          headers: any(named: 'headers'),
        ),
      ).called(3);
      verify(
        () => httpClient.put(
          attachmentUrl,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).called(3);
    });

    test('Non Image from File', () async {
      final attachment = Attachment(
        name: 'name',
        url: Uri(path: 'attachment/url'),
        type: 'application/text',
      );

      final file = File('${directory.path}/attachment.txt');
      await file.writeAsBytes(utf8.encode('attachmentTest'));

      final action =
          AddAttachmentAction(attachment: attachment, path: file.path);

      await processor.uploadAttachment(action);

      verify(
        () => httpClient.get(
          any(that: predicate<Uri>((uri) => !uri.path.endsWith('config.json'))),
          headers: any(named: 'headers'),
        ),
      ).called(1);
      verify(
        () => httpClient.put(
          attachmentUrl,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).called(1);
    });
  });
}
