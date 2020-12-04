part of active_grid_model;

/// Model for a [FormComponent] representing [FormType.date]
class FormComponentDate extends FormComponent<DateTime, String> {
  /// Creates a FormComponent
  FormComponentDate(
      {@f.required this.property,
        this.value,
        @f.required this.options,
        this.required = false,
        @f.required this.type});

  /// Deserializes [json] into a [FormComponent]
  FormComponentDate.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = _parse(json['value'].toString()),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.date;


  @override
  final String property;
  @override
  DateTime value;
  @override
  final StubComponentOptions options;
  @override
  final bool required;
  @override
  final FormType type;

  @override
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': value,
        'options': options.toJson(),
        'required': required,
        'type': type,
      };

  static DateTime _parse(String json) {
    if (json == 'nil') {
      return null;
    } else {
      return DateTime.parse(json);
    }
  }

  @override
  String get schemaValue => value?.toIso8601String();
}
