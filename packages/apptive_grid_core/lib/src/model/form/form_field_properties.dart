import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

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
      typeOverride: json['typeOverride'],
      enableBarcodeScanner: json['enableBarcodeScanner'] ?? false,
      appendOnlyAttachments: json['appendOnlyAttachments'] ?? false,
      i18n: (json['i18n'] as Map?)?.map(
            (language, translation) => MapEntry(
              language as String,
              FormFieldTranslation.fromJson(translation),
            ),
          ) ??
          const {},
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
    this.typeOverride,
    this.enableBarcodeScanner = false,
    this.appendOnlyAttachments = false,
    this.i18n = const {},
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

  /// Replaces the default input of the field with a different one
  ///
  /// The only value the form builder writes today is `videoRecorder` for a
  /// [DataType.attachment] field, see [isVideoRecorder]. Kept as a plain
  /// string so unknown future overrides still parse.
  final String? typeOverride;

  /// Whether a [DataType.attachment] field records a single video instead of
  /// picking files
  bool get isVideoRecorder => typeOverride == 'videoRecorder';

  /// Whether a single-line text field offers a barcode scanner
  final bool enableBarcodeScanner;

  /// Whether attachments that exist when the form opens (including a
  /// [defaultValue]) are read-only, so users can only add further files
  final bool appendOnlyAttachments;

  /// Translated label and description per language code, used when the form
  /// has [FormDataProperties] with multiple languages
  final Map<String, FormFieldTranslation> i18n;

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
      if (typeOverride != null) 'typeOverride': typeOverride,
      if (enableBarcodeScanner) 'enableBarcodeScanner': true,
      if (appendOnlyAttachments) 'appendOnlyAttachments': true,
      if (i18n.isNotEmpty)
        'i18n': {
          for (final entry in i18n.entries) entry.key: entry.value.toJson(),
        },
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
        'line2Label: $line2Label, '
        'typeOverride: $typeOverride, '
        'enableBarcodeScanner: $enableBarcodeScanner, '
        'appendOnlyAttachments: $appendOnlyAttachments, '
        'i18n: $i18n)';
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
        other.line2Label == line2Label &&
        other.typeOverride == typeOverride &&
        other.enableBarcodeScanner == enableBarcodeScanner &&
        other.appendOnlyAttachments == appendOnlyAttachments &&
        f.mapEquals(other.i18n, i18n);
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
      typeOverride,
      enableBarcodeScanner,
      appendOnlyAttachments,
      Object.hashAllUnordered(
        i18n.entries.map((entry) => Object.hash(entry.key, entry.value)),
      ),
    );
  }
}

/// Translated texts of a form field for one language
class FormFieldTranslation {
  /// Creates a [FormFieldTranslation]
  const FormFieldTranslation({this.label, this.description});

  /// Deserializes [json] into a [FormFieldTranslation]
  factory FormFieldTranslation.fromJson(dynamic json) => FormFieldTranslation(
        label: json is Map ? json['label'] : null,
        description: json is Map ? json['description'] : null,
      );

  /// Translated label, falls back to the component's label when null
  final String? label;

  /// Translated description, falls back to the component's description when null
  final String? description;

  /// Serializes this translation to json
  Map<String, dynamic> toJson() => {
        if (label != null) 'label': label,
        if (description != null) 'description': description,
      };

  @override
  String toString() =>
      'FormFieldTranslation(label: $label, description: $description)';

  @override
  bool operator ==(Object other) =>
      other is FormFieldTranslation &&
      other.label == label &&
      other.description == description;

  @override
  int get hashCode => Object.hash(label, description);
}
