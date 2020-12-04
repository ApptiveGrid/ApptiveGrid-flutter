part of active_grid_model;

class FormComponentDate extends FormComponent<DateTime, String> {
  @override
  final String property;
  @override
  DateTime value;
  @override
  final DateComponentOptions options;
  @override
  final bool required;
  @override
  final FormType type;

  FormComponentDate(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  FormComponentDate.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = _parse(json['value'].toString()),
        options = DateComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.date;

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
      return null;
      return DateTime.parse(json);
    }
  }

  @override
  String get schemaValue => value?.toIso8601String();
}

class DateComponentOptions extends FormComponentOptions<FormComponentDate> {
  DateComponentOptions.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}
