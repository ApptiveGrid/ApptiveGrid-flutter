import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Additional properties of a form field ([FormComponent])
class FormFieldProperties {
  /// Deserializes [json] into a [FormFieldProperties] Object
  factory FormFieldProperties.fromJson({
    required dynamic json,
    required GridField field,
  }) {
    DataEntity? defaultValue;
    if (json['defaultValue'] != null) {
      defaultValue =
          DataEntity.fromJson(json: json['defaultValue'], field: field);
    }

    return FormFieldProperties(
      fieldId: field.id,
      pageId: json['pageId'],
      positionOnPage: json['fieldIndex'],
      defaultValue: defaultValue,
      disabled: json['disabled'] ?? false,
      hidden: json['hidden'] ?? false,
      line1Label: json['line1Label'],
      line2Label: json['line2Label'],
    );
  }

  /// Creates a [FormFieldProperties] Object
  FormFieldProperties({
    required this.fieldId,
    this.pageId,
    this.positionOnPage,
    this.defaultValue,
    this.disabled = false,
    this.hidden = false,
    this.line1Label,
    this.line2Label,
  });

  /// Id of the field the properties belong to
  final String fieldId;

  /// Page of the field
  final String? pageId;

  /// Position on the page
  final int? positionOnPage;

  /// Default value of the form field
  final DataEntity? defaultValue;

  /// Flag whether the form field is hidden. This usually means it also has a [defaultValue] set
  final bool hidden;

  /// Flag whether the form field is read-only
  final bool disabled;

  /// Custom label for the first line of a [DataType.address] field
  final String? line1Label;

  /// Custom label for the second line of a [DataType.address] field
  final String? line2Label;

  /// Serializes [FormFieldProperties] to json
  ///
  /// This does not include the [fieldId] since it is used as the key to a map of [FormFieldProperties] jsons
  Map<String, dynamic> toJson() {
    return {
      if (pageId != null) 'pageId': pageId,
      if (positionOnPage != null) 'fieldIndex': positionOnPage,
      if (defaultValue != null) 'defaultValue': defaultValue!.schemaValue,
      if (hidden) 'hidden': true,
      if (disabled) 'disabled': true,
      if (line1Label != null) 'line1Label': line1Label,
      if (line2Label != null) 'line2Label': line2Label,
    };
  }

  @override
  String toString() {
    return 'FormFieldProperties('
        'fieldId: $fieldId, '
        'pageId: $pageId, '
        'positionOnPage: $positionOnPage, '
        'defaultValue: ${defaultValue?.schemaValue}, '
        'hidden: $hidden, '
        'disabled: $disabled, '
        'line1Label: $line1Label, '
        'line2Label: $line2Label)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormFieldProperties &&
        other.fieldId == fieldId &&
        other.pageId == pageId &&
        other.positionOnPage == positionOnPage &&
        other.defaultValue == defaultValue &&
        other.hidden == hidden &&
        other.disabled == disabled &&
        other.line1Label == line1Label &&
        other.line2Label == line2Label;
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldId,
      pageId,
      positionOnPage,
      defaultValue,
      hidden,
      disabled,
      line1Label,
      line2Label,
    );
  }
}
