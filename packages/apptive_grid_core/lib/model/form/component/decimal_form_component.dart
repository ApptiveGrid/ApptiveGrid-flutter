part of apptive_grid_model;

/// Model for a [FormComponent] representing [DecimalDataEntity]
class DecimalFormComponent extends FormComponent<DecimalDataEntity> {
  /// Creates a FormComponent
  DecimalFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const TextComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  DecimalFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = DecimalDataEntity(json['value']),
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  DecimalDataEntity data;
  @override
  String fieldId;
  @override
  final TextComponentOptions options;
  @override
  final bool required;
}
