part of active_grid_model;

/// Model for a [FormComponent] representing [DateDataEntity]
class DateFormComponent extends FormComponent<DateDataEntity> {
  /// Creates a FormComponent
  DateFormComponent(
      {required this.property,
      required this.data,
      required this.fieldId,
      this.options = const FormComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  DateFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = DateDataEntity.fromJson(json['value']),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  DateDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;
  @override
  final bool required;
}
