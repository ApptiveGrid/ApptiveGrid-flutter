part of apptive_grid_model;

/// Data Object that represents a entry in a Form
///
/// [T] is the [DataEntity] type of [data]
abstract class FormComponent<T extends DataEntity> {
  /// Name of the Component
  String get property;

  /// Value of the Component
  T get data;

  /// Additional options of a component
  FormComponentOptions get options;

  /// Shows if the field can be [null]
  ///
  /// For [DataType.checkbox] this will make only `true` values valid
  bool get required;

  /// Id of this FormComponent
  String get fieldId;

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
    return '$runtimeType(property: $property, fieldId: $fieldId data: $data, options: $options, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is FormComponent<T> &&
        fieldId == other.fieldId &&
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
  static FormComponent fromJson(dynamic json, dynamic schema) {
    final properties = schema['properties'][json['fieldId']];
    if (properties == null) {
      throw ArgumentError(
        'No Schema Entry found for ${json['property']} with id ${json['fieldId']}',
      );
    }
    final dataType = dataTypeFromSchemaProperty(schemaProperty: properties);
    switch (dataType) {
      case DataType.text:
        return StringFormComponent.fromJson(json);
      case DataType.dateTime:
        return DateTimeFormComponent.fromJson(json);
      case DataType.date:
        return DateFormComponent.fromJson(json);
      case DataType.integer:
        return IntegerFormComponent.fromJson(json);
      case DataType.checkbox:
        return BooleanFormComponent.fromJson(json);
      case DataType.singleSelect:
        return EnumFormComponent.fromJson(json, properties);
      case DataType.crossReference:
        return CrossReferenceFormComponent.fromJson(json, properties);
      case DataType.decimal:
        return DecimalFormComponent.fromJson(json);
      case DataType.attachment:
        return AttachmentFormComponent.fromJson(json);
      case DataType.enumCollection:
        return EnumCollectionFormComponent.fromJson(json, properties);
      case DataType.geolocation:
        return GeolocationFormComponent.fromJson(json);
    }
  }
}
