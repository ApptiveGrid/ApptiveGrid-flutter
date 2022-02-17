part of apptive_grid_model;

/// Model for a [FormComponent] representing [AttachmentDataEntity]
class AttachmentFormComponent extends FormComponent<AttachmentDataEntity> {
  /// Creates a FormComponent
  AttachmentFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  AttachmentFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = AttachmentDataEntity.fromJson(
          json['value'],
        ),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  AttachmentDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
