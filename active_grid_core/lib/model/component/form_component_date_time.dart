part of active_grid_model;

class FormComponentDateTime extends FormComponent<DateTime, String> {
  @override
  final String property;
  @override
  DateTime value;
  @override
  final DateTimeComponentOptions options;
  @override
  final bool required;
  @override
  final FormType type;

  FormComponentDateTime({@f.required this.property, this.value, @f.required this.options, this.required = false, @f.required this.type});

  FormComponentDateTime.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = _parse(json['value'].toString()),
        options = DateTimeComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.dateTime;

  @override
  Map<String, dynamic> toJson() => {
    'property': property,
    'value': value,
    'options': options.toJson(),
    'required': required,
    'type': type,
  };

  static DateTime _parse(String json) {
    if(json == 'nil' || json == 'null') {
      return null;
    } else {
      return DateTime.parse(json);
    }
  }

  @override
  String get schemaValue => value?.toIso8601String();
}

class DateTimeComponentOptions extends FormComponentOptions<FormComponentDateTime>{
  DateTimeComponentOptions.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}
