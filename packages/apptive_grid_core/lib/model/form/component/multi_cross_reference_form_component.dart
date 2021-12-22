part of apptive_grid_model;

/// Model for a [FormComponent] representing [MultiCrossReferenceDataEntity]
class MultiCrossReferenceFormComponent
    extends FormComponent<MultiCrossReferenceDataEntity> {
  /// Creates a FormComponent
  MultiCrossReferenceFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  MultiCrossReferenceFormComponent.fromJson(
    Map<String, dynamic> json,
    dynamic schema,
  )   : property = json['property'],
        data = MultiCrossReferenceDataEntity.fromJson(
          jsonValue: json['value'],
          gridUri: schema['items']['gridUri'],
        ),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  MultiCrossReferenceDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
