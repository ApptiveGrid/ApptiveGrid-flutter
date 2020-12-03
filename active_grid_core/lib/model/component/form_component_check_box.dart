part of active_grid_model;

class FormComponentCheckBox extends FormComponent<bool> {
  @override
  final String property;
  @override
  bool value;
  @override
  final CheckBoxComponentOptions options;
  @override
  final bool required;
  @override
  final FormType type;

  FormComponentCheckBox({@f.required this.property, this.value = false, @f.required this.options, this.required = false, @f.required this.type});

  FormComponentCheckBox.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'] ?? false,
        options = CheckBoxComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormTypeExtensions.fromString(json['type']);

  @override
  Map<String, dynamic> toJson() => {
    'property': property,
    'value': value,
    'options': options.toJson(),
    'required': required,
    'type': type,
  };
}

class CheckBoxComponentOptions extends FormComponentOptions<FormComponentCheckBox>{
  CheckBoxComponentOptions.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}
