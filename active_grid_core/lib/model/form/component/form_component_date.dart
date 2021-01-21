part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.date]
class FormComponentDate extends FormComponent<DateTime, String> {
  /// Creates a FormComponent
  FormComponentDate(
      {@f.required this.property,
      @f.required this.data,
      @f.required this.options,
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  FormComponentDate.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = DateDataEntity.fromJson(json['value']),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  DateDataEntity data;
  @override
  final StubComponentOptions options;
  @override
  final bool required;
}
