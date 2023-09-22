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
      );

  /// Creates a FormFieldProperties Object
  FormFieldProperties({
    required this.fieldId,
    this.pageId,
    this.fieldIndex,
  });

  /// Id of the field the properties belong to
  final String fieldId;

  /// Page of the field
  final String? pageId;

  /// Position on the page
  final int? fieldIndex;
}
