part of active_grid_model;

/// Model for a [FormComponent] representing [FormType.text]
class FormComponentText extends FormComponent<String, String> {
  /// Creates a FormComponent
  FormComponentText(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  /// Deserializes [json] into a [FormComponent]
  FormComponentText.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'],
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.text;
  @override
  final String property;
  @override
  String value;
  @override
  final TextComponentOptions options;

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

  @override
  String get schemaValue => value;
}
