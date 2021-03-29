part of active_grid_model;

/// Model for a [FormComponent] representing [IntegerDataEntity]
class IntegerFormComponent extends FormComponent<IntegerDataEntity> {
  /// Creates a FormComponent
  IntegerFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    required this.options,
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  IntegerFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = IntegerDataEntity(json['value']),
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  IntegerDataEntity data;
  @override
  String fieldId;
  @override
  final TextComponentOptions options;
  @override
  final bool required;
}
