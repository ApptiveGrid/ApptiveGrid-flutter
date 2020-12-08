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
        'TextC': {'type': 'string'},
        'NumberC': {'type': 'integer'},
        'DateTimeC': {'type': 'string', 'format': 'date-time'},
        'DateC': {'type': 'string', 'format': 'date'},
        'CheckmarkC': {'type': 'boolean'}
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
      {
        'property': 'NumberC',
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
      {
        'property': 'DateTimeC',
        'value': null,
        'required': false,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      },
      {
        'property': 'DateC',
        'value': null,
        'required': false,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      },
      {
        'property': 'CheckmarkC',
        'value': null,
        'required': false,
        'options': <String, dynamic>{},
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
        FormComponentText,
        FormComponentNumber,
        FormComponentDateTime,
        FormComponentDate,
        FormComponentCheckBox,
      ]);
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      final action = FormAction('/uri', 'POST');
      final schema = response['schema'];
      final component = FormComponentNumber(
          type: FormType.integer,
          options: TextComponentOptions(),
          property: 'NumberC');

      final formData = FormData(title, [component], [action], schema);

      expect(FormData.fromJson(formData.toJson()), formData);
    });
  });

  group('Schema Validation', () {
    test('toRequestObject matches Schema', () {
      final schema = JsonSchema.createSchema(response['schema']);

      final formData = FormData.fromJson(response);

      expect(schema.validateWithErrors(jsonEncode(formData.toRequestObject(),), parseJson: true), []);
    });
  });
}
