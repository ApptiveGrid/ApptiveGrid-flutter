part of active_grid_model;

class FormComponentNumber extends FormComponent<int, int> {
  @override
  final String property;
  @override
  int value;
  @override
  final NumberComponentOptions options;
  @override
  final bool required;
  @override
  final FormType type;

  FormComponentNumber(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  FormComponentNumber.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'],
        options = NumberComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.integer;

  @override
  Map<String, dynamic> toJson() => {
        'property': property,
        'value': value,
        'options': options.toJson(),
        'required': required,
        'type': type,
      };

  @override
  int get schemaValue => value;
}

class NumberComponentOptions extends FormComponentOptions<FormComponentNumber> {
  final bool multi;
  final String placeholder;
  final String description;
  final String label;

  NumberComponentOptions(
      {this.multi = false,
      this.placeholder = '',
      this.description = '',
      this.label});

  NumberComponentOptions.fromJson(Map<String, dynamic> json)
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
