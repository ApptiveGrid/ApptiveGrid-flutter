part of active_grid_model;

/// Model for a [FormComponent] representing [DateTimeDataEntity]
class DateTimeFormComponent extends FormComponent<DateTimeDataEntity> {
  /// Creates a FormComponent
  DateTimeFormComponent(
      {@f.required this.property,
      @f.required this.data,
      this.options = const StubComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  DateTimeFormComponent.fromJson(Map<String, dynamic> json)
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
