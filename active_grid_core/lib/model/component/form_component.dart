part of active_grid_model;

enum FormType {
  text, dateTime, date, integer, checkbox, unkown
}

abstract class FormComponent<T, R> {
  String get property;
  T get value;
  FormComponentOptions get options;
  bool get required;
  FormType get type;

  static FormComponent fromJson(dynamic json, dynamic schema) {
    final properties = schema['properties'][json['property']];
    final schemaType = properties['type'];
    final format = properties['format'];
      switch(schemaType) {
        case 'string':
          FormComponent component;
          switch(format) {
            case 'date-time':
              component = FormComponentDateTime.fromJson(json);
              break;
            case 'date':
              component = FormComponentDate.fromJson(json);
              break;
            default:
              component = FormComponentText.fromJson(json);
              break;
          }
          return component;
        case 'integer':
          return FormComponentNumber.fromJson(json);
        case 'boolean':
          return FormComponentCheckBox.fromJson(json);
        default:
          return throw ArgumentError('No FormComponent found for $schemaType with format $format found.');
      }
  }

  Map<String, dynamic> toJson();

  R get schemaValue;
}

abstract class FormComponentOptions<T extends FormComponent>{}