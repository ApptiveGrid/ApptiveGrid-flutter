import 'dart:collection';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Model for FormData
class FormData {
  /// Creates a FormData Object
  FormData({
    required this.id,
    this.name,
    this.title,
    this.description,
    required this.components,
    required this.fields,
    required this.links,
    Map<Attachment, AttachmentAction>? attachmentActions,
    this.properties,
    this.fieldProperties = const [],
  }) : attachmentActions = attachmentActions ?? HashMap();

  /// Deserializes [json] into a FormData Object
  factory FormData.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'name': String? name,
          'title': String? title,
          'description': String? description,
          'fields': List? fields,
          '_links': Map<String, dynamic>? links,
          'attachmentActions': List? attachmentActions,
          'properties': Map<String, dynamic>? properties,
          'fieldProperties': Map<String, dynamic>? fieldProperties,
          'components': List? components,
        }) {
      final fieldsParsed =
          fields?.map((json) => GridField.fromJson(json)).toList() ?? [];
      final List<FormFieldProperties> fieldPropertiesParsed = [];
      if (fieldProperties != null) {
        for (final field in fieldsParsed) {
          final propertiesJson = fieldProperties[field.id];
          if (propertiesJson != null) {
            fieldPropertiesParsed.add(
              FormFieldProperties.fromJson(
                json: propertiesJson,
                field: field,
              ),
            );
          }
        }
      }
      return FormData(
        id: id,
        name: name,
        title: title,
        description: description,
        components: components
            ?.map<FormComponent>(
              (e) => FormComponent.fromJson(
                e,
                fieldsParsed,
                additionalProperties: fieldPropertiesParsed,
              ),
            )
            .toList(),
        fields: fieldsParsed,
        links: linkMapFromJson(links),
        attachmentActions: attachmentActions != null
            ? Map.fromEntries(
                attachmentActions.map((entry) {
                  final action = AttachmentAction.fromJson(entry);
                  return MapEntry(action.attachment, action);
                }).toList(),
              )
            : {},
        properties:
            properties != null ? FormDataProperties.fromJson(properties) : null,
        fieldProperties: fieldPropertiesParsed,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid FormDataProperties json: $json',
      );
    }
  }

  /// Id of the Form
  final String id;

  /// Name of the Form
  final String? name;

  /// Title of the Form
  final String? title;

  /// Description of the Form
  final String? description;

  /// List of [FormComponent]s represented in the Form
  final List<FormComponent>? components;

  /// List of [GridField]s represented in the Form
  final List<GridField>? fields;

  /// Links to actions that are used
  final LinkMap links;

  /// Actions related to Attachments that need to b performed before submitting a form
  final Map<Attachment, AttachmentAction> attachmentActions;

  /// Custom title for a successfull submission
  final FormDataProperties? properties;

  /// Additional properties of the fields
  final List<FormFieldProperties> fieldProperties;

  /// Serializes [FormData] to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (components != null)
        'components': components!.map((e) => e.toJson()).toList(),
      if (fields != null)
        'fields': fields!.map((field) => field.toJson()).toList(),
      '_links': links.toJson(),
      if (attachmentActions.isNotEmpty)
        'attachmentActions':
            attachmentActions.values.map((e) => e.toJson()).toList(),
      if (properties != null) 'properties': properties!.toJson(),
      'fieldProperties': Map.fromEntries(
        fieldProperties.map((e) => MapEntry(e.fieldId, e.toJson())),
      ),
    };
  }

  @override
  String toString() {
    return 'FormData(id: $id, name: $name, title: $title, description: $description, components: $components, fields: $fields, links: $links, attachmentActions: $attachmentActions, properties: $properties, fieldProperties: $fieldProperties)';
  }

  /// Creates a [Map] used to send this data back to a server
  Map<String, dynamic> toRequestObject() {
    return Map.fromEntries(
      components?.map((component) {
            return MapEntry(component.fieldId, component.data.schemaValue);
          }) ??
          [],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FormData &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        title == other.title &&
        properties == other.properties &&
        f.listEquals(fields, other.fields) &&
        f.listEquals(components, other.components) &&
        f.listEquals(fieldProperties, other.fieldProperties) &&
        f.mapEquals(attachmentActions, other.attachmentActions) &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        title,
        fields,
        components,
        attachmentActions,
        links,
      );
}
