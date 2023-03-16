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
  }) : attachmentActions = attachmentActions ?? HashMap();

  /// Deserializes [json] into a FormData Object
  factory FormData.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final title = json['title'];
    final description = json['description'];
    final fields = (json['fields'] as List?)
            ?.map((json) => GridField.fromJson(json))
            .toList() ??
        [];
    final components = (json['components'] as List?)
        ?.map<FormComponent>(
          (e) => FormComponent.fromJson(e, fields),
        )
        .toList();
    final links = linkMapFromJson(json['_links']);
    final attachmentActions = json['attachmentActions'] != null
        ? Map.fromEntries(
            (json['attachmentActions'] as List).map((entry) {
              final action = AttachmentAction.fromJson(entry);
              return MapEntry(action.attachment, action);
            }).toList(),
          )
        : <Attachment, AttachmentAction>{};
    final properties = json['properties'] != null
        ? FormDataProperties.fromJson(json['properties'])
        : null;
    return FormData(
      id: id,
      name: name,
      title: title,
      description: description,
      components: components,
      fields: fields,
      links: links,
      attachmentActions: attachmentActions,
      properties: properties,
    );
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
    };
  }

  @override
  String toString() {
    return 'FormData(id: $id, name: $name, title: $title, description: $description, components: $components, fields: $fields, links: $links, attachmentActions: $attachmentActions)';
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

/// Additional properties for the [FormData]
class FormDataProperties {
  /// Creates a FormDataProperties Object
  FormDataProperties({
    this.successTitle,
    this.successMessage,
    this.buttonTitle,
    this.reloadAfterSubmit,
    this.afterSubmitAction,
  });

  /// Deserializes [json] into a FormDataProperties Object
  factory FormDataProperties.fromJson(Map<String, dynamic> json) =>
      FormDataProperties(
        successTitle: json['successTitle'],
        successMessage: json['successMessage'],
        buttonTitle: json['buttonTitle'],
        reloadAfterSubmit: json['reloadAfterSubmit'],
        afterSubmitAction: json['afterSubmitAction'] != null
            ? AfterSubmitAction.fromJson(json['afterSubmitAction'])
            : null,
      );

  /// Custom title for a successfull submission
  final String? successTitle;

  /// Custom message for a successfull submission
  final String? successMessage;

  /// Custom title for the submit button
  final String? buttonTitle;

  /// Flag for reloading and keeping the form open after submission
  final bool? reloadAfterSubmit;

  /// Custom message for a submitting an additional answer
  final AfterSubmitAction? afterSubmitAction;

  /// Serializes [FormDataProperties] to json
  Map<String, dynamic> toJson() => {
        if (successTitle != null) 'successTitle': successTitle,
        if (successMessage != null) 'successMessage': successMessage,
        if (buttonTitle != null) 'buttonTitle': buttonTitle,
        if (reloadAfterSubmit != null) 'reloadAfterSubmit': reloadAfterSubmit,
        if (afterSubmitAction != null)
          'afterSubmitAction': afterSubmitAction!.toJson(),
      };

  @override
  String toString() {
    return 'FormDataProperties(successTitle: $successTitle, successMessage: $successMessage, buttonTitle: $buttonTitle, reloadAfterSubmit: $reloadAfterSubmit, afterSubmitAction: $afterSubmitAction)';
  }

  @override
  bool operator ==(Object other) {
    return other is FormDataProperties &&
        successTitle == other.successTitle &&
        successMessage == other.successMessage &&
        buttonTitle == other.buttonTitle &&
        reloadAfterSubmit == other.reloadAfterSubmit &&
        afterSubmitAction == other.afterSubmitAction;
  }

  @override
  int get hashCode => Object.hash(
        successTitle,
        successMessage,
        buttonTitle,
        reloadAfterSubmit,
        afterSubmitAction,
      );
}

/// The AfterSubmitAction class represents an action to be taken after a form
/// is submitted.
class AfterSubmitAction {
  /// Creates a new instance of the AfterSubmitAction class from the given JSON
  /// data.
  factory AfterSubmitAction.fromJson(dynamic json) => AfterSubmitAction(
        type: AfterSubmitActionType.values
            .firstWhere((type) => type.name == json['action']),
        buttonTitle: json['buttonTitle'],
        trigger: json['trigger'] != null
            ? AfterSubmitActionaTrigger.values
                .firstWhere((trigger) => trigger.name == json['trigger'])
            : null,
        delay: json['delay'],
        targetUrl:
            json['targetUrl'] != null ? Uri.parse(json['targetUrl']) : null,
      );

  /// Creates a new instance of the AfterSubmitAction class.
  const AfterSubmitAction({
    required this.type,
    this.buttonTitle,
    this.trigger,
    this.delay,
    this.targetUrl,
  });

  /// The type of the action to be taken after form submission.
  final AfterSubmitActionType type;

  /// The title of the button that was clicked to trigger the action, if
  /// applicable.
  final String? buttonTitle;

  /// The trigger that caused the action to be taken, if applicable.
  final AfterSubmitActionaTrigger? trigger;

  /// The delay (in seconds) before the action is taken, if applicable.
  final int? delay;

  /// The URL to redirect to after the action is taken, if applicable.
  final Uri? targetUrl;

  /// Converts the AfterSubmitAction to a JSON.
  Map<String, dynamic> toJson() {
    return {
      'action': type.name,
      if (buttonTitle != null) 'buttonTitle': buttonTitle,
      if (trigger != null) 'trigger': trigger!.name,
      if (delay != null) 'delay': delay,
      if (targetUrl != null) 'targetUrl': targetUrl!.toString(),
    };
  }

  @override
  String toString() {
    return 'AfterSubmitAction(type: $type, buttonTitle: $buttonTitle, trigger: $trigger, delay: $delay, targetUrl: $targetUrl)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AfterSubmitAction &&
          other.type == type &&
          other.buttonTitle == buttonTitle &&
          other.trigger == trigger &&
          other.delay == delay &&
          other.targetUrl == targetUrl;

  @override
  int get hashCode => Object.hash(
        type,
        buttonTitle,
        trigger,
        delay,
        targetUrl,
      );
}

/// The type of an AfterSubmitAction.
enum AfterSubmitActionType {
  /// An additional answer will be requested from the user.
  additionalAnswer,

  /// A redirect will happen after the form is submitted.
  redirect,

  /// No action will be taken.
  none,
}

/// The trigger of an AfterSubmitAction.
enum AfterSubmitActionaTrigger {
  /// The action was triggered by a button click.
  button,

  /// The action was triggered automatically.
  auto,
}
