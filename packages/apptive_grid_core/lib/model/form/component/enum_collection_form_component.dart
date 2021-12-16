part of apptive_grid_model;

/// Model for a [FormComponent] representing [EnumCollectionDataEntity]
class EnumCollectionFormComponent
    extends FormComponent<EnumCollectionDataEntity> {
  /// Creates a FormComponent
  EnumCollectionFormComponent({
    required this.property,
    required this.data,
    required this.fieldId,
    this.options = const FormComponentOptions(),
    this.required = false,
  });

  /// Deserializes [json] into a [FormComponent]
  EnumCollectionFormComponent.fromJson(
    Map<String, dynamic> json,
    dynamic schema,
  )   : property = json['property'],
        data = EnumCollectionDataEntity(
          value:
              (json['value']?.cast<String>() as List<String>?)?.toSet() ?? {},
          options:
              (schema['items']['enum'].cast<String>() as List<String>).toSet(),
        ),
        options = FormComponentOptions.fromJson(json['options']),
        required = json['required'],
        fieldId = json['fieldId'];

  @override
  final String property;
  @override
  EnumCollectionDataEntity data;
  @override
  final String fieldId;
  @override
  final FormComponentOptions options;

  @override
  final bool required;
}
