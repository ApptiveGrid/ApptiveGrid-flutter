import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prefilled values', () {
    test('Text', () {
      const property = 'property';
      const id = 'id';
      const value = 'value';
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';

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
      const property = 'property';
      final value = DateTime(2020, 12, 7, 12, 0, 0);
      const id = 'id';

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
      expect(const FormComponentOptions(), parsedOptions);
    });

    test('Date', () {
      const property = 'property';
      final value = DateTime(2020, 12, 7);
      const id = 'id';

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
      expect(const FormComponentOptions(), parsedOptions);
    });

    test('Number', () {
      const property = 'property';
      const value = 3;
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const value = 47.11;
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const value = true;
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const id = 'id';

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
      const property = 'property';
      const id = 'id';

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
      const property = 'property';
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const placeholder = 'placeholder';
      const description = 'description';
      const label = 'label';
      const id = 'id';

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
      const property = 'property';
      const id = 'id';

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
      const property = 'property';
      const id = 'id';

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
      expect(
        (parsedComponent.data as EnumDataEntity).options,
        ['GmbH', 'AG', 'Freiberuflich'],
      );
      expect(parsedComponent.data.schemaValue, 'AG');
    });
  });

  group('Errors', () {
    test('Unknown Type throws', () {
      const property = 'property';
      const id = 'id';

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
      const property = 'property';
      const id = 'id';

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
