import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    registerFallbackValue<BaseRequest>(Request('GET', Uri()));
    registerFallbackValue<Uri>(Uri());
    registerFallbackValue<Map<String, String>>(<String, String>{});

    registerFallbackValue(ActionItem(
        action: FormAction('uri', 'method'),
        data: FormData('title', [], [], {})));
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
      'title': 'Form'
    };

    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final formData = await apptiveGridClient.loadForm(
          formUri: RedirectFormUri(form: 'FormId'));

      expect(formData.title, 'Form');
      expect(formData.components.length, 1);
      expect(formData.components[0].runtimeType, StringFormComponent);
      expect(formData.actions.length, 1);
    });

    test('DirectUri checks authentication', () async {
      final response = Response(json.encode(rawResponse), 200);
      final authenticator = MockApptiveGridAuthenticator();
      final client = ApptiveGridClient.fromClient(httpClient,
          authenticator: authenticator);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);
      when(() => authenticator.checkAuthentication())
          .thenAnswer((_) => Future.value());

      unawaited(client.loadForm(
          formUri: DirectFormUri(
              user: 'user', space: 'space', grid: 'grid', form: 'FormId')));
      verify(() => authenticator.checkAuthentication()).called(1);
    });

    test('400+ Response throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      expect(
          () => apptiveGridClient.loadForm(
              formUri: RedirectFormUri(form: 'FormId')),
          throwsA(isInstanceOf<Response>()));
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
      final user = 'user';
      final space = 'space';
      final gridId = 'grid';

      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final grid = await apptiveGridClient.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId));

      expect(grid, isNot(null));
    });

    test('400 Status throws Response', () async {
      final user = 'user';
      final space = 'space';
      final gridId = 'grid';

      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(
          () => apptiveGridClient.loadGrid(
              gridUri: GridUri(user: user, space: space, grid: gridId)),
          throwsA(isInstanceOf<Response>()));
    });
  });

  group('performAction', () {
    test('Successful', () async {
      final action = FormAction('/uri', 'POST');
      final property = 'Checkbox';
      final id = 'id';
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
      final formData = FormData('Title', [component], [action], schema);

      final request = Request(
          'POST', Uri.parse('${ApptiveGridEnvironment.production.url}/uri}'));
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      late BaseRequest calledRequest;

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        calledRequest = realInvocation.positionalArguments[0];
        return StreamedResponse(Stream.value([]), 200);
      });

      final response = await apptiveGridClient.performAction(action, formData);

      expect(response.statusCode, 200);
      expect(calledRequest.method, action.method);
      expect(calledRequest.url.toString(),
          '${ApptiveGridEnvironment.production.url}${action.uri}');
      expect(calledRequest.headers[HttpHeaders.contentTypeHeader],
          ContentType.json);
    });
  });

  group('Environment', () {
    test('Check Urls', () {
      expect(ApptiveGridEnvironment.alpha.url, 'https://alpha.apptivegrid.de');
      expect(ApptiveGridEnvironment.beta.url, 'https://beta.apptivegrid.de');
      expect(
          ApptiveGridEnvironment.production.url, 'https://app.apptivegrid.de');
    });

    test('Check Auth Realm', () {
      expect(ApptiveGridEnvironment.alpha.authRealm, 'apptivegrid-test');
      expect(ApptiveGridEnvironment.beta.authRealm, 'apptivegrid-test');
      expect(ApptiveGridEnvironment.production.authRealm, 'apptivegrid');
    });
  });

  group('Headers', () {
    test('No Authentication empty headers', () {
      final client = ApptiveGridClient();
      expect(client.headers, {});
    });

    test('With Authentication has headers', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.header)
          .thenReturn('Bearer dXNlcm5hbWU6cGFzc3dvcmQ=');
      final client = ApptiveGridClient.fromClient(httpClient,
          authenticator: authenticator);
      expect(client.headers,
          {HttpHeaders.authorizationHeader: 'Bearer dXNlcm5hbWU6cGFzc3dvcmQ='});
    });
  });

  group('Authorization', () {
    test('Authorize calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.authenticate())
          .thenAnswer((_) async => MockCredential());
      final client = ApptiveGridClient.fromClient(httpClient,
          authenticator: authenticator);
      client.authenticate();

      verify(() => authenticator.authenticate()).called(1);
    });

    test('Logout calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.logout()).thenAnswer((_) async {});
      final client = ApptiveGridClient.fromClient(httpClient,
          authenticator: authenticator);
      client.logout();

      verify(() => authenticator.logout()).called(1);
    });

    test('isAuthenticated calls Authenticator', () {
      final authenticator = MockApptiveGridAuthenticator();
      when(() => authenticator.isAuthenticated).thenAnswer((_) => true);
      final client = ApptiveGridClient.fromClient(httpClient,
          authenticator: authenticator);
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

      when(() => httpClient.get(
          Uri.parse('${ApptiveGridEnvironment.production.url}/api/users/me'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final user = await apptiveGridClient.getMe();

      expect(user, isNot(null));
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(
          Uri.parse('${ApptiveGridEnvironment.production.url}/api/users/me'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(
          () => apptiveGridClient.getMe(), throwsA(isInstanceOf<Response>()));
    });
  });

  group('get Space', () {
    final userId = 'userId';
    final spaceId = 'spaceId';
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

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final space = await apptiveGridClient.getSpace(spaceUri: spaceUri);

      expect(space, isNot(null));
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(() => apptiveGridClient.getSpace(spaceUri: spaceUri),
          throwsA(isInstanceOf<Response>()));
    });
  });

  group('get Forms', () {
    final userId = 'userId';
    final spaceId = 'spaceId';
    final gridId = 'gridId';
    final form0 = 'formId0';
    final form1 = 'formId1';
    final gridUri = GridUri(user: userId, space: spaceId, grid: gridId);
    final rawResponse = [
      '/api/users/id/spaces/spaceId/grids/gridId/forms/$form0',
      '/api/users/id/spaces/spaceId/grids/gridId/forms/$form1',
    ];
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/forms'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final forms = await apptiveGridClient.getForms(gridUri: gridUri);

      expect(forms.length, 2);
      expect(forms[0].uriString,
          '/api/users/id/spaces/spaceId/grids/gridId/forms/$form0');
      expect(forms[1].uriString,
          '/api/users/id/spaces/spaceId/grids/gridId/forms/$form1');
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/forms'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(() => apptiveGridClient.getForms(gridUri: gridUri),
          throwsA(isInstanceOf<Response>()));
    });
  });

  group('GridViews', () {
    final userId = 'userId';
    final spaceId = 'spaceId';
    final gridId = 'gridId';
    final view0 = 'viewId0';
    final view1 = 'viewId1';
    final gridUri = GridUri(user: userId, space: spaceId, grid: gridId);
    final rawResponse = [
      '/api/users/id/spaces/spaceId/grids/gridId/views/$view0',
      '/api/users/id/spaces/spaceId/grids/gridId/views/$view1',
    ];
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/views'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final views = await apptiveGridClient.getGridViews(gridUri: gridUri);

      expect(views.length, 2);
      expect(views[0].uriString,
          '/api/users/id/spaces/spaceId/grids/gridId/views/$view0');
      expect(views[1].uriString,
          '/api/users/id/spaces/spaceId/grids/gridId/views/$view1');
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/views'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(() => apptiveGridClient.getGridViews(gridUri: gridUri),
          throwsA(isInstanceOf<Response>()));
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

      when(() => httpClient.get(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/views/$view0'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final gridView = await apptiveGridClient.loadGrid(
          gridUri: GridViewUri(
              user: userId, space: spaceId, grid: gridId, view: view0));

      expect(gridView.filter != null, true);
      expect(gridView.fields.length, 3);
      expect(gridView.rows.length, 1);
    });
  });

  group('Caching Form Actions', () {
    final httpClient = MockHttpClient();

    final cache = MockApptiveGridCache();

    final options = ApptiveGridOptions(cache: cache);

    late ApptiveGridClient client;

    final action = FormAction('actionUri', 'POST');

    final data = FormData('title', [], [], {});

    final cacheMap = <String, dynamic>{};

    setUp(() {
      when(() => cache.addPendingActionItem(any())).thenAnswer((invocation) =>
          cacheMap[invocation.positionalArguments[0].toString()] =
              (invocation.positionalArguments[0] as ActionItem).toJson());
      when(() => cache.removePendingActionItem(any())).thenAnswer(
          (invocation) => cacheMap
              .remove(cacheMap[invocation.positionalArguments[0].toString()]));
      when(() => cache.getPendingActionItems()).thenAnswer((invocation) =>
          cacheMap.values.map((e) => ActionItem.fromJson(e)).toList());
      cacheMap.clear();
      client = ApptiveGridClient.fromClient(httpClient, options: options);
    });

    test('Fail, gets send from pending', () async {
      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 400);
      });

      await expectLater(
          (await client.performAction(action, data)).statusCode, 400);

      verify(() => cache.addPendingActionItem(any())).called(1);

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        return StreamedResponse(Stream.value([]), 200);
      });

      await client.sendPendingActions();

      verify(() => cache.removePendingActionItem(any())).called(1);
    });

    test('Sending Throws Exception, Saves Action', () async {
      when(() => httpClient.send(any()))
          .thenThrow(SocketException('Socket Exception'));

      await expectLater(
          (await client.performAction(action, data)).statusCode, 400);

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
    final userId = 'userId';
    final spaceId = 'spaceId';
    final gridId = 'gridId';
    final entityId = 'entityId';
    final form = 'form';
    final entityUri =
        EntityUri(user: userId, space: spaceId, grid: gridId, entity: entityId);
    final rawResponse = {
      'uri': '/api/r/$form',
    };
    test('Success', () async {
      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.post(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId/EditLink'),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenAnswer((_) async => response);

      final formUri = await apptiveGridClient.getEditLink(
          entityUri: entityUri, formId: form);

      expect(formUri.runtimeType, RedirectFormUri);
      expect(formUri.uriString, '/api/a/$form');
    });

    test('400 Status throws Response', () async {
      final response = Response(json.encode(rawResponse), 400);

      when(() => httpClient.post(
          Uri.parse(
              '${ApptiveGridEnvironment.production.url}/api/users/$userId/spaces/$spaceId/grids/$gridId/entities/$entityId/EditLink'),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenAnswer((_) async => response);

      expect(
          () =>
              apptiveGridClient.getEditLink(entityUri: entityUri, formId: form),
          throwsA(isInstanceOf<Response>()));
    });
  });
}
