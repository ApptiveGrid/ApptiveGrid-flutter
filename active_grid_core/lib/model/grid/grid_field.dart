part of active_grid_model;

/// Model representing a Field in a Grid
class GridField {
  /// Creates a GridField
  GridField(this.id, this.name, this.type);

  /// id of the field
  final String id;

  /// name of the field
  final String name;

  /// type of the field
  final DataType type;

  @override
  String toString() {
    return 'GridField(id: $id, name: $name, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    return other is GridField &&
        id == other.id &&
        name == other.name &&
        type == other.type;
  }

  @override
  int get hashCode => toString().hashCode;
}
