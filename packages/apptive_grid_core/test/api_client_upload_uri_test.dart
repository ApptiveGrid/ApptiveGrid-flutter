import 'dart:convert';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  late ApptiveGridClient client;
  late Client httpClient;
  late ApptiveGridAuthenticator authenticator;

  final submitLink = ApptiveLink(uri: Uri.parse('/submit'), method: 'POST');
  final formUploadLink =
      ApptiveLink(uri: Uri.parse('/form/uploadUri'), method: 'POST');
  final fieldUploadLink =
      ApptiveLink(uri: Uri.parse('/field/uploadUri'), method: 'POST');

  const presignedUri = 'https://presigned.url/put-here';
  const serverUri = 'https://attachments.apptivegrid.de/server-assigned';
  const legacySignedUrl = 'https://legacy.signed.url/put-here';

  setUpAll(() {
    registerFallbackValue(Request('GET', Uri()));
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    httpClient = MockHttpClient();
    authenticator = MockApptiveGridAuthenticator();
    when(() => authenticator.isAuthenticated).thenAnswer((_) async => true);
    when(() => authenticator.header).thenReturn('Bearer token');
    when(
      () => authenticator.checkAuthentication(
        requestNewToken: any(named: 'requestNewToken'),
      ),
    ).thenAnswer((_) async {});
    client = ApptiveGridClient(
      httpClient: httpClient,
      options: const ApptiveGridOptions(
        environment: ApptiveGridEnvironment.production,
      ),
      authenticator: authenticator,
    );

    when(() => httpClient.send(any())).thenAnswer((invocation) async {
      final request = invocation.positionalArguments.first as BaseRequest;
      if (request.url.path.endsWith('uploadUri')) {
        return StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode({'presignedUri': presignedUri, 'uri': serverUri}),
            ),
          ),
          200,
        );
      }
      return StreamedResponse(Stream.value(utf8.encode('{}')), 200);
    });

    when(
      () => httpClient.put(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => Response('', 200));

    when(
      () => httpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('config.json')) {
        return Response(
          jsonEncode({
            'attachments': {
              'apiEndpoint': 'https://attachments.endpoint',
              'signedUrlEndpoint': 'https://signed.endpoint',
            },
          }),
          200,
        );
      }
      return Response(jsonEncode({'uploadURL': legacySignedUrl}), 200);
    });
  });

  // 4x2 png
  final imageBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAQAAAACCAYAAAB/qH1jAAAAE0lEQVR42mP8z/C/ngEJMKILAABzTAT9NQTQfQAAAABJRU5ErkJggg==',
  );

  FormData formDataWith({
    required Attachment attachment,
    Uint8List? byteData,
    LinkMap fieldLinks = const {},
    LinkMap formLinks = const {},
  }) {
    final field = GridField(
      id: 'fieldId',
      name: 'Foto',
      type: DataType.attachment,
      links: fieldLinks,
    );
    return FormData(
      id: 'formId',
      title: 'Title',
      components: [
        FormComponent<AttachmentDataEntity>(
          property: 'Foto',
          data: AttachmentDataEntity([attachment]),
          field: field,
        ),
      ],
      fields: [field],
      links: {ApptiveLinkType.submit: submitLink, ...formLinks},
      attachmentActions: {
        attachment: AddAttachmentAction(
          byteData: byteData ?? Uint8List(10),
          attachment: attachment,
        ),
      },
    );
  }

  Attachment newAttachment() => Attachment(
        name: 'file.pdf',
        url: Uri.parse('https://placeholder.url/local-uuid'),
        type: 'application/pdf',
      );

  group('uploadUri HAL link', () {
    test('uploads to the pre-signed url and stores the server uri', () async {
      final attachment = newAttachment();
      final formData = formDataWith(
        attachment: attachment,
        formLinks: {ApptiveLinkType.uploadUri: formUploadLink},
      );

      final response = await client.submitForm(submitLink, formData);

      expect(response!.statusCode, 200);

      // The file went to the pre-signed url
      verify(
        () => httpClient.put(
          Uri.parse(presignedUri),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);

      // The submitted data points at the url the server assigned
      final stored =
          (formData.components!.first.data as AttachmentDataEntity).value!;
      expect(stored.single.url, Uri.parse(serverUri));
      expect(stored.single.name, 'file.pdf');
    });

    test('does not request an AttachmentConfiguration', () async {
      final attachment = newAttachment();
      final formData = formDataWith(
        attachment: attachment,
        formLinks: {ApptiveLinkType.uploadUri: formUploadLink},
      );

      await client.submitForm(submitLink, formData);

      verifyNever(
        () => httpClient.get(
          any(
            that: predicate<Uri>((uri) => uri.path.endsWith('config.json')),
          ),
          headers: any(named: 'headers'),
        ),
      );
    });

    test('prefers the link of the field over the one of the form', () async {
      final attachment = newAttachment();
      final formData = formDataWith(
        attachment: attachment,
        fieldLinks: {ApptiveLinkType.uploadUri: fieldUploadLink},
        formLinks: {ApptiveLinkType.uploadUri: formUploadLink},
      );

      await client.submitForm(submitLink, formData);

      final requestedUploadUris = verify(() => httpClient.send(captureAny()))
          .captured
          .cast<BaseRequest>()
          .map((request) => request.url.path)
          .where((path) => path.endsWith('uploadUri'))
          .toList();

      expect(requestedUploadUris, ['/field/uploadUri']);
    });

    test('requests a target for the image and each of its thumbnails',
        () async {
      final attachment = Attachment(
        name: 'image.png',
        url: Uri.parse('https://placeholder.url/main'),
        type: 'image/png',
        largeThumbnail: Uri.parse('https://placeholder.url/large'),
        smallThumbnail: Uri.parse('https://placeholder.url/small'),
      );
      final formData = formDataWith(
        attachment: attachment,
        byteData: imageBytes,
        formLinks: {ApptiveLinkType.uploadUri: formUploadLink},
      );

      await client.submitForm(submitLink, formData);

      final uploadUriRequests = verify(() => httpClient.send(captureAny()))
          .captured
          .cast<BaseRequest>()
          .where((request) => request.url.path.endsWith('uploadUri'))
          .length;

      // One target for the image itself and one for each thumbnail
      expect(uploadUriRequests, 3);

      verify(
        () => httpClient.put(
          Uri.parse(presignedUri),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(3);

      final stored =
          (formData.components!.first.data as AttachmentDataEntity).value!;
      expect(stored.single.url, Uri.parse(serverUri));
      expect(stored.single.largeThumbnail, Uri.parse(serverUri));
      expect(stored.single.smallThumbnail, Uri.parse(serverUri));
    });

    test('falls back to the configuration when no link is present', () async {
      final attachment = newAttachment();
      final formData = formDataWith(attachment: attachment);

      final response = await client.submitForm(submitLink, formData);

      expect(response!.statusCode, 200);

      // Without a link the configuration is needed to build the upload url
      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>((uri) => uri.path.endsWith('config.json')),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);

      verify(
        () => httpClient.put(
          Uri.parse(legacySignedUrl),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);

      // The client generated url is kept
      final stored =
          (formData.components!.first.data as AttachmentDataEntity).value!;
      expect(
        stored.single.url,
        Uri.parse('https://placeholder.url/local-uuid'),
      );
    });
  });
}
