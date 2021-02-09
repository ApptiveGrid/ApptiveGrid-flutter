import 'dart:convert';

import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema/json_schema.dart';

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

  group('Schema Validation', () {
    test('toRequestObject matches Schema', () {
      final schema = JsonSchema.createSchema(response['schema']);

      final formData = FormData.fromJson(response);

      expect(
          schema.validateWithErrors(
              jsonEncode(
                formData.toRequestObject(),
              ),
              parseJson: true),
          []);
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
}
