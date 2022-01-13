import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';

import 'mocks.dart';

void main() {
  final httpClient = MockHttpClient();
  late ApptiveGridClient apptiveGridClient;

  setUpAll(() {
    registerFallbackValue(Request('GET', Uri()));
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});

    registerFallbackValue(
      ActionItem(
        action: FormAction('uri', 'method'),
        data: FormData(
          name: 'name',
          title: 'title',
          components: [],
          actions: [],
          schema: {},
        ),
      ),
    );
  });

  setUp(() {
    final mockUniLink = MockUniLinks();
    UniLinksPlatform.instance = mockUniLink;
    final stream = StreamController<String?>.broadcast();
    when(() => mockUniLink.linkStream).thenAnswer((_) => stream.stream);

    apptiveGridClient = ApptiveGridClient.fromClient(httpClient);
  });

  tearDown(() {
    apptiveGridClient.dispose();
  });

  group('loadForm', () {
    final rawResponse = {
      'schema': {
        'type': 'object',
        'properties': {
          '4zc4l48ffin5v8pa2emyx9s15': {'type': 'string'},
        },
        'required': []
      },
      'actions': [
        {'uri': '/api/a/3ojhtqiltc0kiylfp8nddmxmk', 'method': 'POST'}
      ],
      'components': [
        {
          'property': 'TextC',
          'value': null,
          'required': false,
          'options': {
            'multi': false,
            'placeholder': '',
            'description': '',
            'label': null
          },
          'type': 'textfield',
          'fieldId': '4zc4l48ffin5v8pa2emyx9s15'
        },
      ],
      'name': 'Name',
      'title': 'Form'
    };

    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final formData = await apptiveGridClient.loadForm(
        formUri: RedirectFormUri(components: ['FormId']),
      );

      expect(formData.title, 'Form');
      expect(formData.components.length, 1);
      expect(formData.components[0].runtimeType, StringFormComponent);
      expect(formData.actions.length, 1);
    });

    test('DirectUri checks authentication', () async {
      final response = Response(json.encode(rawResponse), 200);
      final authenticator = MockApptiveGridAuthenticator();
      final client = ApptiveGridClient.fromClient(
        httpClient,
        authenticator: authenticator,
      );

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);
      when(() => authenticator.checkAuthentication())
          .thenAnswer((_) => Future.value());

      unawaited(
        client.loadForm(
          formUri: DirectFormUri(
            user: 'user',
            space: 'space',
            grid: 'grid',
            form: 'FormId',
          ),
        ),
      );
      verify(() => authenticator.checkAuthentication()).called(1);
    });

    test('400+ Response throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.loadForm(
          formUri: RedirectFormUri(components: ['FormId']),
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('Load Grid', () {
    final rawResponse = {
      'fieldNames': ['First Name', 'Last Name', 'imgUrl'],
      'entities': [
        {
          'fields': [
            'Julia',
            'Arnold',
            'https://ca.slack-edge.com/T02TE01SG-U9AJEEH7Z-19c78728dca3-512'
          ],
          '_id': '2ozv8sbju97gk1ukfbl3f3fl1'
        },
      ],
      'fieldIds': [
        '2ozv8saj00bdp85gr8r9wc5up',
        '2ozv8scn6q8gnhivpmhn5u875',
        '2ozv8sai5hc0pzdd2c2ifs64g'
      ],
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
              {'type': 'string'},
              {'type': 'string'}
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Contacts'
    };
    test('Success', () async {
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final grid = await apptiveGridClient.loadGrid(
        gridUri: GridUri(
          user: user,
          space: space,
          grid: gridId,
        ),
      );

      expect(grid, isNot(null));
    });

    test('400 Status throws Response', () async {
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId),
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('performAction', () {
    test('Successful', () async {
      final action = FormAction('/uri', 'POST');
      const property = 'Checkbox';
      const id = 'id';
      final component = BooleanFormComponent(
        fieldId: id,
        property: property,
        data: BooleanDataEntity(true),
        options: FormComponentOptions.fromJson({}),
        required: false,
      );
      final schema = {
        'type': 'object',
        'properties': {
          id: {'type': 'boolean'},
        },
        'required': []
      };
      final formData = FormData(
        name: 'Name',
        title: 'Title',
        components: [component],
        actions: [action],
        schema: schema,
      );

      final request = Request(
        'POST',
        Uri.parse('${ApptiveGridEnvironment.production.url}/uri}'),
      );
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      late BaseRequest calledRequest;

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        calledRequest = realInvocation.positionalArguments[0];
        return StreamedResponse(Stream.value([]), 200);
      });

      final response = await apptiveGridClient.performAction(action, formData);

      expect(response.statusCode, 200);
      expect(calledRequest.method, action.method);
      expect(
        calledRequest.url.toString(),
        '${ApptiveGridEnvironment.production.url}${action.uri}',
      );
      expect(
        calledRequest.headers[HttpHeaders.contentTypeHeader],
        ContentType.json,
      );
    });

    test('Error without Cache throws Response', () async {
      final action = FormAction('/uri', 'POST');
      const property = 'Checkbox';
      const id = 'id';
      final component = BooleanFormComponent(
        fieldId: id,
        property: property,
        data: BooleanDataEntity(true),
        options: FormComponentOptions.fromJson({}),
        required: false,
      );
      final schema = {
        'type': 'object',
        'properties': {
          id: {'type': 'boolean'},
        },
        'required': []
      };
      final formData = FormData(
        name: 'Name',
        title: 'Title',
        components: [component],
        actions: [action],
        schema: schema,
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
        () async => await apptiveGridClient.performAction(action, formData),
        throwsA(isInstanceOf<Response>()),
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
          when(() => authenticator.isAuthenticated).thenReturn(true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          client = ApptiveGridClient.fromClient(
            httpClient,
            options: const ApptiveGridOptions(
              environment: ApptiveGridEnvironment.production,
              authenticationOptions: ApptiveGridAuthenticationOptions(
                autoAuthenticate: true,
              ),
            ),
            authenticator: authenticator,
          );
        });

        test('Create Attachment Uri, throws Error', () {
          expect(
            () => client.createAttachmentUrl('Name'),
            throwsA(isInstanceOf<ArgumentError>()),
          );
        });

        test('Upload Attachment, throws Error', () {
          final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
          final action = FormAction('actionUri', 'POST');
          final bytes = Uint8List(10);
          final formData = FormData(
            title: 'Title',
            components: [
              AttachmentFormComponent(
                property: 'property',
                data: AttachmentDataEntity([attachment]),
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
            actions: [action],
            attachmentActions: {
              attachment:
                  AddAttachmentAction(byteData: bytes, attachment: attachment)
            },
          );

          expect(
            () => client.performAction(action, formData),
            throwsArgumentError,
          );
        });
      });

      group('With Attachment Config', () {
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
          when(() => authenticator.isAuthenticated).thenReturn(true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          client = ApptiveGridClient.fromClient(
            httpClient,
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

        test('Creates Attachment Uri based on config', () {
          const name = 'FileName';
          expect(
            client.createAttachmentUrl(name).toString(),
            predicate<String>(
              (uriString) =>
                  uriString.startsWith('attachmentEndpoint.com/$name?'),
            ),
          );
        });

        group('Upload Data', () {
          final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
          final action = FormAction('actionUri', 'POST');
          final bytes = Uint8List(10);
          final attachmentAction =
              AddAttachmentAction(byteData: bytes, attachment: attachment);
          final formData = FormData(
            title: 'Title',
            components: [
              AttachmentFormComponent(
                property: 'property',
                data: AttachmentDataEntity([attachment]),
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
            actions: [action],
            attachmentActions: {attachment: attachmentAction},
          );

          test('Getting Upload Url fails', () async {
            final response = Response('body', 400);
            final baseUri = Uri.parse(
              attachmentConfig[ApptiveGridEnvironment.production]!
                  .signedUrlApiEndpoint,
            );
            final uri = Uri(
              scheme: baseUri.scheme,
              host: baseUri.host,
              path: baseUri.path,
              queryParameters: {
                'fileName': attachmentAction.attachment.name,
                'fileType': attachmentAction.attachment.type,
              },
            );
            when(() => httpClient.get(uri, headers: any(named: 'headers')))
                .thenAnswer((_) async => response);

            expect(
              () async => await client.performAction(action, formData),
              throwsA(equals(response)),
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
            final uri = Uri(
              scheme: baseUri.scheme,
              host: baseUri.host,
              path: baseUri.path,
              queryParameters: {
                'fileName': attachmentAction.attachment.name,
                'fileType': attachmentAction.attachment.type,
              },
            );
            when(() => httpClient.get(uri, headers: any(named: 'headers')))
                .thenAnswer((_) async => getResponse);
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

            await client.performAction(action, formData);

            verify(() => httpClient.get(uri, headers: any(named: 'headers')))
                .called(1);
            verify(
              () => httpClient.put(
                uploadUri,
                headers: any(named: 'headers'),
                body: bytes,
                encoding: any(named: 'encoding'),
              ),
            ).called(1);
            verify(() => httpClient.send(any())).called(1);
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
            final uri = Uri(
              scheme: baseUri.scheme,
              host: baseUri.host,
              path: baseUri.path,
              queryParameters: {
                'fileName': attachmentAction.attachment.name,
                'fileType': attachmentAction.attachment.type,
              },
            );
            when(() => httpClient.get(uri, headers: any(named: 'headers')))
                .thenAnswer((_) async => getResponse);
            when(
              () => httpClient.put(
                uploadUri,
                headers: any(named: 'headers'),
                body: bytes,
                encoding: any(named: 'encoding'),
              ),
            ).thenAnswer((_) async => putResponse);

            await expectLater(
              () async => await client.performAction(action, formData),
              throwsA(equals(putResponse)),
            );

            verify(() => httpClient.get(uri, headers: any(named: 'headers')))
                .called(1);
            verify(
              () => httpClient.put(
                uploadUri,
                headers: any(named: 'headers'),
                body: bytes,
                encoding: any(named: 'encoding'),
              ),
            ).called(1);
            verifyNever(() => httpClient.send(any()));
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
            when(() => authenticator.isAuthenticated).thenReturn(true);
            when(() => authenticator.checkAuthentication())
                .thenAnswer((_) async {});
            client = ApptiveGridClient.fromClient(
              httpClient,
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
            final action = FormAction('actionUri', 'POST');
            final attachmentAction = RenameAttachmentAction(
              newName: 'NewName',
              attachment: attachment,
            );
            final formData = FormData(
              title: 'Title',
              components: [
                AttachmentFormComponent(
                  property: 'property',
                  data: AttachmentDataEntity([attachment]),
                  fieldId: 'fieldId',
                ),
              ],
              schema: null,
              actions: [action],
              attachmentActions: {attachment: attachmentAction},
            );

            when(() => httpClient.send(any())).thenAnswer(
              (realInvocation) async => StreamedResponse(Stream.value([]), 200),
            );

            await client.performAction(action, formData);

            verify(() => httpClient.send(any())).called(1);
          });

          test('Delete Action', () async {
            final attachment =
                Attachment(name: 'name', url: Uri(), type: 'type');
            final action = FormAction('actionUri', 'POST');
            final attachmentAction =
                DeleteAttachmentAction(attachment: attachment);
            final formData = FormData(
              title: 'Title',
              components: [
                AttachmentFormComponent(
                  property: 'property',
                  data: AttachmentDataEntity([attachment]),
                  fieldId: 'fieldId',
                ),
              ],
              schema: null,
              actions: [action],
              attachmentActions: {attachment: attachmentAction},
            );

            when(() => httpClient.send(any())).thenAnswer(
              (realInvocation) async => StreamedResponse(Stream.value([]), 200),
            );

            await client.performAction(action, formData);

            verify(() => httpClient.send(any())).called(1);
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
          when(() => authenticator.isAuthenticated).thenReturn(true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
          client = ApptiveGridClient.fromClient(
            httpClient,
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

        group('Upload Data', () {
          final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
          final action = FormAction('actionUri', 'POST');
          final bytes = Uint8List(10);
          final attachmentAction =
              AddAttachmentAction(byteData: bytes, attachment: attachment);
          final formData = FormData(
            title: 'Title',
            components: [
              AttachmentFormComponent(
                property: 'property',
                data: AttachmentDataEntity([attachment]),
                fieldId: 'fieldId',
              ),
            ],
            schema: null,
            actions: [action],
            attachmentActions: {attachment: attachmentAction},
          );

          test('Creates upload Url without headers', () async {
            final uploadUri = Uri.parse('uploadUrl.com/data');
            final getResponse =
                Response('{"uploadURL":"${uploadUri.toString()}"}', 200);
            final putResponse = Response('Success', 200);
            final baseUri = Uri.parse(
              attachmentConfig[ApptiveGridEnvironment.production]!
                  .signedUrlFormApiEndpoint!,
            );
            final uri = Uri(
              scheme: baseUri.scheme,
              host: baseUri.host,
              path: baseUri.path,
              queryParameters: {
                'fileName': attachmentAction.attachment.name,
                'fileType': attachmentAction.attachment.type,
              },
            );
            when(() => httpClient.get(uri, headers: any(named: 'headers')))
                .thenAnswer((_) async => getResponse);
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

            await client.performAction(action, formData);

            final captures = verify(
              () => httpClient.get(
                captureAny(),
                headers: captureAny(named: 'headers'),
              ),
            ).captured;
            final capturedUri = captures.first as Uri;
            final capturedHeaders = captures[1] as Map<String, String>;
            expect(
              capturedUri.host,
              Uri.parse(
                attachmentConfig[ApptiveGridEnvironment.production]!
                    .signedUrlFormApiEndpoint!,
              ).host,
            );
            expect(capturedHeaders[HttpHeaders.authorizationHeader], isNull);
            verify(
              () => httpClient.put(
                uploadUri,
                headers: any(named: 'headers'),
                body: bytes,
                encoding: any(named: 'encoding'),
              ),
            ).called(1);
            verify(() => httpClient.send(captureAny())).called(1);
          });
        });
      });
    });
  });

  group('Environment', () {
    test('Check Urls', () {
      expect(ApptiveGridEnvironment.alpha.url, 'https://alpha.apptivegrid.de');
      expect(ApptiveGridEnvironment.beta.url, 'https://beta.apptivegrid.de');
      expect(
        ApptiveGridEnvironment.production.url,
        'https://app.apptivegrid.de',
      );
    });

    test('Check Auth Realm', () {
      expect(ApptiveGridEnvironment.alpha.authRealm, 'apptivegrid-test');
      expect(ApptiveGridEnvironment.beta.authRealm, 'apptivegrid-test');
      expect(ApptiveGridEnvironment.production.authRealm, 'apptivegrid');
    });
  });

  group('Headers', () {
    test('No Authentication only content type headers', () {
      final client = ApptiveGridClient();
      expect(client.headers, {
        HttpHeaders.contentTypeHeader: ContentType.json,
      });
    });

    test('With Authentication has headers', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.header)
          .thenReturn('Bearer dXNlcm5hbWU6cGFzc3dvcmQ=');
      final client = ApptiveGridClient.fromClient(
        httpClient,
        authenticator: authenticator,
      );
      expect(client.headers, {
        HttpHeaders.authorizationHeader: 'Bearer dXNlcm5hbWU6cGFzc3dvcmQ=',
        HttpHeaders.contentTypeHeader: ContentType.json
      });
    });
  });

  group('Authorization', () {
    test('Authorize calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.authenticate())
          .thenAnswer((_) async => MockCredential());
      final client = ApptiveGridClient.fromClient(
        httpClient,
        authenticator: authenticator,
      );
      client.authenticate();

      verify(() => authenticator.authenticate()).called(1);
    });

    test('Logout calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.logout()).thenAnswer((_) async {});
      final client = ApptiveGridClient.fromClient(
        httpClient,
        authenticator: authenticator,
      );
      client.logout();

      verify(() => authenticator.logout()).called(1);
    });

    test('isAuthenticated calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.isAuthenticated).thenAnswer((_) => true);
      final client = ApptiveGridClient.fromClient(
        httpClient,
        authenticator: authenticator,
      );
      client.isAuthenticated;

      verify(() => authenticator.isAuthenticated).called(1);
    });
  });

  group('/user/me', () {
    final rawResponse = {
      'id': 'id',
      'firstName': 'Jane',
      'lastName': 'Doe',
      'email': 'jane.doe@zweidenker.de',
      'spaceUris': [
        '/api/users/id/spaces/spaceId',
      ]
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse('${ApptiveGridEnvironment.production.url}/api/users/me'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final user = await apptiveGridClient.getMe();

      expect(user, isNot(null));
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse('${ApptiveGridEnvironment.production.url}/api/users/me'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getMe(),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('get Space', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    final spaceUri = SpaceUri(user: userId, space: spaceId);
    final rawResponse = {
      'id': spaceId,
      'name': 'TestSpace',
      'gridUris': [
        '/api/users/id/spaces/spaceId/grids/gridId',
      ]
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final space = await apptiveGridClient.getSpace(spaceUri: spaceUri);

      expect(space, isNot(null));
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getSpace(spaceUri: spaceUri),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('get Forms', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';
    const form0 = 'formId0';
    const form1 = 'formId1';
    final gridUri = GridUri(user: userId, space: spaceId, grid: gridId);
    final rawResponse = [
      '/api/users/id/spaces/spaceId/grids/gridId/forms/$form0',
      '/api/users/id/spaces/spaceId/grids/gridId/forms/$form1',
    ];
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/forms',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final forms = await apptiveGridClient.getForms(gridUri: gridUri);

      expect(forms.length, 2);
      expect(
        forms[0].uriString,
        '/api/users/id/spaces/spaceId/grids/gridId/forms/$form0',
      );
      expect(
        forms[1].uriString,
        '/api/users/id/spaces/spaceId/grids/gridId/forms/$form1',
      );
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/forms',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getForms(gridUri: gridUri),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('GridViews', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';
    const view0 = 'viewId0';
    const view1 = 'viewId1';
    final gridUri = GridUri(user: userId, space: spaceId, grid: gridId);
    final rawResponse = [
      '/api/users/id/spaces/spaceId/grids/gridId/views/$view0',
      '/api/users/id/spaces/spaceId/grids/gridId/views/$view1',
    ];
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/views',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final views = await apptiveGridClient.getGridViews(gridUri: gridUri);

      expect(views.length, 2);
      expect(
        views[0].uriString,
        '/api/users/id/spaces/spaceId/grids/gridId/views/$view0',
      );
      expect(
        views[1].uriString,
        '/api/users/id/spaces/spaceId/grids/gridId/views/$view1',
      );
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/views',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getGridViews(gridUri: gridUri),
        throwsA(isInstanceOf<Response>()),
      );
    });

    test('GridView parses Filters', () async {
      final gridViewResponse = {
        'fieldNames': ['First Name', 'Last Name', 'imgUrl'],
        'entities': [
          {
            'fields': [
              'Adam',
              'Riese',
              'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg/600px-W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg'
            ],
            '_id': '60c9c997f8eeb8636c8140c4'
          }
        ],
        'fieldIds': [
          '9fqx8om03flgh8d4m1l953x29',
          '9fqx8okgtzoafyanblvfg61cl',
          '9fqx8on7ee2hq5iv20vcu9svw'
        ],
        'filter': {
          '9fqx8om03flgh8d4m1l953x29': {'\$substring': 'a'}
        },
        'schema': {
          'type': 'object',
          'properties': {
            'fields': {
              'type': 'array',
              'items': [
                {'type': 'string'},
                {'type': 'string'},
                {'type': 'string'}
              ]
            },
            '_id': {'type': 'string'}
          }
        },
        'name': 'New grid view'
      };

      final response = Response(json.encode(gridViewResponse), 200);

      when(
        () => httpClient.get(
          any(),
          headers: any(
            named: 'headers',
          ),
        ),
      ).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments.first as Uri;
        if (uri.path.endsWith('/views/$view0')) {
          return response;
        } else if (uri.path.endsWith('entities')) {
          return Response(json.encode(gridViewResponse['entities']), 200);
        } else {
          throw Exception();
        }
      });

      final gridView = await apptiveGridClient.loadGrid(
        gridUri: GridViewUri(
          user: userId,
          space: spaceId,
          grid: gridId,
          view: view0,
        ),
      );

      expect(gridView.filter != null, true);
      expect(gridView.fields.length, 3);
      expect(gridView.rows.length, 1);
    });

    test('GridView sorting gets applied in request', () async {
      final rawGridViewResponse = {
        'fieldNames': ['First Name', 'Last Name', 'imgUrl'],
        'entities': [
          {
            'fields': [
              'Adam',
              'Riese',
              'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg/600px-W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg'
            ],
            '_id': '60c9c997f8eeb8636c8140c4'
          }
        ],
        'fieldIds': [
          '9fqx8om03flgh8d4m1l953x29',
          '9fqx8okgtzoafyanblvfg61cl',
          '9fqx8on7ee2hq5iv20vcu9svw'
        ],
        'filter': {
          '9fqx8om03flgh8d4m1l953x29': {'\$substring': 'a'}
        },
        'schema': {
          'type': 'object',
          'properties': {
            'fields': {
              'type': 'array',
              'items': [
                {'type': 'string'},
                {'type': 'string'},
                {'type': 'string'}
              ]
            },
            '_id': {'type': 'string'}
          }
        },
        'name': 'New grid view'
      };

      final rawGridViewEntitiesResponse = [
        {
          'fields': [
            'Adam',
            'Riese',
            'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg/600px-W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg'
          ],
          '_id': '60c9c997f8eeb8636c8140c4'
        }
      ];

      final gridViewResponse = Response(json.encode(rawGridViewResponse), 200);
      final gridViewEntitiesResponse =
          Response(json.encode(rawGridViewEntitiesResponse), 200);

      when(
        () => httpClient.get(
          any(),
          headers: any(
            named: 'headers',
          ),
        ),
      ).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments.first as Uri;
        if (uri.path.endsWith('/views/$view0')) {
          return gridViewResponse;
        } else if (uri.path.endsWith('entities')) {
          return gridViewEntitiesResponse;
        } else {
          throw Exception();
        }
      });

      await apptiveGridClient.loadGrid(
        sorting: [
          const ApptiveGridSorting(
            fieldId: '9fqx8om03flgh8d4m1l953x29',
            order: SortOrder.desc,
          )
        ],
        gridUri: GridViewUri(
          user: userId,
          space: spaceId,
          grid: gridId,
          view: view0,
        ),
      );

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (uri) =>
                  uri.path.endsWith('/entities') &&
                  uri.queryParameters.containsKey('sorting'),
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('GridView filters get applied in request', () async {
      final rawGridViewResponse = {
        'fieldNames': ['First Name', 'Last Name', 'imgUrl'],
        'entities': [
          {
            'fields': [
              'Adam',
              'Riese',
              'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg/600px-W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg'
            ],
            '_id': '60c9c997f8eeb8636c8140c4'
          }
        ],
        'fieldIds': [
          '9fqx8om03flgh8d4m1l953x29',
          '9fqx8okgtzoafyanblvfg61cl',
          '9fqx8on7ee2hq5iv20vcu9svw'
        ],
        'filter': {
          '9fqx8om03flgh8d4m1l953x29': {'\$substring': 'a'}
        },
        'schema': {
          'type': 'object',
          'properties': {
            'fields': {
              'type': 'array',
              'items': [
                {'type': 'string'},
                {'type': 'string'},
                {'type': 'string'}
              ]
            },
            '_id': {'type': 'string'}
          }
        },
        'name': 'New grid view'
      };

      final rawGridViewEntitiesResponse = [
        {
          'fields': [
            'Adam',
            'Riese',
            'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg/600px-W._S._Gilbert_-_Alice_B._Woodward_-_The_Pinafore_Picture_Book_-_Frontispiece.jpg'
          ],
          '_id': '60c9c997f8eeb8636c8140c4'
        }
      ];

      final gridViewResponse = Response(json.encode(rawGridViewResponse), 200);
      final gridViewEntitiesResponse =
          Response(json.encode(rawGridViewEntitiesResponse), 200);

      when(
        () => httpClient.get(
          any(),
          headers: any(
            named: 'headers',
          ),
        ),
      ).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments.first as Uri;
        if (uri.path.endsWith('/views/$view0')) {
          return gridViewResponse;
        } else if (uri.path.endsWith('entities')) {
          return gridViewEntitiesResponse;
        } else {
          throw Exception();
        }
      });

      await apptiveGridClient.loadGrid(
        filter: SubstringFilter(
          fieldId: '9fqx8om03flgh8d4m1l953x29',
          value: StringDataEntity('a'),
        ),
        gridUri: GridViewUri(
          user: userId,
          space: spaceId,
          grid: gridId,
          view: view0,
        ),
      );

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (uri) =>
                  uri.path.endsWith('/entities') &&
                  uri.queryParameters.containsKey('filter'),
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });
  });

  group('Caching Form Actions', () {
    final httpClient = MockHttpClient();

    final cache = MockApptiveGridCache();

    final options = ApptiveGridOptions(cache: cache);

    late ApptiveGridClient client;

    final action = FormAction('actionUri', 'POST');

    final data = FormData(
      name: 'Name',
      title: 'title',
      components: [],
      actions: [],
      schema: {},
    );

    final cacheMap = <String, dynamic>{};

    setUp(() {
      when(() => cache.addPendingActionItem(any())).thenAnswer(
        (invocation) => cacheMap[invocation.positionalArguments[0].toString()] =
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
      client = ApptiveGridClient.fromClient(httpClient, options: options);
    });

    test('Fail, gets send from pending', () async {
      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      await expectLater(
        (await client.performAction(action, data)).statusCode,
        400,
      );

      verify(() => cache.addPendingActionItem(any())).called(1);

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 200);
      });

      await client.sendPendingActions();

      verify(() => cache.removePendingActionItem(any())).called(1);
    });

    test('Sending Throws Exception, Saves Action', () async {
      when(() => httpClient.send(any()))
          .thenThrow(const SocketException('Socket Exception'));

      await expectLater(
        (await client.performAction(action, data)).statusCode,
        400,
      );

      verify(() => cache.addPendingActionItem(any())).called(1);
    });

    test('Resubmit fails does not crash', () async {
      final actionItem = ActionItem(action: action, data: data);
      cacheMap[actionItem.toString()] = actionItem.toJson();

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      await client.sendPendingActions();

      verifyNever(() => cache.removePendingActionItem(any()));
      verifyNever(() => cache.addPendingActionItem(any()));
    });
  });

  group('EditLink', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';
    const entityId = 'entityId';
    const form = 'form';
    final entityUri =
        EntityUri(user: userId, space: spaceId, grid: gridId, entity: entityId);
    final rawResponse = {
      'uri': '/api/r/$form',
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.post(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId/EditLink',
          ),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      final formUri = await apptiveGridClient.getEditLink(
        entityUri: entityUri,
        formId: form,
      );

      expect(formUri.runtimeType, RedirectFormUri);
      expect(formUri.uriString, '/api/a/$form');
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.post(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId/EditLink',
          ),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getEditLink(entityUri: entityUri, formId: form),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('Switch Stage', () {
    late Client httpClient;
    late ApptiveGridClient client;
    late ApptiveGridOptions initialOptions;
    late ApptiveGridAuthenticator authenticator;

    setUp(() {
      httpClient = MockHttpClient();
      initialOptions =
          const ApptiveGridOptions(environment: ApptiveGridEnvironment.alpha);
      authenticator = ApptiveGridAuthenticator(
        options: initialOptions,
        httpClient: httpClient,
      );
      client = ApptiveGridClient.fromClient(
        httpClient,
        options: initialOptions,
        authenticator: authenticator,
      );

      when(() => httpClient.send(any())).thenAnswer(
        (invocation) async => StreamedResponse(
          Stream.value([]),
          200,
          request: invocation.positionalArguments[0] as BaseRequest,
        ),
      );
    });

    test('switch url', () async {
      expect(client.options.environment, ApptiveGridEnvironment.alpha);

      await client.updateEnvironment(ApptiveGridEnvironment.production);

      expect(client.options.environment, ApptiveGridEnvironment.production);
    });

    test('switch authenticator environment', () async {
      expect(authenticator.options.environment, ApptiveGridEnvironment.alpha);

      await client.updateEnvironment(ApptiveGridEnvironment.production);

      expect(
        authenticator.options.environment,
        ApptiveGridEnvironment.production,
      );
    });
  });
}
