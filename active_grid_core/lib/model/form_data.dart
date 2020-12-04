part of active_grid_model;

class FormData {
  final String title;
  final List<FormComponent> components;
  final List<FormAction> actions;
  final dynamic schema;

  FormData(this.title, this.components, this.actions, this.schema);

  FormData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        components = (json['components'] as List).map<FormComponent>((e) => FormComponent.fromJson(e, json['schema'])).toList(),
        actions = (json['actions'] as List).map((e) => FormAction.fromJson(e)).toList(),//json['actions'],
        schema = json['schema'];

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'components': components.map((e) => e.toJson()),
        'actions': actions.map((e) => e.toJson()),
        'schema': schema,
      };

  @override
  String toString() {
    return 'FormData(${toJson()})';
  }

  Map<String, dynamic> toRequestObject() {
    return Map.fromEntries(components.map((component) {
      return MapEntry(
        component.property,
        component.schemaValue
      );
    }));
  }
}
