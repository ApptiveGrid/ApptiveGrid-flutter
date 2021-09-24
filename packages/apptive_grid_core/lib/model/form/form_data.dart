part of apptive_grid_model;

/// Model for FormData
class FormData {
  /// Creates a FormData Object
  FormData({
    this.name,
    required this.title,
    required this.components,
    this.actions = const [],
    required this.schema,
  });

  /// Deserializes [json] into a FormData Object
  FormData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        title = json['title'],
        components = (json['components'] as List)
            .map<FormComponent>(
              (e) => FormComponent.fromJson(e, json['schema']),
            )
            .toList(),
        actions = json['actions'] != null
            ? (json['actions'] as List)
                .map((e) => FormAction.fromJson(e))
                .toList()
            : [],
        schema = json['schema'];

  /// Name of the Form
  final String? name;

  /// Title of the Form
  final String title;

  /// List of [FormComponent] represented in the Form
  final List<FormComponent> components;

  /// List of [FormActions] available for this Form
  final List<FormAction> actions;

  /// Schema used to deserialize [components] and verify data send back to the server
  final dynamic schema;

  /// Serializes [FormData] to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'components': components.map((e) => e.toJson()).toList(),
        'actions': actions.map((e) => e.toJson()).toList(),
        'schema': schema,
      };

  @override
  String toString() {
    return 'FormData(${toJson()})';
  }

  /// Creates a [Map] used to send this data back to a server
  Map<String, dynamic> toRequestObject() {
    return Map.fromEntries(
      components.map((component) {
        return MapEntry(component.fieldId, component.data.schemaValue);
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FormData &&
        name == other.name &&
        title == other.title &&
        schema == other.schema &&
        f.listEquals(actions, other.actions) &&
        f.listEquals(components, other.components);
  }

  @override
  int get hashCode => toString().hashCode;
}
