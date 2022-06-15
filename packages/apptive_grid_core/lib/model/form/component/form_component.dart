part of apptive_grid_model;

/// Data Object that represents a entry in a Form
///
/// [T] is the [DataEntity] type of [data]
class FormComponent<T extends DataEntity> {
  /// Creates a new FormComponent
  const FormComponent({
    required this.property,
    required this.data,
    this.options = const FormComponentOptions(),
    this.required = false,
    required this.field,
  });

  /// Casts this FormComponent to a FormComponent with a specific DataEntity Type
  FormComponent<U> cast<U extends DataEntity>() {
    return FormComponent<U>(
      property: property,
      data: data as U,
      options: options,
      required: required,
      field: field,
    );
  }

  /// The GridField this [FormComponent] is associated with
  final GridField field;

  /// Name of the Component
  final String property;

  /// Value of the Component
  final T data;

  /// Additional options of a component
  final FormComponentOptions options;

  /// Shows if the field can be [null]
  ///
  /// For [DataType.checkbox] this will make only `true` values valid
  final bool required;

  /// Id of this FormComponent
  String get fieldId => field.id;

  /// Saves this into a [Map] that can be encoded using [json.encode]
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': data.schemaValue,
        'options': options.toJson(),
        'required': required,
        'fieldId': fieldId,
      };

  @override
  String toString() {
    return 'FormComponent(property: $property, field: $field, data: $data, options: $options, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return other is FormComponent &&
        field == other.field &&
        property == other.property &&
        data == other.data &&
        options == other.options &&
        required == other.required;
  }

  @override
  int get hashCode =>
      field.hashCode +
      property.hashCode +
      data.hashCode +
      options.hashCode +
      required.hashCode;

  /// Mapping to a concrete implementation based on [json] and [schema]
  ///
  /// Throws an [ArgumentError] if not matching implementation is found.
  static FormComponent fromJson(dynamic json, List<GridField> fields) {
    final id = json['fieldId'];
    final property = json['property'];
    final field = fields.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Field with id $id not found'),
    );
    final options = FormComponentOptions.fromJson(json['options']);
    final required = json['required'] ?? false;
    final data = DataEntity.fromJson(json: json['value'], field: field);

    return FormComponent(
      property: property,
      data: data,
      options: options,
      required: required,
      field: field,
    );
  }
}
