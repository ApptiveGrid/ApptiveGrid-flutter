part of active_grid_model;

/// Model for a [FormComponent] representing [FormType.integer]
class FormComponentNumber extends FormComponent<int, int> {
  /// Creates a FormComponent
  FormComponentNumber(
      {@f.required this.property,
      this.value,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  /// Deserializes [json] into a [FormComponent]
  FormComponentNumber.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'],
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = FormType.integer;

  @override
  final String property;
  @override
  int value;
  @override
  final TextComponentOptions options;

  @override
  final bool required;

  @override
  final FormType type;

  @override
  int get schemaValue => value;
}
