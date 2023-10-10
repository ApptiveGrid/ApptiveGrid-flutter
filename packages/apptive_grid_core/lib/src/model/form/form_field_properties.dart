import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Additional properties of a form field ([FormComponent])
class FormFieldProperties {
  /// Deserializes [json] into a [FormFieldProperties] Object
  factory FormFieldProperties.fromJson({
    required dynamic json,
    required GridField field,
  }) {
    if (json
        case {
          'defaultValue': dynamic defaultValue,
          'pageId': String? pageId,
          'fieldIndex': int? positionOnPage,
          'disabled': bool? disabled,
          'hidden': bool? hidden,
        }) {
      return FormFieldProperties(
        fieldId: field.id,
        pageId: pageId,
        positionOnPage: positionOnPage,
        defaultValue: defaultValue != null
            ? DataEntity.fromJson(json: defaultValue, field: field)
            : null,
        disabled: disabled ?? false,
        hidden: hidden ?? false,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid FormFieldProperties json: $json',
      );
    }
  }

  /// Creates a [FormFieldProperties] Object
  FormFieldProperties({
    required this.fieldId,
    this.pageId,
    this.positionOnPage,
    this.defaultValue,
    this.disabled = false,
    this.hidden = false,
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
        'disabled: $disabled)';
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
        other.disabled == disabled;
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
    );
  }
}
