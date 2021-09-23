part of apptive_grid_model;

/// Model for a [FormComponent] representing [EnumDataEntity]
class EnumFormComponent extends FormComponent<EnumDataEntity> {
  /// Creates a FormComponent
  EnumFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  EnumFormComponent.fromJson(Map<String, dynamic> json, dynamic schema)
      : property = json['property'],
        data = EnumDataEntity(
          value: json['value'],
          options: schema['enum'].cast<String>(),
        ),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  EnumDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
