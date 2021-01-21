part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.checkbox]
class FormComponentCheckBox extends FormComponent<bool, bool> {
  /// Creates a FormComponent
  FormComponentCheckBox(
      {@f.required this.property,
      @f.required this.data,
      @f.required this.options,
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  FormComponentCheckBox.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = BooleanDataEntity(json['value']),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  BooleanDataEntity data;
  @override
  final StubComponentOptions options;

  @override
  final bool required;
}
