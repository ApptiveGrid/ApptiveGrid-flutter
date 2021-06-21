part of apptive_grid_model;

/// Model for a [FormComponent] representing [CrossReferenceDataEntity]
class CrossReferenceFormComponent extends FormComponent<CrossReferenceDataEntity> {
  /// Creates a FormComponent
  CrossReferenceFormComponent(
      {required this.property,
      required this.data,
      required this.fieldId,
      this.options = const FormComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  CrossReferenceFormComponent.fromJson(Map<String, dynamic> json, dynamic schema)
      : property = json['property'],
        data = CrossReferenceDataEntity(
            jsonValue: json['value'],
            gridUri: schema['gridUri'],),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  CrossReferenceDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
