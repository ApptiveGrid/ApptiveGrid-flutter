part of apptive_grid_model;

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
    return FormData(
      id: id,
      name: name,
      title: title,
      description: description,
      components: components,
      fields: fields,
      links: links,
      attachmentActions: attachmentActions,
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

  /// Serializes [FormData] to json
  Map<String, dynamic> toJson() => {
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
      };

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
