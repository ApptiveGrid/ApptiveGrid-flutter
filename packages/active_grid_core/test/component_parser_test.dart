import 'package:active_grid_core/active_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prefilled values', () {
    test('Text', () {
      final property = 'property';
      final value = 'value';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';

      final schema = {
        'properties': {
          property: {
            'type': 'string',
          }
        }
      };
      final json = {
        'property': property,
        'value': value,
        'required': true,
        'options': {
          'multi': true,
          'placeholder': placeholder,
          'description': description,
          'label': label
        },
        'type': 'textfield'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, StringFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, StringDataEntity);
      expect(parsedComponent.data.schemaValue, value);

      final parsedOptions = parsedComponent.options as TextComponentOptions;
      expect(parsedOptions.multi, true);
      expect(parsedOptions.placeholder, placeholder);
      expect(parsedOptions.description, description);
      expect(parsedOptions.label, label);
    });

    test('DateTime', () {
      final property = 'property';
      final value = DateTime(2020, 12, 7, 12, 0, 0);

      final schema = {
        'properties': {
          property: {'type': 'string', 'format': 'date-time'}
        }
      };
      final json = {
        'property': property,
        'value': value.toIso8601String(),
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, DateTimeFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, DateTimeDataEntity);
      expect(parsedComponent.data.schemaValue, value.toIso8601String());

      final parsedOptions = parsedComponent.options;
      expect(false, parsedOptions == null);
    });

    test('Date', () {
      final property = 'property';
      final value = DateTime(2020, 12, 7);

      final schema = {
        'properties': {
          property: {'type': 'string', 'format': 'date'}
        }
      };
      final json = {
        'property': property,
        'value': '2020-12-07',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, DateFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, DateDataEntity);
      expect(parsedComponent.data.schemaValue, '2020-12-07');

      final parsedOptions = parsedComponent.options;
      expect(false, parsedOptions == null);
    });

    test('Number', () {
      final property = 'property';
      final value = 3;
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';

      final schema = {
        'properties': {
          property: {
            'type': 'integer',
          }
        }
      };
      final json = {
        'property': property,
        'value': value,
        'required': true,
        'options': {
          'multi': true,
          'placeholder': placeholder,
          'description': description,
          'label': label
        },
        'type': 'textfield'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, IntegerFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, IntegerDataEntity);
      expect(parsedComponent.data.schemaValue, value);

      final parsedOptions = parsedComponent.options as TextComponentOptions;
      expect(parsedOptions.multi, true);
      expect(parsedOptions.placeholder, placeholder);
      expect(parsedOptions.description, description);
      expect(parsedOptions.label, label);
    });

    test('Checkbox', () {
      final property = 'property';
      final value = true;

      final schema = {
        'properties': {
          property: {
            'type': 'boolean',
          }
        }
      };
      final json = {
        'property': property,
        'value': value,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'checkbox'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, BooleanFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, BooleanDataEntity);
      expect(parsedComponent.data.schemaValue, value);

      final parsedOptions = parsedComponent.options;
      expect(false, parsedOptions == null);
    });
  });

  group('Null values (Empty Form)', () {
    test('Text', () {
      final property = 'property';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';

      final schema = {
        'properties': {
          property: {
            'type': 'string',
          }
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': {
          'multi': true,
          'placeholder': placeholder,
          'description': description,
          'label': label
        },
        'type': 'textfield'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, StringFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, null);
      expect(parsedComponent.data.schemaValue, null);
    });

    test('DateTime', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {'type': 'string', 'format': 'date-time'}
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, DateTimeFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, null);
      expect(parsedComponent.data.schemaValue, null);
    });

    test('Date', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {'type': 'string', 'format': 'date'}
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, DateFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, null);
      expect(parsedComponent.data.schemaValue, null);
    });

    test('Number', () {
      final property = 'property';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';

      final schema = {
        'properties': {
          property: {
            'type': 'integer',
          }
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': {
          'multi': true,
          'placeholder': placeholder,
          'description': description,
          'label': label
        },
        'type': 'textfield'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, IntegerFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, null);
      expect(parsedComponent.data.schemaValue, null);
    });

    test('Checkbox', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {
            'type': 'boolean',
          }
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'checkbox'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, BooleanFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, false);
      expect(parsedComponent.data.schemaValue, false);
    });

    test('Enum', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {
            'type': 'string',
            'enum': ['GmbH', 'AG', 'Freiberuflich']
          }
        },
      };
      final json = {
        'property': property,
        'value': 'AG',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'selectBox'
      };

      final parsedComponent = FormComponent.fromJson(json, schema);

      expect(parsedComponent.runtimeType, EnumFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, 'AG');
      expect((parsedComponent.data as EnumDataEntity).options,
          ['GmbH', 'AG', 'Freiberuflich']);
      expect(parsedComponent.data.schemaValue, 'AG');
    });
  });

  group('Errors', () {
    test('Unknown Type throws', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {
            'type': 'unkown',
          }
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'unkown'
      };

      expect(() => FormComponent.fromJson(json, schema), throwsArgumentError);
    });

    test('Unknown Property throws', () {
      final property = 'property';

      final schema = {
        'properties': {
          property: {
            'type': 'unkown',
          }
        }
      };
      final json = {
        'property': 'schemaError',
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'unkown'
      };

      expect(() => FormComponent.fromJson(json, schema), throwsArgumentError);
    });
  });
}
