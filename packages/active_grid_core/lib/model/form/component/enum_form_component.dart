part of active_grid_model;

/// Model for a [FormComponent] representing [EnumDataEntity]
class EnumFormComponent extends FormComponent<EnumDataEntity> {
  /// Creates a FormComponent
  EnumFormComponent(
      {@f.required this.property,
      @f.required this.data,
      this.options = const FormComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  EnumFormComponent.fromJson(Map<String, dynamic> json, dynamic schema)
      : property = json['property'],
        data = EnumDataEntity(
            value: json['value'],
            options: schema['enum'].map<String>((e) => e.toString()).toList()),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  EnumDataEntity data;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
