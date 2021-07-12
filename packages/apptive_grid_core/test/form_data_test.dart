import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final title = 'title';
  final response = {
    'schema': {
      'type': 'object',
      'properties': {
        '4zc4l4c5coyi7qh6q1ozrg54u': {'type': 'string', 'format': 'date-time'},
        '4zc4l456pca5ursrt9rxefpsc': {'type': 'boolean'},
        '4zc4l49to77dhfagr844flaey': {'type': 'string', 'format': 'date'},
        '4zc4l45nmww7ujq7y4axlbtjg': {'type': 'string'},
        '4zc4l48ffin5v8pa2emyx9s15': {'type': 'integer'}
      },
      'required': []
    },
    'actions': [
      {'uri': '/api/a/95fzpo7jg09dthz394nkdf21g', 'method': 'POST'}
    ],
    'components': [
      {
        'property': 'TextC',
        'value': null,
        'required': false,
        'options': {
          'multi': false,
          'placeholder': '',
          'description': 'Text Description',
          'label': null
        },
        'fieldId': '4zc4l45nmww7ujq7y4axlbtjg',
        'type': 'textfield'
      },
      {
        'property': 'NumberC',
        'value': null,
        'required': false,
        'options': {
          'multi': false,
          'placeholder': '',
          'description': 'Number description',
          'label': 'Number Label'
        },
        'fieldId': '4zc4l48ffin5v8pa2emyx9s15',
        'type': 'textfield'
      },
      {
        'property': 'DateTimeC',
        'value': null,
        'required': false,
        'options': {
          'label': 'DateTime Label',
          'description': 'DateTime Description'
        },
        'fieldId': '4zc4l4c5coyi7qh6q1ozrg54u',
        'type': 'datePicker'
      },
      {
        'property': 'DateC',
        'value': null,
        'required': false,
        'options': {'label': 'Date Label', 'description': 'Date Description'},
        'fieldId': '4zc4l49to77dhfagr844flaey',
        'type': 'datePicker'
      },
      {
        'property': 'CheckmarkC',
        'value': null,
        'required': false,
        'options': {
          'label': 'Checkbox Label',
          'description': 'Checkbox Description'
        },
        'fieldId': '4zc4l456pca5ursrt9rxefpsc',
        'type': 'checkbox'
      }
    ],
    'title': title
  };

  group('Parsing', () {
    test('Successful', () {
      final formData = FormData.fromJson(response);

      expect(formData.title, title);

      expect(formData.actions.length, 1);

      expect(formData.components.length, 5);

      expect(formData.components.map((e) => e.runtimeType).toList(), [
        StringFormComponent,
        IntegerFormComponent,
        DateTimeFormComponent,
        DateFormComponent,
        BooleanFormComponent,
      ]);
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      final action = FormAction('/uri', 'POST');
      final schema = response['schema'];
      final component = IntegerFormComponent(
          fieldId: '4zc4l48ffin5v8pa2emyx9s15',
          options: TextComponentOptions(),
          property: 'NumberC',
          data: IntegerDataEntity());

      final formData = FormData(title, [component], [action], schema);

      expect(FormData.fromJson(formData.toJson()), formData);
    });
  });

  group('Equality', () {
    final action = FormAction('/uri', 'POST');
    final schema = response['schema'];
    final component = IntegerFormComponent(
        fieldId: '4zc4l48ffin5v8pa2emyx9s15',
        data: IntegerDataEntity(),
        options: TextComponentOptions(),
        property: 'NumberC');

    final a = FormData(title, [component], [action], schema);
    final b = FormData(title, [component], [action], schema);
    final c = FormData.fromJson(response);

    test('a == b', () {
      expect(a == b, true);
      expect(a.hashCode - b.hashCode, 0);
    });

    test('a != c', () {
      expect(a == c, false);
      expect((a.hashCode - c.hashCode) == 0, false);
    });
  });

  group('Without Actions', () {
    final responseWithoutActions = {
      'schema': {
        'type': 'object',
        'properties': {
          'b8qscjhfw5mukbred3tae8bd2': {'type': 'string'}
        },
        'required': []
      },
      'schemaObject':
          '/api/users/609bc536dad545d1af7e82db/spaces/60ae6036e65b14482e7f99ac/grids/60ae6039e65b14482e7f99af',
      'components': [
        {
          'property': 'name',
          'value': '123',
          'required': false,
          'options': {
            'multi': false,
            'placeholder': null,
            'description': null,
            'label': null
          },
          'fieldId': 'b8qscjhfw5mukbred3tae8bd2',
          'type': 'textfield'
        }
      ],
      'title': 'New title'
    };
    test('Form Without Actions parses correctly', () {
      final formData = FormData.fromJson(responseWithoutActions);

      expect(formData.actions.length, 0);
    });
  });

  group('Cross Reference', () {
    test('Form with Cross Reference without Value parses', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'uri': {'type': 'string'}
              },
              'required': ['uri'],
              'objectType': 'entityreference',
              'gridUri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': null,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'title': 'New title'
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, 'New title');
      expect(formData.components[0].runtimeType, CrossReferenceFormComponent);
      expect(formData.components[0].data.value, null);
      expect(
          (formData.components[0].data as CrossReferenceDataEntity).entityUri,
          null);
      expect(
          (formData.components[0].data as CrossReferenceDataEntity).gridUri,
          GridUri.fromUri(
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'));
    });

    test('Form with Cross Reference with prefilled Value parses', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'uri': {'type': 'string'}
              },
              'required': ['uri'],
              'objectType': 'entityreference',
              'gridUri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
            },
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'title': 'New title'
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, 'New title');
      expect(formData.components[0].runtimeType, CrossReferenceFormComponent);
      expect(formData.components[0].data.value, 'Yeah!');
      expect(
          (formData.components[0].data as CrossReferenceDataEntity).entityUri,
          EntityUri.fromUri(
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'));
      expect(
          (formData.components[0].data as CrossReferenceDataEntity).gridUri,
          GridUri.fromUri(
              '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'));
    });
  });
}
