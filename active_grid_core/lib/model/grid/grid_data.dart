part of active_grid_model;

/// Model for GridData
class GridData {
  /// Creates a GridData Object
  GridData(this.name, this.schema, this.fields, this.rows);

  /// Deserializes [json] into a GridData Object
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

  /// Name of the Form
  final String name;

  /// Schema used for deserializing and validating data send back to the server
  final dynamic schema;

  /// List of [GridField] representing the Columns the Grid has
  final List<GridField> fields;

  /// Rows of the Grid
  final List<GridRow> rows;

  /// Serializes [GridData] into a json Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'schema': schema,
        'entities': rows.map((e) => e.toJson()).toList(),
        'fieldIds': fields.map((e) => e.id).toList(),
        'fieldNames': fields.map((e) => e.name).toList(),
      };

  @override
  String toString() {
    return 'GridData(name: $name, fields: $fields, rows: $rows)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridData &&
        name == other.name &&
        schema == other.schema &&
        f.listEquals(fields, other.fields) &&
        f.listEquals(rows, other.rows);
  }

  @override
  int get hashCode => toString().hashCode;
}
