part of apptive_grid_model;

/// Model for a [FormComponent] representing [UserReferenceDataEntity]
class UserReferenceFormComponent
    extends FormComponent<UserReferenceDataEntity> {
  /// Creates a FormComponent
  UserReferenceFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  UserReferenceFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = UserReferenceDataEntity.fromJson(json['value']),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  UserReferenceDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;
  @override
  final bool required;
}
