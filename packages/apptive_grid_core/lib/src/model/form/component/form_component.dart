import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Data Object that represents a entry in a Form
///
/// [T] is the [DataEntity] type of [data]
class FormComponent<T extends DataEntity> {
  /// Creates a new FormComponent
  FormComponent({
    required this.property,
    required this.data,
    this.options = const FormComponentOptions(),
    this.required = false,
    required this.field,
    String? type,
  }) : type = type ?? field.type.name;

  /// Casts this FormComponent to a FormComponent with a specific DataEntity Type
  FormComponent<U> cast<U extends DataEntity>() {
    return FormComponent<U>(
      property: property,
      data: data as U,
      options: options,
      required: required,
      field: field,
      type: type,
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

  /// Type of the Component
  final String type;

  /// Id of this FormComponent
  String get fieldId => field.id;

  /// Saves this into a [Map] that can be encoded using [json.encode]
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': data.schemaValue,
        'options': options.toJson(),
        'required': required,
        'fieldId': fieldId,
        'type': type,
      };

  @override
  String toString() {
    return 'FormComponent(property: $property, field: $field, data: $data, options: $options, required: $required, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return other is FormComponent &&
        field == other.field &&
        property == other.property &&
        data == other.data &&
        options == other.options &&
        required == other.required &&
        type == other.type;
  }

  @override
  int get hashCode =>
      Object.hash(field, property, data, options, required, type);

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

    if (field.type == DataType.text &&
        options.multi == false &&
        data.value?.contains('\n') == true) {
      data.value = data.value?.replaceAll('\n', ' ');
    }

    final type = json['type'];

    return FormComponent(
      property: property,
      data: data,
      options: options,
      required: required,
      field: field,
      type: type,
    );
  }
}
