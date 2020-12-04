part of active_grid_model;

class FormComponentText extends FormComponent<String, String> {
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

  FormComponentText(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  FormComponentText.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'],
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.text;

  @override
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': value,
        'options': options.toJson(),
        'required': required,
        'type': type,
      };

  @override
  String get schemaValue => value ?? '';
}

class TextComponentOptions extends FormComponentOptions<FormComponentText> {
  final bool multi;
  final String placeholder;
  final String description;
  final String label;

  TextComponentOptions(
      {this.multi = false,
      this.placeholder = '',
      this.description = '',
      this.label});

  TextComponentOptions.fromJson(Map<String, dynamic> json)
      : multi = json['multi'],
        placeholder = json['placeholder'],
        description = json['description'],
        label = json['label'];

  Map<String, dynamic> toJson() => {
        'multi': multi,
        'placeholder': placeholder,
        'description': description,
        'label': label
      };
}
