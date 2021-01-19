part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.checkbox]
class FormComponentCheckBox extends FormComponent<bool, bool> {
  /// Creates a FormComponent
  FormComponentCheckBox(
      {@f.required this.property,
      this.value = false,
      @f.required this.options,
      this.required = false,
      @f.required this.type});

  /// Deserializes [json] into a [FormComponent]
  FormComponentCheckBox.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        value = json['value'] ?? false,
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'],
        type = DataType.checkbox;

  @override
  final String property;
  @override
  bool value;
  @override
  final StubComponentOptions options;

  @override
  final bool required;

  @override
  final DataType type;

  @override
  bool get schemaValue => value;
}
