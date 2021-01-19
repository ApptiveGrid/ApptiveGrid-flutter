part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.dateTime]
class FormComponentDateTime extends FormComponent<DateTime, String> {
  /// Creates a FormComponent
  FormComponentDateTime(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  /// Deserializes [json] into a [FormComponent]
  FormComponentDateTime.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = _parse(json['value']),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = DataType.dateTime;

  @override
  final String property;
  @override
  DateTime value;
  @override
  final StubComponentOptions options;
  @override
  final bool required;
  @override
  final DataType type;

  static DateTime _parse(String json) {
    if (json == null) {
      return null;
    } else {
      return DateTime.parse(json);
    }
  }

  @override
  String get schemaValue => value?.toIso8601String();
}
