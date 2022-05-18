part of apptive_grid_model;

/// Model representing a Field in a Grid
class GridField {
  /// Creates a GridField
  GridField({
    required this.id,
    this.key,
    required this.name,
    required this.type,
    this.links = const {},
    this.schema,
  });

  /// Create a Gridfield from [json]
  factory GridField.fromJson(Map<String, dynamic> json) {
    return GridField(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      type: DataType.values
          .firstWhere((type) => type.backendName == json['type']['name']),
      links: linkMapFromJson(json['links']),
      schema: json['schema'],
    );
  }

  /// id of the field
  final String id;

  /// A key associated with this field
  final String? key;

  /// name of the field
  final String name;

  /// type of the field
  final DataType type;

  /// Links that are associated with this GridField
  final LinkMap links;

  /// json Schema of this GridField
  final dynamic schema;

  @override
  String toString() {
    return 'GridField(id: $id, name: $name, type: $type}';
  }

  /// Converts this GridField to a json representation
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (key != null) 'key': key,
        if (schema != null) 'schema': schema,
        'links': links.toJson(),
        'type': {'name': type.backendName},
      };

  @override
  bool operator ==(Object other) {
    return other is GridField &&
        id == other.id &&
        name == other.name &&
        key == other.key &&
        type == other.type &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => toString().hashCode;
}
