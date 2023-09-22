/// Additional properties of a form field ([FormComponent])
class FormFieldProperties {
  /// Deserializes [json] into a FormFieldProperties Object
  factory FormFieldProperties.fromJson({
    required dynamic json,
    required String fieldId,
  }) =>
      FormFieldProperties(
        fieldId: fieldId,
        pageId: json['pageId'],
        fieldIndex: json['fieldIndex'],
        defaultValue: json['defaultValue'],
        disabled: json['disabled'],
        hidden: json['hidden'],
      );

  /// Creates a FormFieldProperties Object
  FormFieldProperties({
    required this.fieldId,
    this.pageId,
    this.fieldIndex,
    this.defaultValue,
    this.disabled = false,
    this.hidden = false,
  });

  /// Id of the field the properties belong to
  final String fieldId;

  /// Page of the field
  final String? pageId;

  /// Position on the page
  final int? fieldIndex;

  /// Default value of the form field
  final dynamic defaultValue;

  /// Flag whether the form field is hidden. This usually means it also has a [defaultValue] set
  final bool hidden;

  /// Flag whether the form field is read-only
  final bool disabled;
}
