part of active_grid_model;

/// Model for a [FormComponent] representing [BooleanDataEntity]
class BooleanFormComponent extends FormComponent<BooleanDataEntity> {
  /// Creates a FormComponent
  BooleanFormComponent(
      {required this.property,
      required this.data,
      required this.fieldId,
      this.options = const FormComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  BooleanFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = BooleanDataEntity(json['value']),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String /*!*/ property;
  @override
  BooleanDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;
  @override
  final bool required;
}
