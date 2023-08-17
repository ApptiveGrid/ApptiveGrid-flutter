import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:apptive_grid_core/src/network/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart' show TokenResponse;
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'authenticator_test.dart';
import 'mocks.dart';

void main() {
  final httpClient = MockHttpClient();
  late ApptiveGridAuthenticator authenticator;
  late ApptiveGridClient apptiveGridClient;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(Request('GET', Uri()));
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
    registerFallbackValue(const LaunchOptions());

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
    final mockUniLink = MockUniLinks();
    UniLinksPlatform.instance = mockUniLink;
    final stream = StreamController<String?>.broadcast();
    when(() => mockUniLink.linkStream).thenAnswer((_) => stream.stream);

    authenticator = MockApptiveGridAuthenticator();
    when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});

    apptiveGridClient = ApptiveGridClient(
      httpClient: httpClient,
      authenticator: authenticator,
    );
  });

  tearDown(() {
    apptiveGridClient.dispose();
  });

  group('loadForm', () {
    final rawResponse = {
      'fields': [
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"],
          },
          "schema": {"type": "string"},
          "id": "4zc4l48ffin5v8pa2emyx9s15",
          "name": "Text",
          "key": null,
          "_links": <String, dynamic>{},
        }
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
            'label': null,
          },
          'type': 'textfield',
          'fieldId': '4zc4l48ffin5v8pa2emyx9s15',
        },
      ],
      'name': 'Name',
      'title': 'Form',
      'id': 'formId',
      '_links': {
        "submit": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "post",
        },
        "remove": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "delete",
        },
        "self": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "get",
        },
        "update": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "put",
        },
      },
    };

    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final formData = await apptiveGridClient.loadForm(
        uri: Uri.parse('/api/a/FormId'),
      );

      expect(formData.title, equals('Form'));
      expect(formData.components?.length, equals(1));
      expect(
        formData.components![0].data.runtimeType,
        equals(StringDataEntity),
      );
      expect(formData.links[ApptiveLinkType.submit], isNotNull);
    });

    test('DirectUri checks authentication if call throws 401', () async {
      final unauthorizedResponse = Response('Error', 401);
      final response = Response(json.encode(rawResponse), 200);
      final authenticator = MockApptiveGridAuthenticator();
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async {
        // Return response on next call
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);

        // First return unauthorizedResponse
        return unauthorizedResponse;
      });
      when(() => authenticator.checkAuthentication())
          .thenAnswer((_) => Future.value());

      await client.loadForm(
        uri: Uri.parse('/api/users/user/spaces/space/grids/grid/forms/FormId'),
      );
      verify(() => authenticator.checkAuthentication()).called(1);
    });

    test('DirectUri checks authentication only once if call throws 401',
        () async {
      final unauthorizedResponse = Response('Error', 401);
      final authenticator = MockApptiveGridAuthenticator();
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async {
        return unauthorizedResponse;
      });
      when(() => authenticator.checkAuthentication())
          .thenAnswer((_) => Future.value());

      try {
        await client.loadForm(
          uri: Uri.parse(
            '/api/users/user/spaces/space/grids/grid/forms/FormId',
          ),
        );
      } catch (error) {
        expect(error, unauthorizedResponse);
      }
      verify(() => authenticator.checkAuthentication()).called(1);
    });

    test('400+ Response throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.loadForm(
          uri: Uri.parse('/api/a/FormId'),
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('Load Grid', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';

    final rawResponse = {
      'fieldNames': ['First Name', 'Last Name', 'imgUrl'],
      'entities': [
        {
          'fields': [
            'Julia',
            'Arnold',
            'https://ca.slack-edge.com/T02TE01SG-U9AJEEH7Z-19c78728dca3-512',
          ],
          '_id': '2ozv8sbju97gk1ukfbl3f3fl1',
        },
      ],
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
              {'type': 'string'},
              {'type': 'string'},
            ],
          },
          '_id': {'type': 'string'},
        },
      },
      'name': 'Contacts',
      'id': 'gridId',
      '_links': {
        "addLink": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/AddLink",
          "method": "post",
        },
        "forms": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/forms",
          "method": "get",
        },
        "updateFieldType": {
          "href":
              "/api/users/$userId/spaces/$spaceId/grids/$gridId/ColumnTypeChange",
          "method": "post",
        },
        "removeField": {
          "href":
              "/api/users/$userId/spaces/$spaceId/grids/$gridId/ColumnRemove",
          "method": "post",
        },
        "addEntity": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/entities",
          "method": "post",
        },
        "views": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/views",
          "method": "get",
        },
        "addView": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/views",
          "method": "post",
        },
        "self": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "get",
        },
        "updateFieldKey": {
          "href":
              "/api/users/$userId/spaces/$spaceId/grids/$gridId/ColumnKeyChange",
          "method": "post",
        },
        "query": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/query",
          "method": "get",
        },
        "entities": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/entities",
          "method": "get",
        },
        "updates": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/updates",
          "method": "get",
        },
        "schema": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/schema",
          "method": "get",
        },
        "updateFieldName": {
          "href":
              "/api/users/$userId/spaces/$spaceId/grids/$gridId/ColumnRename",
          "method": "post",
        },
        "addForm": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/forms",
          "method": "post",
        },
        "addField": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/ColumnAdd",
          "method": "post",
        },
        "rename": {
          "href": "/api/users/$userId/spaces/$spaceId/grids/$gridId/Rename",
          "method": "post",
        },
        "remove": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "delete",
        },
      },
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities?layout=indexed',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response(
          jsonEncode(rawResponse['entities']),
          200,
        ),
      );

      final grid = await apptiveGridClient.loadGrid(
        uri: Uri.parse('/api/users/$userId/spaces/$spaceId/grids/$gridId'),
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
          uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });
    test('401 -> Authenticates and retries', () async {
      reset(httpClient);
      const user = 'userId';
      const space = 'spaceId';
      const gridId = 'gridId';

      final response = Response('', 401);
      final retryResponse = Response(json.encode(rawResponse), 200);
      bool isRetry = false;

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        if (!isRetry) {
          isRetry = true;
          return response;
        } else {
          return retryResponse;
        }
      });
      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities?layout=indexed',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response(
          jsonEncode(rawResponse['entities']),
          200,
        ),
      );

      await apptiveGridClient.loadGrid(uri: uri);

      verify(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).called(2);
    });

    test('Do not load entities', () async {
      reset(httpClient);
      const user = 'userId';
      const space = 'spaceId';
      const gridId = 'gridId';

      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities?layout=indexed',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response(
          jsonEncode(rawResponse['entities']),
          200,
        ),
      );

      final grid = await apptiveGridClient.loadGrid(
        uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
        loadEntities: false,
      );

      expect(grid, isNot(null));
      verifyNever(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities?layout=indexed',
          ),
          headers: any(named: 'headers'),
        ),
      );
    });
  });

  group('submitForm', () {
    test('Successful', () async {
      final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
      const property = 'Checkbox';
      const id = 'id';
      final schema = {
        'type': 'object',
        'properties': {
          id: {'type': 'boolean'},
        },
        'required': [],
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

      late BaseRequest calledRequest;

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        calledRequest = realInvocation.positionalArguments[0];
        return StreamedResponse(Stream.value([]), 200);
      });

      final response = await apptiveGridClient.submitForm(action, formData);

      expect(response?.statusCode, equals(200));
      expect(calledRequest.method, equals(action.method));
      expect(
        calledRequest.url.path,
        Uri.parse('${ApptiveGridEnvironment.production.url}${action.uri}').path,
      );
      expect(
        calledRequest.headers[HttpHeaders.contentTypeHeader],
        ContentType.json,
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
        'required': [],
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
        () async => await apptiveGridClient.submitForm(action, formData),
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
          when(() => authenticator.isAuthenticated)
              .thenAnswer((_) async => true);
          when(() => authenticator.checkAuthentication())
              .thenAnswer((_) async {});
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

        test('Upload Attachment, throws Error', () {
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
                  AddAttachmentAction(byteData: bytes, attachment: attachment),
            },
          );

          expect(
            () => client.submitForm(action, formData),
            throwsException,
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
          ),
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
                },
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
          ),
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
                () async => await client.submitForm(action, formData),
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

              await client.submitForm(action, formData);

              verify(
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
              ).called(1);
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

              await expectLater(
                () async => await client.submitForm(action, formData),
                throwsA(equals(putResponse)),
              );

              verify(
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
              ).called(1);
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
              final bytes = base64Decode(
                'iVBORw0KGgoAAAANSUhEUgAAAAIAAAAECAYAAACk7+45AAAAEklEQVR42mP8z/C/ngEIGHEzAMiQCfmnp5u6AAAAAElFTkSuQmCC',
              );
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

                await client.submitForm(action, formData);

                verify(
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
                ).called(3);
                verify(
                  () => httpClient.put(
                    uploadUri,
                    headers: any(named: 'headers'),
                    body: bytes,
                    encoding: any(named: 'encoding'),
                  ),
                ).called(3);
                verify(() => httpClient.send(any())).called(1);
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
                          .queryParameters['fileName']!,
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

                await client.submitForm(action, formData);

                verify(
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
                ).called(3);
                verify(
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
                ).called(3);
                verify(() => httpClient.send(any())).called(1);
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
                          .queryParameters['fileName']!,
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
                  () => client.submitForm(action, formData),
                  throwsA(isInstanceOf<Response>()),
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
            ),
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

            await client.submitForm(action, formData);

            verify(() => httpClient.send(any())).called(1);
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

            await client.submitForm(action, formData);

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
          ),
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

            await client.submitForm(action, formData);

            final captures = verify(
              () => httpClient.get(
                captureAny(),
                headers: captureAny(named: 'headers'),
              ),
            ).captured;
            final capturedUri = captures[2] as Uri;
            final capturedHeaders = captures[3] as Map<String, String>;
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
      expect(
        ApptiveGridEnvironment.alpha.url,
        equals('https://alpha.apptivegrid.de'),
      );
      expect(
        ApptiveGridEnvironment.beta.url,
        equals('https://beta.apptivegrid.de'),
      );
      expect(
        ApptiveGridEnvironment.production.url,
        'https://app.apptivegrid.de',
      );
    });
  });

  group('Headers', () {
    test('No Authentication only content type headers', () {
      final client = ApptiveGridClient();
      expect(client.defaultHeaders, {
        HttpHeaders.contentTypeHeader: ContentType.json,
      });
    });

    test('With Authentication has headers', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.header)
          .thenReturn('Bearer dXNlcm5hbWU6cGFzc3dvcmQ=');
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );
      expect(client.defaultHeaders, {
        HttpHeaders.authorizationHeader: 'Bearer dXNlcm5hbWU6cGFzc3dvcmQ=',
        HttpHeaders.contentTypeHeader: ContentType.json,
      });
    });

    test('Add custom header', () async {
      final authenticator = MockApptiveGridAuthenticator();

      when(
        () => authenticator.checkAuthentication(),
      ).thenAnswer((invocation) async {});

      final mockEntityUri = Uri.parse(
        '/api/users/user/spaces/space/grids/grid/entities/entity',
      );

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}${mockEntityUri.toString()}?layout=property',
      );

      when(
        () => httpClient.get(
          uri,
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (invocation) async => Response(json.encode({'test': 'test'}), 200),
      );

      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );

      await client.getEntity(
        uri: mockEntityUri,
        layout: ApptiveGridLayout.property,
        headers: {'custom': 'header'},
      );

      final receivedHeaders = verify(
        () => httpClient.get(uri, headers: captureAny(named: 'headers')),
      ).captured.first as Map<String, String>;

      expect(receivedHeaders['custom'], 'header');
    });
  });

  group('Authorization', () {
    test('Authorize calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.authenticate())
          .thenAnswer((_) async => MockCredential());
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );
      client.authenticate();

      verify(() => authenticator.authenticate()).called(1);
    });

    test('Logout calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.logout()).thenAnswer((_) async => null);
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );
      client.logout();

      verify(() => authenticator.logout()).called(1);
    });

    test('isAuthenticated calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.isAuthenticated).thenAnswer((_) async => true);
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );
      client.isAuthenticated;

      verify(() => authenticator.isAuthenticated).called(1);
    });

    test('isAuthenticatedWithToken calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.isAuthenticatedWithToken)
          .thenAnswer((_) async => true);
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );
      client.isAuthenticatedWithToken;

      verify(() => authenticator.isAuthenticatedWithToken).called(1);
    });

    test('setUserToken calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.setUserToken(any())).thenAnswer((_) async => {});
      final client = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );

      final tokenTime = DateTime.now();
      final tokenResponse = {
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch,
      };
      client.setUserToken(tokenResponse);

      verify(() => authenticator.setUserToken(tokenResponse)).called(1);
    });

    group('Authentication Changed Callbacks', () {
      final httpClient = MockHttpClient();
      late MockAuthenticator authenticator;
      late MockCredential credential;
      late MockToken token;

      setUp(() {
        authenticator = MockAuthenticator();
        credential = MockCredential();
        token = MockToken();

        when(() => authenticator.authorize())
            .thenAnswer((_) async => credential);
        when(() => token.toJson()).thenReturn(<String, dynamic>{});
        when(() => credential.getTokenResponse(any()))
            .thenAnswer((invocation) async => token);
        when(() => credential.toJson()).thenAnswer(
          (_) {
            final tokenResponse = TokenResponse.fromJson({
              'state': 'state',
              'token_type': 'Bearer',
              'access_token': '12345',
            });
            return {
              'state': 'state',
              'issuer': zweidenkerIssuer.metadata.toJson(),
              'client_id': 'web',
              'client_secret': '',
              'token': tokenResponse.toJson(),
            };
          },
        );

        final secureStorage = MockSecureStorage();
        FlutterSecureStoragePlatform.instance = secureStorage;
        when(
          () => secureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => secureStorage.read(
            key: any(named: 'key'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => jsonEncode(credential.toJson()));

        final tokenTime = DateTime.now();
        final tokenResponse = TokenResponse.fromJson({
          'token_type': 'Bearer',
          'access_token': '12345',
          'expires_at': tokenTime.millisecondsSinceEpoch,
          'expires_in': tokenTime.microsecondsSinceEpoch,
        });

        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer(
          (invocation) async => Response(
            jsonEncode(tokenResponse.toJson()),
            200,
            request: Request('POST', invocation.positionalArguments[0]),
            headers: {HttpHeaders.contentTypeHeader: ContentType.json},
          ),
        );
      });

      test('Saved token, gets token and notifies client', () async {
        int notifierCount = 0;
        final client = ApptiveGridClient(
          httpClient: httpClient,
          options: const ApptiveGridOptions(
            authenticationOptions: ApptiveGridAuthenticationOptions(
              persistCredentials: true,
            ),
          ),
        );
        client.authenticator.testAuthenticator = authenticator;

        client.addListener(() {
          notifierCount++;
        });

        final isAuthenticatedWithToken = await client.isAuthenticatedWithToken;

        expect(isAuthenticatedWithToken, true);
        expect(notifierCount, 1);
      });

      test('Authenticate, notifies client', () async {
        int notifierCount = 0;
        final client = ApptiveGridClient(
          httpClient: httpClient,
        );
        client.authenticator.testAuthenticator = authenticator;

        client.addListener(() {
          notifierCount++;
        });

        await client.authenticate();

        expect(notifierCount, 1);
      });

      test('Logout, notifies client', () async {
        int notifierCount = 0;
        final client = ApptiveGridClient(
          httpClient: httpClient,
        );
        client.authenticator.testAuthenticator = authenticator;

        client.addListener(() {
          notifierCount++;
        });

        await client.authenticate();

        expect(notifierCount, 1);
        notifierCount = 0;

        await client.logout();
        expect(notifierCount, 1);
      });
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
      ],
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
    final spaceUri = Uri.parse('api/users/$userId/spaces/$spaceId');
    final rawResponse = {
      'id': spaceId,
      'name': 'TestSpace',
      'gridUris': [
        '/api/users/id/spaces/spaceId/grids/gridId',
      ],
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

      final space = await apptiveGridClient.getSpace(uri: spaceUri);

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
        () => apptiveGridClient.getSpace(uri: spaceUri),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('Caching Form Actions', () {
    final httpClient = MockHttpClient();

    final cache = MockApptiveGridCache();

    final options = ApptiveGridOptions(cache: cache);

    late ApptiveGridClient client;

    final action = ApptiveLink(uri: Uri.parse('/actionUri'), method: 'POST');
    final action1 = ApptiveLink(uri: Uri.parse('/actionUri1'), method: 'POST');

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
      client = ApptiveGridClient(httpClient: httpClient, options: options);
    });

    test('Fail, gets send from pending', () async {
      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      await expectLater(
        (await client.submitForm(action, data))?.statusCode,
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
        (await client.submitForm(action, data))?.statusCode,
        400,
      );

      verify(() => cache.addPendingActionItem(any())).called(1);
    });

    test('Resubmit fails does not crash', () async {
      final actionItem = ActionItem(link: action, data: data);
      cacheMap[actionItem.toString()] = actionItem.toJson();

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      await client.sendPendingActions();

      verifyNever(() => cache.removePendingActionItem(any()));
      verifyNever(() => cache.addPendingActionItem(any()));
    });

    test('Resubmit returns successful action', () async {
      final actionItem = ActionItem(link: action, data: data);
      cacheMap[actionItem.toString()] = actionItem.toJson();

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 200);
      });

      final offlineActions = await client.sendPendingActions();

      expect(offlineActions, equals([actionItem]));
    });

    test('Resubmit fails returns empty list', () async {
      final actionItem = ActionItem(link: action, data: data);
      cacheMap[actionItem.toString()] = actionItem.toJson();

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      final offlineActions = await client.sendPendingActions();

      expect(offlineActions, equals([]));
    });

    test('Resubmit returns only successful actions', () async {
      final actionItem = ActionItem(link: action, data: data);
      cacheMap[actionItem.toString()] = actionItem.toJson();
      final actionItem1 = ActionItem(link: action1, data: data);
      cacheMap[actionItem1.toString()] = actionItem1.toJson();

      when(() => httpClient.send(any())).thenAnswer((invocation) async {
        final uri = (invocation.positionalArguments.first as BaseRequest).url;
        if (uri.path == action.uri.path) {
          return StreamedResponse(Stream.value([]), 400);
        } else {
          return StreamedResponse(Stream.value([]), 200);
        }
      });

      final offlineActions = await client.sendPendingActions();

      expect(offlineActions, equals([actionItem1]));
    });
  });

  group('EditLink', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';
    const entityId = 'entityId';
    const form = 'form';
    final entityUri = Uri.parse(
      '/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId',
    );
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
        uri: entityUri.replace(
          pathSegments: [
            ...entityUri.pathSegments,
            'EditLink',
          ],
        ),
        formId: form,
      );

      expect(formUri, equals(Uri(path: '/api/a/$form')));
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
        () => apptiveGridClient.getEditLink(
          uri: entityUri.replace(
            pathSegments: [
              ...entityUri.pathSegments,
              'EditLink',
            ],
          ),
          formId: form,
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });
  });

  group('Get Entity', () {
    const userId = 'userId';
    const spaceId = 'spaceId';
    const gridId = 'gridId';
    const entityId = 'entityId';
    final entityUri = Uri.parse(
      '/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId',
    );
    final rawResponse = {
      '4um33znbt8l6x0vzvo0mperwj': null,
      '_id': 'entityId',
      '5kmhd05jzdd48jaxbds8yn3js': 'Test',
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId?layout=field',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final entity = await apptiveGridClient.getEntity(uri: entityUri);

      expect(entity, equals(rawResponse));
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId?layout=field',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => apptiveGridClient.getEntity(uri: entityUri),
        throwsA(isInstanceOf<Response>()),
      );
    });

    test('Adjust Layout', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId?layout=key',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final entity = await apptiveGridClient.getEntity(
        uri: entityUri,
        layout: ApptiveGridLayout.key,
      );

      expect(entity, equals(rawResponse));
    });

    test('Use ApptiveGridHalVersion', () async {
      final response = Response(json.encode(rawResponse), 200);
      const version = ApptiveGridHalVersion.v1;
      when(
        () => httpClient.get(
          Uri.parse(
            '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId?layout=field',
          ),
          headers: any(
            named: 'headers',
            that: predicate<Map<String, String>>(
              (headers) => headers[version.header.key] == version.header.value,
            ),
          ),
        ),
      ).thenAnswer((_) async => response);

      final entity = await apptiveGridClient.getEntity(
        uri: entityUri,
        halVersion: version,
      );

      expect(entity, equals(rawResponse));
    });
  });

  group('Switch Stage', () {
    late Client httpClient;
    late ApptiveGridClient client;
    late ApptiveGridOptions initialOptions;

    setUp(() {
      httpClient = MockHttpClient();
      initialOptions =
          const ApptiveGridOptions(environment: ApptiveGridEnvironment.alpha);
      client = ApptiveGridClient(
        httpClient: httpClient,
        options: initialOptions,
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
      expect(client.options.environment, equals(ApptiveGridEnvironment.alpha));

      await client.updateEnvironment(ApptiveGridEnvironment.production);

      expect(
        client.options.environment,
        equals(ApptiveGridEnvironment.production),
      );
    });

    test('switch authenticator environment', () async {
      expect(
        client.authenticator.client.options.environment,
        equals(ApptiveGridEnvironment.alpha),
      );

      await client.updateEnvironment(ApptiveGridEnvironment.production);

      expect(
        client.authenticator.client.options.environment,
        ApptiveGridEnvironment.production,
      );
    });
  });

  group('Profile Picture', () {
    late Client httpClient;

    final user = User(
      email: 'email',
      lastName: 'lastName',
      firstName: 'firstName',
      id: 'userId',
      links: {},
      embeddedSpaces: [],
    );

    group('Errors', () {
      test('Getting upload Url fails, throws response', () async {
        httpClient = MockHttpClient();
        apptiveGridClient = ApptiveGridClient(httpClient: httpClient);
        final response = Response('Error Response', 400);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((invocation) async {
          if ((invocation.positionalArguments.first as Uri)
              .path
              .endsWith('users/me')) {
            return Response(jsonEncode(user.toJson()), 200);
          } else {
            return response;
          }
        });

        expect(
          () => apptiveGridClient.uploadProfilePicture(
            bytes: Uint8List(0),
          ),
          throwsA(equals(response)),
        );
      });

      test('Putting content fails, throws response', () async {
        httpClient = MockHttpClient();
        apptiveGridClient = ApptiveGridClient(httpClient: httpClient);
        final uploadUrlResponse = Response('{"uploadURL": "uploadUrl"}', 200);
        final errorResponse = Response('Error Response', 400);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((invocation) async {
          if ((invocation.positionalArguments.first as Uri)
              .path
              .endsWith('users/me')) {
            return Response(jsonEncode(user.toJson()), 200);
          } else {
            return uploadUrlResponse;
          }
        });

        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => errorResponse);

        expect(
          () => apptiveGridClient.uploadProfilePicture(
            bytes: Uint8List(0),
          ),
          throwsA(equals(errorResponse)),
        );
      });
    });

    test('Uploads bytes to retrieved url', () async {
      httpClient = MockHttpClient();
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.header).thenReturn('Bearer authToken');
      when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});
      apptiveGridClient = ApptiveGridClient(
        httpClient: httpClient,
        authenticator: authenticator,
      );

      final uploadUrlResponse = Response('{"uploadURL": "uploadUrl"}', 200);
      final putResponse = Response('Uploaded Response', 200);
      final bytes = Uint8List(10);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((invocation) async {
        if ((invocation.positionalArguments.first as Uri)
            .path
            .endsWith('users/me')) {
          return Response(jsonEncode(user.toJson()), 200);
        } else {
          return uploadUrlResponse;
        }
      });

      when(
        () => httpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => putResponse);

      final response =
          await apptiveGridClient.uploadProfilePicture(bytes: bytes);

      expect(response, equals(putResponse));

      verify(
        () => httpClient.get(
          Uri.parse(
            'https://6csgir6rcj.execute-api.eu-central-1.amazonaws.com/uploads',
          ).replace(
            queryParameters: {
              'fileName': user.id,
              'fileType': 'image/jpeg',
            },
          ),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      ).called(1);

      verify(
        () => httpClient.put(
          Uri.parse('uploadUrl'),
          headers: {
            HttpHeaders.contentTypeHeader: 'image/jpeg',
          },
          body: bytes,
        ),
      ).called(1);
    });
  });

  group('Load Entities', () {
    test('401 -> Authenticates and retries', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response('', 401);
      final retryResponse = Response(
        '[]',
        200,
      );
      bool isRetry = false;

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        if (!isRetry) {
          isRetry = true;
          return response;
        } else {
          return retryResponse;
        }
      });

      await apptiveGridClient.loadEntities(uri: uri);

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) =>
                  testUri.path == uri.path &&
                  testUri.queryParameters['layout'] ==
                      ApptiveGridLayout.field.queryParameter,
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(2);
    });

    test('Uses layout', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(
        '[]',
        200,
      );
      const layout = ApptiveGridLayout.keyAndField;

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        return response;
      });

      await apptiveGridClient.loadEntities(uri: uri, layout: layout);

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) =>
                  testUri.path == uri.path &&
                  testUri.queryParameters['layout'] == layout.queryParameter,
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('Filter and Sorting', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(
        '[]',
        200,
      );
      final filter =
          EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
      const sorting =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc);

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        return response;
      });

      await apptiveGridClient.loadEntities(
        uri: uri,
        sorting: [sorting],
        filter: filter,
      );

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) =>
                  testUri.path == uri.path &&
                  testUri.queryParameters.containsKey('filter') &&
                  testUri.queryParameters.containsKey('sorting'),
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });
    test('Load page data', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(
        '{'
        '"items": ["item"],'
        '"page": 1,'
        '"numberOfItems": 2,'
        '"numberOfPages": 2,'
        '"size": 50'
        '}',
        200,
      );

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async => response);

      final entities = await apptiveGridClient.loadEntities(
        uri: uri,
        pageSize: 50,
      );

      expect(
        entities,
        equals(
          const EntitiesResponse(
            items: ["item"],
            pageMetaData: PageMetaData(
              numberOfItems: 2,
              numberOfPages: 2,
              page: 1,
              size: 50,
            ),
          ),
        ),
      );

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) =>
                  testUri.path == uri.path &&
                  testUri.queryParameters['pageSize'] == '50',
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });
    test('Load specific page data', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(
        '{'
        '"items": ["item"],'
        '"page": 2,'
        '"numberOfItems": 2,'
        '"numberOfPages": 2,'
        '"size": 50'
        '}',
        200,
      );

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async => response);

      final entities = await apptiveGridClient.loadEntities(
        uri: uri,
        pageIndex: 2,
        pageSize: 50,
      );

      expect(
        entities,
        equals(
          const EntitiesResponse(
            items: ["item"],
            pageMetaData: PageMetaData(
              numberOfItems: 2,
              numberOfPages: 2,
              page: 2,
              size: 50,
            ),
          ),
        ),
      );

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) =>
                  testUri.path == uri.path &&
                  testUri.queryParameters['pageIndex'] == '2' &&
                  testUri.queryParameters['pageSize'] == '50',
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('Uses Hal Version', () async {
      reset(httpClient);
      const user = 'user';
      const space = 'space';
      const gridId = 'grid';

      final response = Response(
        '[]',
        200,
      );
      const version = ApptiveGridHalVersion.v2;

      final uri = Uri.parse(
        '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId/entities',
      );
      when(
        () => httpClient.get(
          any(that: predicate<Uri>((testUri) => testUri.path == uri.path)),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        return response;
      });

      await apptiveGridClient.loadEntities(uri: uri, halVersion: version);

      verify(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (testUri) => testUri.path == uri.path,
            ),
          ),
          headers: any(
            named: 'headers',
            that: predicate<Map<String, String>>(
              (headers) => headers[version.header.key] == version.header.value,
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('Perform ApptiveLink', () {
    const actionResponse = 'Action Response';

    test('Success', () async {
      final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'get');

      final response =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 200);
      final linkCompleter = Completer();

      when(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method,
            ),
          ),
        ),
      ).thenAnswer((realInvocation) async {
        return response;
      });

      await apptiveGridClient.performApptiveLink(
        link: link,
        parseResponse: (response) async =>
            linkCompleter.complete(response.body),
      );

      expect(await linkCompleter.future, equals(actionResponse));
    });

    test('Uses Hal Version', () async {
      final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'get');

      final response =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 200);
      final linkCompleter = Completer();

      const version = ApptiveGridHalVersion.v2;

      when(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method &&
                  request.headers[version.header.key] == version.header.value,
            ),
          ),
        ),
      ).thenAnswer((realInvocation) async {
        return response;
      });

      await apptiveGridClient.performApptiveLink(
        link: link,
        halVersion: version,
        parseResponse: (response) async =>
            linkCompleter.complete(response.body),
      );

      expect(await linkCompleter.future, equals(actionResponse));
    });

    test('400 Status throws Response', () async {
      final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'get');

      final response =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 400);
      final linkCompleter = Completer();

      when(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method,
            ),
          ),
        ),
      ).thenAnswer((_) async => response);
      expect(
        () => apptiveGridClient.performApptiveLink(
          link: link,
          parseResponse: (response) async => linkCompleter.complete(response),
        ),
        throwsA(isInstanceOf<Response>()),
      );
    });

    test('401 -> Authenticates and retries', () async {
      reset(httpClient);
      final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'get');

      bool isRetry = false;

      final response =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 401);
      final retryResponse =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 200);
      final linkCompleter = Completer();

      when(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method,
            ),
          ),
        ),
      ).thenAnswer((_) async {
        if (!isRetry) {
          isRetry = true;
          return response;
        } else {
          return retryResponse;
        }
      });

      await apptiveGridClient.performApptiveLink(
        link: link,
        parseResponse: (response) async => linkCompleter.complete(response),
      );

      verify(() => authenticator.checkAuthentication()).called(1);
      verify(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method,
            ),
          ),
        ),
      ).called(2);
    });

    test('Headers, Body, Query get applied', () async {
      final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'post');

      const body = 'testBody';
      final headers = {'TestHeader': 'Value'};
      final queryParameters = {'QueryParameter': 'Value'};

      final response =
          StreamedResponse(Stream.value(utf8.encode(actionResponse)), 200);
      final linkCompleter = Completer();

      when(
        () => httpClient.send(
          any(
            that: predicate<BaseRequest>(
              (request) =>
                  request.url.scheme == 'https' &&
                  request.url.host.endsWith('apptivegrid.de') &&
                  request.url.path == link.uri.path &&
                  request.method == link.method,
            ),
          ),
        ),
      ).thenAnswer((realInvocation) async {
        return response;
      });

      await apptiveGridClient.performApptiveLink(
        link: link,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        parseResponse: (response) async =>
            linkCompleter.complete(response.body),
      );

      verify(
        () => httpClient.send(
          any(
            that: predicate<Request>((request) {
              return mapEquals(request.url.queryParameters, queryParameters) &&
                  request.headers[headers.keys.first] == headers.values.first &&
                  request.body == jsonEncode(body);
            }),
          ),
        ),
      ).called(1);
    });
  });

  group('HttpClient', () {
    test('Returns provided Client', () {
      final client = ApptiveGridClient(httpClient: httpClient);

      expect(client.httpClient, httpClient);
    });
  });
}
