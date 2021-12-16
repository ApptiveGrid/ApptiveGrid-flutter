part of apptive_grid_model;

/// Model for a [FormComponent] representing [GeolocationDataEntity]
class GeolocationFormComponent extends FormComponent<GeolocationDataEntity> {
  /// Creates a FormComponent
  GeolocationFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  GeolocationFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = GeolocationDataEntity.fromJson(json['value']),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  GeolocationDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;
  @override
  final bool required;
}
