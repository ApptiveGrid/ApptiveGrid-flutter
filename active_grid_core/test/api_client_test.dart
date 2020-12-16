import 'dart:convert';

import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  final httpClient = MockHttpClient();
  ActiveGridClient activeGridClient;

  setUp(() {
    activeGridClient = ActiveGridClient.fromClient(httpClient);
  });

  tearDown(() {
    activeGridClient.dispose();
    activeGridClient = null;
  });

  group('loadForm', () {
    test('Success', () async {
      final rawResponse = {
        'schema': {
          'type': 'object',
          'properties': {
            'TextC': {'type': 'string'},
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
            'type': 'textfield'
          },
        ],
        'title': 'Form'
      };

      final response = Response(json.encode(rawResponse), 200);

      when(httpClient.get(any)).thenAnswer((_) async => response);

      final formData = await activeGridClient.loadForm(formId: 'FormId');

      expect(formData.title, 'Form');
      expect(formData.components.length, 1);
      expect(formData.components[0].runtimeType, FormComponentText);
      expect(formData.actions.length, 1);
    });
  });

  group('performAction', () {
    test('Successful', () async {
      final action = FormAction('/uri', 'POST');
      final property = 'Checkbox';
      final component = FormComponentCheckBox(
          property: property,
          value: true,
          options: StubComponentOptions.fromJson({}),
          required: false,
          type: FormType.checkbox);
      final schema = {
        'type': 'object',
        'properties': {
          property: {'type': 'boolean'},
        },
        'required': []
      };
      final formData = FormData('Title', [component], [action], schema);

      final request = Request(
          'POST', Uri.parse('${ActiveGridEnvironment.production.url}/uri}'));
      request.body = jsonEncode(jsonEncode(formData.toRequestObject()));

      BaseRequest calledRequest;

      when(httpClient.send(any)).thenAnswer((realInvocation) async {
        calledRequest = realInvocation.positionalArguments[0];
        return StreamedResponse(Stream.value([]), 200);
      });

      await activeGridClient.performAction(action, formData);

      expect(calledRequest.method, action.method);
      expect(calledRequest.url.toString(),
          '${ActiveGridEnvironment.production.url}${action.uri}');
    });
  });

  group('Environment', () {
    test('Check Urls', () {
      expect(ActiveGridEnvironment.alpha.url, 'https://alpha.activegrid.de');
      expect(ActiveGridEnvironment.beta.url, 'https://beta.activegrid.de');
      expect(ActiveGridEnvironment.production.url, 'https://activegrid.de');
    });
  });
}