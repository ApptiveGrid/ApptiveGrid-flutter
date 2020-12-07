part of active_grid_model;

/// The Type of FormComponents that are available
enum FormType {
  /// Component to display [String]
  text,

  /// Component to display [DateTime]
  dateTime,

  /// Component to display [DateTime] without the option to adjust the Time part
  date,

  /// Component to display [int] numbers
  integer,

  /// Component to display [bool] values
  checkbox,
}

/// Data Object that represents a entry in a Form
///
/// [T] is the type used internally (e.g. [DateTime] for [FormType.dateTime]
/// [R] is the type expected by the backend when sending back data
abstract class FormComponent<T, R> {
  /// Name of the Component
  String get property;

  /// Value of the Component
  T get value;

  /// Additional options of a component
  FormComponentOptions get options;

  /// Shows if the field can be [null]
  ///
  /// For [FormType.checkbox] this will make only `true` values valid
  bool get required;

  /// Type of the component
  FormType get type;

  /// Mapping to a concrete implementation based on [json] and [schema]
  ///
  /// Throws an [ArgumentError] if not matching implementation is found.
  static FormComponent fromJson(dynamic json, dynamic schema) {
    final properties = schema['properties'][json['property']];
    final schemaType = properties['type'];
    final format = properties['format'];
    switch (schemaType) {
      case 'string':
        FormComponent component;
        switch (format) {
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
        return throw ArgumentError(
            'No FormComponent found for $schemaType with format $format found.');
    }
  }

  /// Saves this into a [Map] that can be encoded using [json.encode]
  Map<String, dynamic> toJson();

  /// Value to be used when sending this back to the Server
  R get schemaValue;
}
