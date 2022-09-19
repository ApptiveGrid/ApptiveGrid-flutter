import 'package:apptive_grid_core/apptive_grid_core.dart';
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.text,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(StringDataEntity));
      expect(parsedComponent.data.schemaValue, equals(value));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(true));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
    });

    test('Multiline Text', () {
      const property = 'property';
      const id = 'id';
      const value = 'value\nvalue';
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.text,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(StringDataEntity));
      expect(parsedComponent.data.schemaValue, equals(value));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(true));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
    });

    test('Multiline Text in single line form field', () {
      const property = 'property';
      const id = 'id';
      const value = 'value\nvalue';
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.text,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': value,
        'required': true,
        'options': {
          'multi': false,
          'placeholder': placeholder,
          'description': description,
          'label': label
        },
        'type': 'textfield'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      final cleanValue = value.replaceAll('\n', ' ');

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(cleanValue));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(StringDataEntity));
      expect(parsedComponent.data.schemaValue, equals(cleanValue));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(false));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.dateTime,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': value.toUtc().toIso8601String(),
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(DateTimeDataEntity));
      expect(
        parsedComponent.data.schemaValue,
        equals(value.toUtc().toIso8601String()),
      );

      final parsedOptions = parsedComponent.options;
      expect(const FormComponentOptions(), equals(parsedOptions));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.date,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': '2020-12-07',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(DateDataEntity));
      expect(parsedComponent.data.schemaValue, equals('2020-12-07'));

      final parsedOptions = parsedComponent.options;
      expect(const FormComponentOptions(), equals(parsedOptions));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.integer,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(IntegerDataEntity));
      expect(parsedComponent.data.schemaValue, equals(value));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(true));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.decimal,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(DecimalDataEntity));
      expect(parsedComponent.data.schemaValue, equals(value));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(true));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
    });

    test('Decimal with non float number', () {
      const property = 'property';
      const value = 47;
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.decimal,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(47.0));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(DecimalDataEntity));
      expect(parsedComponent.data.schemaValue, equals(47.0));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.multi, equals(true));
      expect(parsedOptions.placeholder, equals(placeholder));
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.checkbox,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(value));
      expect(parsedComponent.required, equals(true));
      expect(parsedComponent.data.runtimeType, equals(BooleanDataEntity));
      expect(parsedComponent.data.schemaValue, equals(value));

      final parsedOptions = parsedComponent.options;
      expect(parsedOptions.description, equals(description));
      expect(parsedOptions.label, equals(label));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.text,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(null));
      expect(parsedComponent.data.schemaValue, equals(null));
    });

    test('DateTime', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date-time'}
        }
      };
      final field = GridField(
        id: id,
        name: property,
        type: DataType.dateTime,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(null));
      expect(parsedComponent.data.schemaValue, equals(null));
    });

    test('Date', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        'properties': {
          id: {'type': 'string', 'format': 'date'}
        }
      };
      final field = GridField(
        id: id,
        name: property,
        type: DataType.date,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'datePicker'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(null));
      expect(parsedComponent.data.schemaValue, equals(null));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.integer,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(null));
      expect(parsedComponent.data.schemaValue, equals(null));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.integer,
        schema: schema,
      );
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

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(null));
      expect(parsedComponent.data.schemaValue, equals(null));
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
      final field = GridField(
        id: id,
        name: property,
        type: DataType.checkbox,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'checkbox'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals(false));
      expect(parsedComponent.data.schemaValue, equals(false));
    });

    test('Enum', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        'type': 'string',
        'enum': ['GmbH', 'AG', 'Freiberuflich']
      };
      final field = GridField(
        id: id,
        name: property,
        type: DataType.singleSelect,
        schema: schema,
      );
      final json = {
        'property': property,
        'fieldId': id,
        'value': 'AG',
        'required': true,
        'options': <String, dynamic>{},
        'type': 'selectBox'
      };

      final parsedComponent = FormComponent.fromJson(json, [field]);

      expect(parsedComponent.property, equals(property));
      expect(parsedComponent.data.value, equals('AG'));
      expect(
        (parsedComponent.data as EnumDataEntity).options,
        {'GmbH', 'AG', 'Freiberuflich'},
      );
      expect(parsedComponent.data.schemaValue, equals('AG'));
    });
  });

  group('Errors', () {
    test('Unknown Id throws Exception', () {
      const property = 'property';
      const id = 'id';

      final schema = {
        'properties': {
          id: {
            'type': 'unkown',
          }
        }
      };
      final field = GridField(
        id: id,
        name: property,
        type: DataType.text,
        schema: schema,
      );
      final json = {
        'property': property,
        'value': null,
        'required': true,
        'options': <String, dynamic>{},
        'type': 'unkown',
        'fieldId': 'differentId'
      };

      expect(
        () => FormComponent.fromJson(json, [field]),
        throwsException,
      );
    });
  });
}
