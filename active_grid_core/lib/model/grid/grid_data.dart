part of active_grid_model;

class GridData {
  GridData(this.name, this.schema, this.fields, this.rows);

  factory GridData.fromJson(Map<String, dynamic> json) {
    final ids = json['fieldIds'] as List<String>;
    final names = json['fieldNames'] as List<String>;
    final schema = json['schema'];
    final fields = List<GridField>.filled(ids.length, null);
    for (var i = 0; i < ids.length; i++) {
      fields[i] = GridField(
          ids[i],
          names[i],
          dataTypeFromSchemaProperty(
              schemaProperty: schema['properties']['fields']['items'][i]));
    }
    final entries = (json['entities'] as List)
        .map((e) => GridRow.fromJson(e, fields))
        .toList();
    return GridData(json['name'], schema, fields, entries);
  }

  final String name;

  final dynamic schema;

  final List<GridField> fields;

  final List<GridRow> rows;
}
