part of active_grid_model;

/// Model for a [FormComponent] representing [EnumDataEntity]
class EnumFormComponent extends FormComponent<EnumDataEntity> {
  /// Creates a FormComponent
  EnumFormComponent(
      {@f.required this.property,
      @f.required this.data,
      this.options = const StubComponentOptions(),
      this.required = false});

  /// Deserializes [json] into a [FormComponent]
  EnumFormComponent.fromJson(Map<String, dynamic> json, dynamic schema)
      : property = json['property'],
        data = EnumDataEntity(
            value: json['value'],
            values: schema['enum'].map<String>((e) => e.toString()).toList()),
        options = StubComponentOptions.fromJson(json['options']),
        required = json['required'];

  @override
  final String property;
  @override
  EnumDataEntity data;
  @override
  final StubComponentOptions options;

  @override
  final bool required;
}
