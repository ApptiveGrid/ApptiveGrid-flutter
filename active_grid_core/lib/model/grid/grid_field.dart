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
}
