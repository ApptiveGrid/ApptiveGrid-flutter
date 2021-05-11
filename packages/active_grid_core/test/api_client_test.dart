import 'dart:convert';
import 'dart:io';

import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  final httpClient = MockHttpClient();
  late ActiveGridClient activeGridClient;

  setUpAll(() {
    registerFallbackValue<BaseRequest>(Request('GET', Uri()));
    registerFallbackValue<Uri>(Uri());
    registerFallbackValue<Map<String, String>>(<String, String>{});
  });

  setUp(() {
    activeGridClient = ActiveGridClient.fromClient(httpClient);
  });

  tearDown(() {
    activeGridClient.dispose();
  });

  group('loadForm', () {
    test('Success', () async {
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

      final response = Response(json.encode(rawResponse), 200);

      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final formData = await activeGridClient.loadForm(formId: 'FormId');

      expect(formData.title, 'Form');
      expect(formData.components.length, 1);
      expect(formData.components[0].runtimeType, StringFormComponent);
      expect(formData.actions.length, 1);
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
              '${ActiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      final grid = await activeGridClient.loadGrid(
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
              '${ActiveGridEnvironment.production.url}/api/users/$user/spaces/$space/grids/$gridId'),
          headers: any(named: 'headers'))).thenAnswer((_) async => response);

      expect(
          () =>
              activeGridClient.loadGrid(gridUri: GridUri(user: user, space: space, grid: gridId)),
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
          'POST', Uri.parse('${ActiveGridEnvironment.production.url}/uri}'));
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      late BaseRequest calledRequest;

      when(() => httpClient.send(any())).thenAnswer((realInvocation) async {
        calledRequest = realInvocation.positionalArguments[0];
        return StreamedResponse(Stream.value([]), 200);
      });

      await activeGridClient.performAction(action, formData);

      expect(calledRequest.method, action.method);
      expect(calledRequest.url.toString(),
          '${ActiveGridEnvironment.production.url}${action.uri}');
      expect(calledRequest.headers[HttpHeaders.contentTypeHeader],
          ContentType.json);
    });
  });

  group('Environment', () {
    test('Check Urls', () {
      expect(ActiveGridEnvironment.alpha.url, 'https://alpha.activegrid.de');
      expect(ActiveGridEnvironment.beta.url, 'https://beta.activegrid.de');
      expect(ActiveGridEnvironment.production.url, 'https://app.activegrid.de');
    });

    test('Check Auth Realm', () {
      expect(ActiveGridEnvironment.alpha.authRealm, 'activegrid-test');
      expect(ActiveGridEnvironment.beta.authRealm, 'activegrid-test');
      expect(ActiveGridEnvironment.production.authRealm, 'activegrid');
    });
  });

  group('Headers', () {
    test('No Authentication empty headers', () {
      final client = ActiveGridClient();
      expect(client.headers, {});
    });

    test('With Authentication has headers', () {
      final authenticator = MockActiveGridAuthenticator();
      when(() => authenticator.header)
          .thenReturn('Bearer dXNlcm5hbWU6cGFzc3dvcmQ=');
      final client =
          ActiveGridClient.fromClient(httpClient, authenticator: authenticator);
      expect(client.headers,
          {HttpHeaders.authorizationHeader: 'Bearer dXNlcm5hbWU6cGFzc3dvcmQ='});
    });
  });

  group('Authorization', () {
    test('Authorize calls Authenticator', () {
      final authenticator = MockActiveGridAuthenticator();
      when(() => authenticator.authenticate())
          .thenAnswer((_) async => MockCredential());
      final client =
          ActiveGridClient.fromClient(httpClient, authenticator: authenticator);
      client.authenticate();

      verify(() => authenticator.authenticate()).called(1);
    });
  });
}
