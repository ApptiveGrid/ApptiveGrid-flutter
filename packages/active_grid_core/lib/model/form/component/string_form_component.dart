part of active_grid_model;

/// Model for a [FormComponent] representing [StringDataEntity]
class StringFormComponent extends FormComponent<StringDataEntity> {
  /// Creates a FormComponent
  StringFormComponent(
      {@f.required this.property,
      @f.required this.data,
      @f.required this.options,
      @f.required this.fieldId,
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  StringFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = StringDataEntity(json['value']),
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  StringDataEntity data;
  @override
  final String fieldId;
  @override
  final TextComponentOptions options;
  @override
  final bool required;
}
