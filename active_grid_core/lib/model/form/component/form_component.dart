part of active_grid_model;

/// Data Object that represents a entry in a Form
///
/// [T] is the type used internally (e.g. [DateTime] for [DataType.dateTime]
/// [R] is the type expected by the backend when sending back data
abstract class FormComponent<T, R> {
  /// Name of the Component
  String get property;

  /// Value of the Component
  DataEntity<T, R> get data;

  /// Additional options of a component
  FormComponentOptions get options;

  /// Shows if the field can be [null]
  ///
  /// For [DataType.checkbox] this will make only `true` values valid
  bool get required;

  /// Saves this into a [Map] that can be encoded using [json.encode]
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': data.schemaValue,
        'options': options.toJson(),
        'required': required,
      };

  @override
  String toString() {
    return '$runtimeType(property: $property, data: $data, options: $options, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is FormComponent<T, R> &&
        property == other.property &&
        data == other.data &&
        options == other.options &&
        required == other.required;
  }

  @override
  int get hashCode => toString().hashCode;

  /// Mapping to a concrete implementation based on [json] and [schema]
  ///
  /// Throws an [ArgumentError] if not matching implementation is found.
  // missing_return can be ignored as the switch statement is exhaustive
  // ignore: missing_return
  static FormComponent fromJson(dynamic json, dynamic schema) {
    final dataType =
        dataTypeFromSchema(schema: schema, propertyName: json['property']);
    switch (dataType) {
      case DataType.text:
        return FormComponentText.fromJson(json);
      case DataType.dateTime:
        return FormComponentDateTime.fromJson(json);
      case DataType.date:
        return FormComponentDate.fromJson(json);
      case DataType.integer:
        return FormComponentNumber.fromJson(json);
      case DataType.checkbox:
        return FormComponentCheckBox.fromJson(json);
    }
  }
}
