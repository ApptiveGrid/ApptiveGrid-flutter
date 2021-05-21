part of apptive_grid_model;

/// Model for a [FormComponent] representing [DateTimeDataEntity]
class DateTimeFormComponent extends FormComponent<DateTimeDataEntity> {
  /// Creates a FormComponent
  DateTimeFormComponent(
      {required this.property,
      required this.data,
      required this.fieldId,
      this.options = const FormComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  DateTimeFormComponent.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = DateTimeDataEntity.fromJson(json['value']),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  DateTimeDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;
  @override
  final bool required;
}
