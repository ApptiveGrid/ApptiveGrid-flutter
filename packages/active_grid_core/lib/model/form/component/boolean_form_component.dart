part of active_grid_model;

/// Model for a [FormComponent] representing [BooleanDataEntity]
class BooleanFormComponent extends FormComponent<BooleanDataEntity> {
  /// Creates a FormComponent
  BooleanFormComponent(
      {@f.required this.property,
      @f.required this.data,
      this.options = const StubComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  BooleanFormComponent.fromJson(Map<String, dynamic> json)
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
