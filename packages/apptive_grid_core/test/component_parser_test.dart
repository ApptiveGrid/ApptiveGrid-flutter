import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prefilled values', () {
    test('Text', () {
      final property = 'property';
      final id = 'id';
      final value = 'value';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';

      final schema = {
        'properties': {
          id: {
            'type': 'string',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date-time'}
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      expect(FormComponentOptions(), parsedOptions);
    });

    test('Date', () {
      final property = 'property';
      final value = DateTime(2020, 12, 7);
      final id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date'}
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      expect(FormComponentOptions(), parsedOptions);
    });

    test('Number', () {
      final property = 'property';
      final value = 3;
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'integer',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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

    test('Decimal', () {
      final property = 'property';
      final value = 47.11;
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'number',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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

      expect(parsedComponent.runtimeType, DecimalFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, value);
      expect(parsedComponent.required, true);
      expect(parsedComponent.data.runtimeType, DecimalDataEntity);
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
      final description = 'description';
      final label = 'label';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'boolean',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
        'value': value,
        'required': true,
        'options': <String, dynamic>{
          'description': description,
          'label': label
        },
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
      expect(parsedOptions.description, description);
      expect(parsedOptions.label, label);
    });
  });

  group('Null values (Empty Form)', () {
    test('Text', () {
      final property = 'property';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'string',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date-time'}
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date'}
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'integer',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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

    test('Decimal', () {
      final property = 'property';
      final placeholder = 'placeholder';
      final description = 'description';
      final label = 'label';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'number',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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

      expect(parsedComponent.runtimeType, DecimalFormComponent);
      expect(parsedComponent.property, property);
      expect(parsedComponent.data.value, null);
      expect(parsedComponent.data.schemaValue, null);
    });

    test('Checkbox', () {
      final property = 'property';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'boolean',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'string',
            'enum': ['GmbH', 'AG', 'Freiberuflich']
          }
        },
      };
      final json = {
        'property': property,
        'fieldId': id,
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
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'unkown',
          }
        }
      };
      final json = {
        'property': property,
        'fieldId': id,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'unkown'
      };

      expect(() => FormComponent.fromJson(json, schema), throwsArgumentError);
    });

    test('Unknown Property throws', () {
      final property = 'property';
      final id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'unkown',
          }
        }
      };
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'unkown',
        'fieldId': 'differentId'
      };

      expect(() => FormComponent.fromJson(json, schema), throwsArgumentError);
    });
  });
}
