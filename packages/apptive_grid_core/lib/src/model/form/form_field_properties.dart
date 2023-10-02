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
      fieldIndex: json['fieldIndex'],
      defaultValue: defaultValue,
      disabled: json['disabled'] ?? false,
      hidden: json['hidden'] ?? false,
    );
  }

  /// Creates a [FormFieldProperties] Object
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
  final DataEntity? defaultValue;

  /// Flag whether the form field is hidden. This usually means it also has a [defaultValue] set
  final bool hidden;

  /// Flag whether the form field is read-only
  final bool disabled;

  /// Serializes [FormFieldProperties] to json
  ///
  /// This does not include the [fieldId] since it is used as the key to a map of [FormFieldProperties] jsons
  Map<String, dynamic> toJson() {
    return {
      if (pageId != null) 'pageId': pageId,
      if (fieldIndex != null) 'fieldIndex': fieldIndex,
      if (defaultValue != null) 'defaultValue': defaultValue!.schemaValue,
      if (hidden) 'hidden': true,
      if (disabled) 'disabled': true,
    };
  }

  @override
  String toString() {
    return 'FormFieldProperties('
        'fieldId: $fieldId, '
        'pageId: $pageId, '
        'fieldIndex: $fieldIndex, '
        'defaultValue: ${defaultValue?.schemaValue}, '
        'hidden: $hidden, '
        'disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormFieldProperties &&
        other.fieldId == fieldId &&
        other.pageId == pageId &&
        other.fieldIndex == fieldIndex &&
        other.defaultValue == defaultValue &&
        other.hidden == hidden &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldId,
      pageId,
      fieldIndex,
      defaultValue,
      hidden,
      disabled,
    );
  }
}
