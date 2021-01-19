part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.dateTime]
class FormComponentDateTime extends FormComponent<DateTime, String> {
  /// Creates a FormComponent
  FormComponentDateTime(
      {@f.required this.property,
      @f.required this.data,
      @f.required this.options,
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  FormComponentDateTime.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = DateTimeDataEntity.fromJson(json['value']),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  DateTimeDataEntity data;
  @override
  final StubComponentOptions options;
  @override
  final bool required;
}
