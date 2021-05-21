part of apptive_grid_model;

/// Model for FormData
class FormData {
  /// Creates a FormData Object
  FormData(this.title, this.components, this.actions, this.schema);

  /// Deserializes [json] into a FormData Object
  FormData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        components = (json['components'] as List)
            .map<FormComponent>(
                (e) => FormComponent.fromJson(e, json['schema']))
            .toList(),
        actions = (json['actions'] as List)
            .map((e) => FormAction.fromJson(e))
            .toList(), //json['actions'],
        schema = json['schema'];

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
    return Map.fromEntries(components.map((component) {
      return MapEntry(component.fieldId, component.data.schemaValue);
    }).where((element) => element.value != null));
  }

  @override
  bool operator ==(Object other) {
    return other is FormData &&
        title == other.title &&
        schema == other.schema &&
        f.listEquals(actions, other.actions) &&
        f.listEquals(components, other.components);
  }

  @override
  int get hashCode => toString().hashCode;
}
