part of active_grid_model;

/// Model for a [FormComponent] representing [DateDataEntity]
class DateFormComponent extends FormComponent<DateDataEntity> {
  /// Creates a FormComponent
  DateFormComponent(
      {@f.required this.property,
      @f.required this.data,
      this.options = const StubComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  DateFormComponent.fromJson(Map<String, dynamic> json)
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
