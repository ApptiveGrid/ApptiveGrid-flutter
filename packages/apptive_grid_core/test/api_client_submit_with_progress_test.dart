import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  final httpClient = MockHttpClient();
  late ApptiveGridAuthenticator authenticator;
  late ApptiveGridClient apptiveGridClient;

  setUpAll(() {
    registerFallbackValue(Request('GET', Uri()));
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});

    registerFallbackValue(
      ActionItem(
        link: ApptiveLink(uri: Uri.parse('uri'), method: 'method'),
        data: FormData(
          id: 'formId',
          name: 'name',
          title: 'title',
          components: [],
          fields: [],
          links: {},
        ),
      ),
    );
  });

  setUp(() {
    authenticator = MockApptiveGridAuthenticator();
    when(
      () => authenticator.checkAuthentication(
        requestNewToken: any(named: 'requestNewToken'),
      ),
    ).thenAnswer((_) async {});

    apptiveGridClient = ApptiveGridClient(
      httpClient: httpClient,
      authenticator: authenticator,
    );
  });

  group('Submit Form with Progress', () {
    test('Successful', () async {
      final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
      const property = 'Checkbox';
      const id = 'id';
      final schema = {
        'type': 'object',
        'properties': {
          id: {'type': 'boolean'},
        },
        'required': []
      };
      final component = FormComponent<BooleanDataEntity>(
        property: property,
        data: BooleanDataEntity(true),
        options: FormComponentOptions.fromJson({}),
        required: false,
        field: GridField(
          id: id,
          name: property,
          type: DataType.checkbox,
          schema: schema,
        ),
      );
      final formData = FormData(
        id: 'formId',
        name: 'Name',
        title: 'Title',
        components: [component],
        links: {ApptiveLinkType.submit: action},
        fields: [component.field],
      );

      final request = Request(
        'POST',
        Uri.parse('${ApptiveGridEnvironment.production.url}/uri}'),
      );
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 200);
      });

      await expectLater(
        apptiveGridClient.submitFormWithProgress(action, formData),
        emitsInOrder([
          emits(
            predicate<SubmitFormProgressEvent>(
              (event) => event is AttachmentCompleteProgressEvent,
            ),
          ),
          emits(
            predicate<SubmitFormProgressEvent>(
              (event) =>
                  event is UploadFormProgressEvent && event.form == formData,
            ),
          ),
          emits(
            predicate<SubmitFormProgressEvent>(
              (event) => event is SubmitCompleteProgressEvent,
            ),
          ),
          emitsDone,
        ]),
      );
    });

    test('Error without Cache throws Response', () async {
      final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
      const property = 'Checkbox';
      const id = 'id';
      final schema = {
        'type': 'object',
        'properties': {
          id: {'type': 'boolean'},
        },
        'required': []
      };
      final component = FormComponent<BooleanDataEntity>(
        property: property,
        data: BooleanDataEntity(true),
        options: FormComponentOptions.fromJson({}),
        required: false,
        field: GridField(
          id: id,
          name: property,
          type: DataType.checkbox,
          schema: schema,
        ),
      );
      final formData = FormData(
        id: 'formId',
        name: 'Name',
        title: 'Title',
        components: [component],
        links: {ApptiveLinkType.submit: action},
        fields: [component.field],
      );

      final request = Request(
        'POST',
        Uri.parse('${ApptiveGridEnvironment.production.url}/uri}'),
      );
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      when(() => httpClient.send(any())).thenAnswer(
        (realInvocation) async => StreamedResponse(Stream.value([]), 400),
      );

      await expectLater(
        apptiveGridClient.submitFormWithProgress(action, formData),
        emitsInOrder([
          emits(
            predicate<SubmitFormProgressEvent>(
              (event) => event is AttachmentCompleteProgressEvent,
            ),
          ),
          emits(
            predicate<SubmitFormProgressEvent>(
              (event) =>
                  event is UploadFormProgressEvent && event.form == formData,
            ),
          ),
          emitsError(
            isInstanceOf<Response>(),
          ),
        ]),
      );
    });

    group('Attachments', () {
      group('No Attachment Config', () {
        late ApptiveGridClient client;
        late Client httpClient;
        late ApptiveGridAuthenticator authenticator;

        setUp(() {
          httpClient = MockHttpClient();
          authenticator = MockApptiveGridAuthenticator();
          when(() => authenticator.isAuthenticated)
              .thenAnswer((_) async => true);
          when(
            () => authenticator.checkAuthentication(
              requestNewToken: any(named: 'requestNewToken'),
            ),
          ).thenAnswer((_) async {});
          client = ApptiveGridClient(
            httpClient: httpClient,
            options: const ApptiveGridOptions(
              environment: ApptiveGridEnvironment.production,
              authenticationOptions: ApptiveGridAuthenticationOptions(
                autoAuthenticate: true,
              ),
            ),
            authenticator: authenticator,
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
            return Response('{}', 200);
          });
        });

        test('Upload Attachment, throws Error', () async {
          final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
          final action =
              ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
          final bytes = Uint8List(10);
          const field =
              GridField(id: 'id', name: 'property', type: DataType.attachment);
          final formData = FormData(
            id: 'formId',
            title: 'Title',
            components: [
              FormComponent<AttachmentDataEntity>(
                property: 'property',
                data: AttachmentDataEntity([attachment]),
                field: field,
              ),
            ],
            fields: [field],
            links: {ApptiveLinkType.submit: action},
            attachmentActions: {
              attachment:
                  AddAttachmentAction(byteData: bytes, attachment: attachment)
            },
          );

          expect(
            client.submitFormWithProgress(action, formData),
            emitsInOrder([
              emitsError(isException),
              emitsDone,
            ]),
          );
        });
      });

      group('Attachment Config from Server is used', () {
        late ApptiveGridClient client;
        late Client httpClient;
        late ApptiveGridAuthenticator authenticator;

        const attachmentConfig = {
          ApptiveGridEnvironment.production: AttachmentConfiguration(
            attachmentApiEndpoint: 'attachmentEndpoint.com/',
            signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
          )
        };

        const signedUrl = 'https://signed.url';
        const signedFormUrl = 'https://signed.form/url';
        const attachmentUrl = 'https://attachment.url';

        setUp(() {
          httpClient = MockHttpClient();
          authenticator = MockApptiveGridAuthenticator();
          when(() => authenticator.isAuthenticated)
              .thenAnswer((_) async => true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          client = ApptiveGridClient(
            httpClient: httpClient,
            options: const ApptiveGridOptions(
              attachmentConfigurations: attachmentConfig,
              environment: ApptiveGridEnvironment.production,
              authenticationOptions: ApptiveGridAuthenticationOptions(
                autoAuthenticate: true,
              ),
            ),
            authenticator: authenticator,
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
            return Response(
              jsonEncode({
                'attachments': {
                  "unauthenticatedSignedUrlEndpoint": signedFormUrl,
                  "signedUrlEndpoint": signedUrl,
                  "apiEndpoint": attachmentUrl,
                }
              }),
              200,
            );
          });
        });

        test('Server config is used', () async {
          expect(
            await client.attachmentProcessor.configuration,
            equals(
              const AttachmentConfiguration(
                signedUrlApiEndpoint: signedUrl,
                signedUrlFormApiEndpoint: signedFormUrl,
                attachmentApiEndpoint: attachmentUrl,
              ),
            ),
          );
        });
      });

      group('With Provided Attachment Config', () {
        late ApptiveGridClient client;
        late Client httpClient;
        late ApptiveGridAuthenticator authenticator;

        const attachmentConfig = {
          ApptiveGridEnvironment.production: AttachmentConfiguration(
            attachmentApiEndpoint: 'attachmentEndpoint.com/',
            signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
          )
        };

        setUp(() {
          httpClient = MockHttpClient();
          authenticator = MockApptiveGridAuthenticator();
          when(() => authenticator.isAuthenticated)
              .thenAnswer((_) async => true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          when(() => authenticator.header).thenReturn('authHeader');
          client = ApptiveGridClient(
            httpClient: httpClient,
            options: const ApptiveGridOptions(
              attachmentConfigurations: attachmentConfig,
              environment: ApptiveGridEnvironment.production,
              authenticationOptions: ApptiveGridAuthenticationOptions(
                autoAuthenticate: true,
              ),
            ),
            authenticator: authenticator,
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
            return Response('{}', 200);
          });
        });

        group('Upload Data', () {
          group('Generic Files', () {
            final attachment = Attachment(
              name: 'name',
              url: Uri(
                path: 'with/elements',
              ),
              type: 'type',
            );
            final action =
                ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
            final bytes = Uint8List(10);
            final attachmentAction =
                AddAttachmentAction(byteData: bytes, attachment: attachment);
            const field = GridField(
              id: 'id',
              name: 'property',
              type: DataType.attachment,
            );
            final formData = FormData(
              id: 'formId',
              title: 'Title',
              components: [
                FormComponent<AttachmentDataEntity>(
                  property: 'property',
                  data: AttachmentDataEntity([attachment]),
                  field: field,
                ),
              ],
              fields: [field],
              links: {ApptiveLinkType.submit: action},
              attachmentActions: {attachment: attachmentAction},
            );

            test('Getting Upload Url fails', () async {
              final response = Response('body', 400);
              final baseUri = Uri.parse(
                attachmentConfig[ApptiveGridEnvironment.production]!
                    .signedUrlApiEndpoint,
              );
              when(
                () => httpClient.get(
                  any(
                    that: predicate<Uri>((requestUri) {
                      return baseUri.scheme == requestUri.scheme &&
                          baseUri.host == requestUri.host &&
                          baseUri.path == requestUri.path &&
                          requestUri.queryParameters['fileType'] ==
                              attachmentAction.attachment.type &&
                          requestUri.queryParameters['fileName'] != null;
                    }),
                  ),
                  headers: any(named: 'headers'),
                ),
              ).thenAnswer((_) async {
                return response;
              });

              expect(
                client.submitFormWithProgress(action, formData),
                emitsInOrder([
                  emitsError(equals(response)),
                  emitsDone,
                ]),
              );
            });

            test('Upload Bytes success', () async {
              final uploadUri = Uri.parse('uploadUrl.com/data');
              final getResponse =
                  Response('{"uploadURL":"${uploadUri.toString()}"}', 200);
              final putResponse = Response('Success', 200);
              final baseUri = Uri.parse(
                attachmentConfig[ApptiveGridEnvironment.production]!
                    .signedUrlApiEndpoint,
              );
              when(
                () => httpClient.get(
                  any(
                    that: predicate<Uri>((requestUri) {
                      return baseUri.scheme == requestUri.scheme &&
                          baseUri.host == requestUri.host &&
                          baseUri.path == requestUri.path &&
                          requestUri.queryParameters['fileType'] ==
                              attachmentAction.attachment.type &&
                          requestUri.queryParameters['fileName'] != null;
                    }),
                  ),
                  headers: any(named: 'headers'),
                ),
              ).thenAnswer((_) async => getResponse);
              when(
                () => httpClient.put(
                  uploadUri,
                  headers: any(named: 'headers'),
                  body: bytes,
                  encoding: any(named: 'encoding'),
                ),
              ).thenAnswer((_) async => putResponse);
              when(() => httpClient.send(any())).thenAnswer(
                (realInvocation) async =>
                    StreamedResponse(Stream.value([]), 200),
              );

              expect(
                client.submitFormWithProgress(action, formData),
                emitsInOrder([
                  emits(
                    predicate<SubmitFormProgressEvent>(
                      (event) =>
                          event is ProcessedAttachmentProgressEvent &&
                          event.attachment == attachment,
                    ),
                  ),
                  emits(
                    predicate<SubmitFormProgressEvent>(
                      (event) => event is AttachmentCompleteProgressEvent,
                    ),
                  ),
                  emits(
                    predicate<SubmitFormProgressEvent>(
                      (event) =>
                          event is UploadFormProgressEvent &&
                          event.form == formData,
                    ),
                  ),
                  emits(
                    predicate<SubmitFormProgressEvent>(
                      (event) => event is SubmitCompleteProgressEvent,
                    ),
                  ),
                  emitsDone,
                ]),
              );
            });

            test('Upload Fails throws Response', () async {
              final uploadUri = Uri.parse('uploadUrl.com/data');
              final getResponse =
                  Response('{"uploadURL":"${uploadUri.toString()}"}', 200);
              final putResponse = Response('Error', 500);
              final baseUri = Uri.parse(
                attachmentConfig[ApptiveGridEnvironment.production]!
                    .signedUrlApiEndpoint,
              );
              when(
                () => httpClient.get(
                  any(
                    that: predicate<Uri>((requestUri) {
                      return baseUri.scheme == requestUri.scheme &&
                          baseUri.host == requestUri.host &&
                          baseUri.path == requestUri.path &&
                          requestUri.queryParameters['fileType'] ==
                              attachmentAction.attachment.type &&
                          requestUri.queryParameters['fileName'] != null;
                    }),
                  ),
                  headers: any(named: 'headers'),
                ),
              ).thenAnswer((_) async => getResponse);
              when(
                () => httpClient.put(
                  uploadUri,
                  headers: any(named: 'headers'),
                  body: bytes,
                  encoding: any(named: 'encoding'),
                ),
              ).thenAnswer((_) async => putResponse);

              expect(
                client.submitFormWithProgress(action, formData),
                emitsInOrder([
                  emitsError(equals(putResponse)),
                  emitsDone,
                ]),
              );
            });

            group('Images', () {
              final attachment = Attachment(
                name: 'name',
                url: Uri(
                  path: 'main',
                ),
                smallThumbnail: Uri(
                  path: 'small',
                ),
                largeThumbnail: Uri(
                  path: 'large',
                ),
                type: 'image/png',
              );
              final action =
                  ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
              final bytes = Uint8List(10);
              final attachmentAction =
                  AddAttachmentAction(byteData: bytes, attachment: attachment);
              const field = GridField(
                id: 'id',
                name: 'property',
                type: DataType.attachment,
              );
              final formData = FormData(
                id: 'formId',
                title: 'Title',
                components: [
                  FormComponent<AttachmentDataEntity>(
                    property: 'property',
                    data: AttachmentDataEntity([attachment]),
                    field: field,
                  ),
                ],
                fields: [field],
                links: {ApptiveLinkType.submit: action},
                attachmentActions: {attachment: attachmentAction},
              );

              test('Thumbnails are uploaded', () async {
                final uploadUri = Uri.parse('uploadUrl.com/data');
                final getResponse =
                    Response('{"uploadURL":"${uploadUri.toString()}"}', 200);
                final putResponse = Response('Success', 200);
                final baseUri = Uri.parse(
                  attachmentConfig[ApptiveGridEnvironment.production]!
                      .signedUrlApiEndpoint,
                );
                when(
                  () => httpClient.get(
                    any(
                      that: predicate<Uri>((requestUri) {
                        return baseUri.scheme == requestUri.scheme &&
                            baseUri.host == requestUri.host &&
                            baseUri.path == requestUri.path &&
                            requestUri.queryParameters['fileType'] ==
                                attachmentAction.attachment.type &&
                            requestUri.queryParameters['fileName'] != null;
                      }),
                    ),
                    headers: any(named: 'headers'),
                  ),
                ).thenAnswer((_) async => getResponse);
                when(
                  () => httpClient.put(
                    uploadUri,
                    headers: any(named: 'headers'),
                    body: bytes,
                    encoding: any(named: 'encoding'),
                  ),
                ).thenAnswer((_) async => putResponse);
                when(() => httpClient.send(any())).thenAnswer(
                  (realInvocation) async =>
                      StreamedResponse(Stream.value([]), 200),
                );

                expect(
                  client.submitFormWithProgress(action, formData),
                  emitsInOrder([
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) =>
                            event is ProcessedAttachmentProgressEvent &&
                            event.attachment == attachment,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) => event is AttachmentCompleteProgressEvent,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) =>
                            event is UploadFormProgressEvent &&
                            event.form == formData,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) => event is SubmitCompleteProgressEvent,
                      ),
                    ),
                    emitsDone,
                  ]),
                );
              });

              test('Thumbnail upload fails, main upload succeed, call succeeds',
                  () async {
                final uploadUri = Uri.parse('https://uploadUrl.com/data');
                final putSuccess = Response('Success', 200);
                final putFail = Response('Fail', 400);
                final baseUri = Uri.parse(
                  attachmentConfig[ApptiveGridEnvironment.production]!
                      .signedUrlApiEndpoint,
                );
                when(
                  () => httpClient.get(
                    any(
                      that: predicate<Uri>((requestUri) {
                        return baseUri.scheme == requestUri.scheme &&
                            baseUri.host == requestUri.host &&
                            baseUri.path == requestUri.path &&
                            requestUri.queryParameters['fileType'] ==
                                attachmentAction.attachment.type &&
                            requestUri.queryParameters['fileName'] != null;
                      }),
                    ),
                    headers: any(named: 'headers'),
                  ),
                ).thenAnswer((invocation) async {
                  final requestUri = uploadUri.replace(
                    pathSegments: [
                      (invocation.positionalArguments.first as Uri)
                          .queryParameters['fileName']!
                    ],
                  );
                  // Use filename in upload uri to match error responses
                  return Response(
                    '{"uploadURL":"${requestUri.toString()}"}',
                    200,
                  );
                });
                when(
                  () => httpClient.put(
                    any(
                      that: predicate<Uri>(
                        (uri) => uri.host == uploadUri.host,
                      ),
                    ),
                    headers: any(named: 'headers'),
                    body: bytes,
                    encoding: any(named: 'encoding'),
                  ),
                ).thenAnswer((invocation) async {
                  final uri = invocation.positionalArguments.first as Uri;
                  if (uri.pathSegments.last == 'main') {
                    return putSuccess;
                  } else {
                    return putFail;
                  }
                });
                when(() => httpClient.send(any())).thenAnswer(
                  (realInvocation) async =>
                      StreamedResponse(Stream.value([]), 200),
                );

                expect(
                  client.submitFormWithProgress(action, formData),
                  emitsInOrder([
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) =>
                            event is ProcessedAttachmentProgressEvent &&
                            event.attachment == attachment,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) => event is AttachmentCompleteProgressEvent,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) =>
                            event is UploadFormProgressEvent &&
                            event.form == formData,
                      ),
                    ),
                    emits(
                      predicate<SubmitFormProgressEvent>(
                        (event) => event is SubmitCompleteProgressEvent,
                      ),
                    ),
                    emitsDone,
                  ]),
                );
              });

              test('Main upload fails, thumbnails succeed, call fails',
                  () async {
                final uploadUri = Uri.parse('https://uploadUrl.com/data');
                final putSuccess = Response('Success', 200);
                final putFail = Response('Fail', 400);
                final baseUri = Uri.parse(
                  attachmentConfig[ApptiveGridEnvironment.production]!
                      .signedUrlApiEndpoint,
                );
                when(
                  () => httpClient.get(
                    any(
                      that: predicate<Uri>((requestUri) {
                        return baseUri.scheme == requestUri.scheme &&
                            baseUri.host == requestUri.host &&
                            baseUri.path == requestUri.path &&
                            requestUri.queryParameters['fileType'] ==
                                attachmentAction.attachment.type &&
                            requestUri.queryParameters['fileName'] != null;
                      }),
                    ),
                    headers: any(named: 'headers'),
                  ),
                ).thenAnswer((invocation) async {
                  final requestUri = uploadUri.replace(
                    pathSegments: [
                      (invocation.positionalArguments.first as Uri)
                          .queryParameters['fileName']!
                    ],
                  );
                  // Use filename in upload uri to match error responses
                  return Response(
                    '{"uploadURL":"${requestUri.toString()}"}',
                    200,
                  );
                });
                when(
                  () => httpClient.put(
                    any(
                      that: predicate<Uri>(
                        (uri) => uri.host == uploadUri.host,
                      ),
                    ),
                    headers: any(named: 'headers'),
                    body: bytes,
                    encoding: any(named: 'encoding'),
                  ),
                ).thenAnswer((invocation) async {
                  final uri = invocation.positionalArguments.first as Uri;
                  if (uri.pathSegments.last == 'main') {
                    return putFail;
                  } else {
                    return putSuccess;
                  }
                });
                when(() => httpClient.send(any())).thenAnswer(
                  (realInvocation) async =>
                      StreamedResponse(Stream.value([]), 200),
                );

                expect(
                  client.submitFormWithProgress(action, formData),
                  emitsInOrder([
                    emitsError(isA<Response>()),
                    emitsDone,
                  ]),
                );
              });
            });
          });
        });

        group(
            'TODO: NO OP ACTIONS '
            'These tests might need addition changes once the actions do more. '
            'For Now Check that formAction is performed', () {
          late ApptiveGridClient client;
          late Client httpClient;
          late ApptiveGridAuthenticator authenticator;

          const attachmentConfig = {
            ApptiveGridEnvironment.production: AttachmentConfiguration(
              attachmentApiEndpoint: 'attachmentEndpoint.com/',
              signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
            )
          };

          setUp(() {
            httpClient = MockHttpClient();
            authenticator = MockApptiveGridAuthenticator();
            when(() => authenticator.isAuthenticated)
                .thenAnswer((_) async => true);
            when(() => authenticator.checkAuthentication())
                .thenAnswer((_) async {});
            client = ApptiveGridClient(
              httpClient: httpClient,
              options: const ApptiveGridOptions(
                attachmentConfigurations: attachmentConfig,
                environment: ApptiveGridEnvironment.production,
                authenticationOptions: ApptiveGridAuthenticationOptions(
                  autoAuthenticate: true,
                ),
              ),
              authenticator: authenticator,
            );
          });
          test('Rename Action', () async {
            final attachment =
                Attachment(name: 'name', url: Uri(), type: 'type');
            final action =
                ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
            final attachmentAction = RenameAttachmentAction(
              newName: 'NewName',
              attachment: attachment,
            );
            const field = GridField(
              id: 'id',
              name: 'property',
              type: DataType.attachment,
            );
            final formData = FormData(
              id: 'formId',
              title: 'Title',
              components: [
                FormComponent<AttachmentDataEntity>(
                  property: 'property',
                  data: AttachmentDataEntity([attachment]),
                  field: field,
                ),
              ],
              fields: [field],
              links: {ApptiveLinkType.submit: action},
              attachmentActions: {attachment: attachmentAction},
            );

            when(() => httpClient.send(any())).thenAnswer(
              (realInvocation) async => StreamedResponse(Stream.value([]), 200),
            );

            expect(
              client.submitFormWithProgress(action, formData),
              emitsInOrder([
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is ProcessedAttachmentProgressEvent &&
                        event.attachment == attachment,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is AttachmentCompleteProgressEvent,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is UploadFormProgressEvent &&
                        event.form == formData,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is SubmitCompleteProgressEvent,
                  ),
                ),
                emitsDone,
              ]),
            );
          });

          test('Delete Action', () async {
            final attachment =
                Attachment(name: 'name', url: Uri(), type: 'type');
            final action =
                ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
            final attachmentAction =
                DeleteAttachmentAction(attachment: attachment);
            const field = GridField(
              id: 'id',
              name: 'property',
              type: DataType.attachment,
            );
            final formData = FormData(
              id: 'formId',
              title: 'Title',
              components: [
                FormComponent<AttachmentDataEntity>(
                  property: 'property',
                  data: AttachmentDataEntity([attachment]),
                  field: field,
                ),
              ],
              fields: [field],
              links: {ApptiveLinkType.submit: action},
              attachmentActions: {attachment: attachmentAction},
            );

            when(() => httpClient.send(any())).thenAnswer(
              (realInvocation) async => StreamedResponse(Stream.value([]), 200),
            );

            expect(
              client.submitFormWithProgress(action, formData),
              emitsInOrder([
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is ProcessedAttachmentProgressEvent &&
                        event.attachment == attachment,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is AttachmentCompleteProgressEvent,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is UploadFormProgressEvent &&
                        event.form == formData,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is SubmitCompleteProgressEvent,
                  ),
                ),
                emitsDone,
              ]),
            );
          });
        });
      });

      group('With Form Attachment Config', () {
        late ApptiveGridClient client;
        late Client httpClient;
        late ApptiveGridAuthenticator authenticator;

        const attachmentConfig = {
          ApptiveGridEnvironment.production: AttachmentConfiguration(
            attachmentApiEndpoint: 'attachmentEndpoint.com/',
            signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
            signedUrlFormApiEndpoint: 'signedUrlFormApiEndpoint.com/',
          )
        };

        setUp(() {
          httpClient = MockHttpClient();
          authenticator = MockApptiveGridAuthenticator();
          when(() => authenticator.isAuthenticated)
              .thenAnswer((_) async => true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          client = ApptiveGridClient(
            httpClient: httpClient,
            options: const ApptiveGridOptions(
              attachmentConfigurations: attachmentConfig,
              environment: ApptiveGridEnvironment.production,
              authenticationOptions: ApptiveGridAuthenticationOptions(
                autoAuthenticate: true,
              ),
            ),
            authenticator: authenticator,
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
            return Response('{}', 200);
          });
        });

        group('Upload Data', () {
          final attachment = Attachment(
            name: 'name',
            url: Uri(path: 'with/path'),
            type: 'type',
          );
          final action =
              ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
          final bytes = Uint8List(10);
          final attachmentAction =
              AddAttachmentAction(byteData: bytes, attachment: attachment);
          const field =
              GridField(id: 'id', name: 'property', type: DataType.attachment);
          final formData = FormData(
            id: 'formId',
            title: 'Title',
            components: [
              FormComponent<AttachmentDataEntity>(
                property: 'property',
                data: AttachmentDataEntity([attachment]),
                field: field,
              ),
            ],
            fields: [field],
            links: {ApptiveLinkType.submit: action},
            attachmentActions: {attachment: attachmentAction},
          );

          test('Creates upload Url without headers', () async {
            when(() => authenticator.isAuthenticated)
                .thenAnswer((_) async => false);
            final uploadUri = Uri.parse('uploadUrl.com/data');
            final getResponse =
                Response('{"uploadURL":"${uploadUri.toString()}"}', 200);
            final putResponse = Response('Success', 200);
            final baseUri = Uri.parse(
              attachmentConfig[ApptiveGridEnvironment.production]!
                  .signedUrlFormApiEndpoint!,
            );
            when(
              () => httpClient.get(
                any(
                  that: predicate<Uri>((requestUri) {
                    return baseUri.scheme == requestUri.scheme &&
                        baseUri.host == requestUri.host &&
                        baseUri.path == requestUri.path &&
                        requestUri.queryParameters['fileType'] ==
                            attachmentAction.attachment.type &&
                        requestUri.queryParameters['fileName'] != null;
                  }),
                ),
                headers: any(named: 'headers'),
              ),
            ).thenAnswer((_) async => getResponse);
            when(
              () => httpClient.put(
                uploadUri,
                headers: any(named: 'headers'),
                body: bytes,
                encoding: any(named: 'encoding'),
              ),
            ).thenAnswer((_) async => putResponse);
            when(() => httpClient.send(any())).thenAnswer(
              (realInvocation) async => StreamedResponse(Stream.value([]), 200),
            );

            expect(
              client.submitFormWithProgress(action, formData),
              emitsInOrder([
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is ProcessedAttachmentProgressEvent &&
                        event.attachment == attachment,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is AttachmentCompleteProgressEvent,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) =>
                        event is UploadFormProgressEvent &&
                        event.form == formData,
                  ),
                ),
                emits(
                  predicate<SubmitFormProgressEvent>(
                    (event) => event is SubmitCompleteProgressEvent,
                  ),
                ),
                emitsDone,
              ]),
            );
          });
        });
      });
    });

    group('Caching Form Actions', () {
      final httpClient = MockHttpClient();

      final cache = MockApptiveGridCache();

      final options = ApptiveGridOptions(cache: cache);

      late ApptiveGridClient client;

      final action = ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');

      final data = FormData(
        id: 'formId',
        name: 'Name',
        title: 'title',
        components: [],
        fields: [],
        links: {},
      );

      final cacheMap = <String, dynamic>{};

      setUp(() {
        when(() => cache.addPendingActionItem(any())).thenAnswer(
          (invocation) =>
              cacheMap[invocation.positionalArguments[0].toString()] =
                  (invocation.positionalArguments[0] as ActionItem).toJson(),
        );
        when(() => cache.removePendingActionItem(any())).thenAnswer(
          (invocation) => cacheMap
              .remove(cacheMap[invocation.positionalArguments[0].toString()]),
        );
        when(() => cache.getPendingActionItems()).thenAnswer(
          (invocation) =>
              cacheMap.values.map((e) => ActionItem.fromJson(e)).toList(),
        );
        cacheMap.clear();
        final authenticator = MockApptiveGridAuthenticator();
        when(() => authenticator.isAuthenticated).thenAnswer(
          (_) async => true,
        );
        when(() => authenticator.checkAuthentication()).thenAnswer(
          (_) async {},
        );
        client = ApptiveGridClient(
          httpClient: httpClient,
          options: options,
          authenticator: authenticator,
        );
      });

      test('Fail, gets saved to pending', () async {
        when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
          return StreamedResponse(Stream.value([]), 400);
        });

        await expectLater(
          client.submitFormWithProgress(action, data),
          emitsInOrder([
            emits(
              predicate<SubmitFormProgressEvent>(
                (event) => event is AttachmentCompleteProgressEvent,
              ),
            ),
            emits(
              predicate<SubmitFormProgressEvent>(
                (event) =>
                    event is UploadFormProgressEvent && event.form == data,
              ),
            ),
            emits(
              predicate<SubmitFormProgressEvent>(
                (event) =>
                    event is SubmitCompleteProgressEvent &&
                    event.response!.statusCode == 400,
              ),
            ),
            emitsDone,
          ]),
        );

        verify(() => cache.addPendingActionItem(any())).called(1);

        when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
          return StreamedResponse(Stream.value([]), 200);
        });

        await client.sendPendingActions();

        verify(() => cache.removePendingActionItem(any())).called(1);
      });

      test('Attachment fail is saved to pending', () async {
        const attachmentConfig = {
          ApptiveGridEnvironment.production: AttachmentConfiguration(
            attachmentApiEndpoint: 'attachmentEndpoint.com/',
            signedUrlApiEndpoint: 'signedUrlApiEndpoint.com/',
            signedUrlFormApiEndpoint: 'signedUrlFormApiEndpoint.com/',
          )
        };
        final attachment = Attachment(
          name: 'name',
          url: Uri(path: 'with/path'),
          type: 'type',
        );
        final action = ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
        final bytes = Uint8List(10);
        final attachmentAction =
            AddAttachmentAction(byteData: bytes, attachment: attachment);
        const field =
            GridField(id: 'id', name: 'property', type: DataType.attachment);
        final formData = FormData(
          id: 'formId',
          title: 'Title',
          components: [
            FormComponent<AttachmentDataEntity>(
              property: 'property',
              data: AttachmentDataEntity([attachment]),
              field: field,
            ),
          ],
          fields: [field],
          links: {ApptiveLinkType.submit: action},
          attachmentActions: {attachment: attachmentAction},
        );
        final uploadUri = Uri.parse('uploadUrl.com/data');
        final putResponse = Response('Error', 500);
        final baseUri = Uri.parse(
          attachmentConfig[ApptiveGridEnvironment.production]!
              .signedUrlApiEndpoint,
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
          return Response('{}', 200);
        });
        when(
          () => httpClient.get(
            any(
              that: predicate<Uri>((requestUri) {
                return baseUri.scheme == requestUri.scheme &&
                    baseUri.host == requestUri.host &&
                    baseUri.path == requestUri.path &&
                    requestUri.queryParameters['fileType'] ==
                        attachmentAction.attachment.type &&
                    requestUri.queryParameters['fileName'] != null;
              }),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) => Future.error(putResponse));
        when(
          () => httpClient.put(
            uploadUri,
            headers: any(named: 'headers'),
            body: bytes,
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => putResponse);

        await expectLater(
          client.submitFormWithProgress(action, formData),
          emitsInOrder([
            emits(
              predicate<SubmitFormProgressEvent>(
                (event) =>
                    event is SubmitCompleteProgressEvent &&
                    event.response!.statusCode == 400,
              ),
            ),
            emitsDone,
          ]),
        );

        verify(() => cache.addPendingActionItem(any())).called(1);
      });
    });
  });
}
