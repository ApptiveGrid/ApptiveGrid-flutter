part of apptive_grid_model;

/// Model for FormData
class FormData {
  /// Creates a FormData Object
  FormData({
    required this.id,
    this.name,
    this.title,
    required this.components,
    required this.schema,
    required this.links,
    Map<Attachment, AttachmentAction>? attachmentActions,
  }) : attachmentActions = attachmentActions ?? HashMap();

  /// Deserializes [json] into a FormData Object
  FormData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        title = json['title'],
        components = (json['components'] as List?)
            ?.map<FormComponent>(
              (e) => FormComponent.fromJson(e, json['schema']),
            )
            .toList(),
        schema = json['schema'],
        links = linkMapFromJson(json['_links']),
        attachmentActions = json['attachmentActions'] != null
            ? Map.fromEntries(
                (json['attachmentActions'] as List).map((entry) {
                  final action = AttachmentAction.fromJson(entry);
                  return MapEntry(action.attachment, action);
                }).toList(),
              )
            : HashMap();

  /// Id of the Form
  final String id;

  /// Name of the Form
  final String? name;

  /// Title of the Form
  final String? title;

  /// List of [FormComponent] represented in the Form
  final List<FormComponent>? components;

  /// List of [FormActions] available for this Form
  @Deprecated('Use submitAction instead which is based on HAL links')
  List<FormAction>? get actions => links[ApptiveLinkType.submit] != null
      ? [links[ApptiveLinkType.submit]!.asFormAction]
      : null;

  /// Schema used to deserialize [components] and verify data send back to the server
  final dynamic schema;

  /// Links to actions that are used
  final LinkMap links;

  /// Actions related to Attachments that need to b performed before submitting a form
  final Map<Attachment, AttachmentAction> attachmentActions;

  /// Serializes [FormData] to json
  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (title != null) 'title': title,
        if (components != null)
          'components': components!.map((e) => e.toJson()).toList(),
        if (schema != null) 'schema': schema,
        '_links': links.toJson(),
        if (attachmentActions.isNotEmpty)
          'attachmentActions':
              attachmentActions.values.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return 'FormData(${toJson()})';
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
        title == other.title &&
        schema.toString() == other.schema.toString() &&
        f.listEquals(components, other.components) &&
        f.mapEquals(attachmentActions, other.attachmentActions) &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => toString().hashCode;
}
