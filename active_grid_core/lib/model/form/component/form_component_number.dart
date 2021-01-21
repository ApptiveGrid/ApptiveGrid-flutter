part of active_grid_model;

/// Model for a [FormComponent] representing [DataType.integer]
class FormComponentNumber extends FormComponent<int, int> {
  /// Creates a FormComponent
  FormComponentNumber({
    @f.required this.property,
    @f.required this.data,
    @f.required this.options,
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  FormComponentNumber.fromJson(Map<String, dynamic> json)
      : property = json['property'],
        data = IntegerDataEntity(json['value']),
        options = TextComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  IntegerDataEntity data;
  @override
  final TextComponentOptions options;

  @override
  final bool required;
}
