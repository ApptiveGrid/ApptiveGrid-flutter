part of active_grid_model;

class FormData {
  final String title;
  final List<FormComponent> components;
  final List<FormAction> actions;
  final dynamic schema;

  FormData(this.title, this.components, this.actions, this.schema);

  FormData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        components = (json['components'] as List).map<FormComponent>((e) => FormComponent.fromJson(e)).toList(),
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
    final schemaProperties = schema['properties'];
    return Map.fromEntries(components.map((component) {
      final valueType = schemaProperties[component.property]['type'];
      dynamic value;
      switch(valueType) {
        case 'integer':
          value = component.value != null ? int.parse(component.value): null;
          break;
        case 'boolean':
          value = component.value;
          break;
        case 'string':
          final format = schemaProperties[component.property]['format'];
          switch(format) {
            case 'date-time':
              value = (component.value as DateTime)?.toIso8601String();
              break;
            case 'date':
              value = component.value != null ? DateFormat("yyyy-MM-dd").format(component.value as DateTime) : null;
              break;
            default:
              value = component.value;
              break;
          }
      }
      return MapEntry(
        component.property,
        value
      );
    }));
  }
}
