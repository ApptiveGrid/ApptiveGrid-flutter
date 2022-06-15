part of apptive_grid_model;

/// Model for a Cell Entry in a Grid
class GridEntry {
  /// Creates a GridEntry
  GridEntry(this.field, this.data);

  /// Creates a GridEntry with value [jsonData]
  ///
  /// [field.type] is used for determining the [DataEntity] runtimeType of [data]
  factory GridEntry.fromJson(
    dynamic jsonData,
    GridField field,
  ) {
    final dataEntity = DataEntity.fromJson(json: jsonData, field: field);

    return GridEntry(field, dataEntity);
  }

  /// Column this Entry belongs to
  final GridField field;

  /// Data that is held in the cell
  final DataEntity data;

  @override
  String toString() {
    return 'GridEntry(field: $field, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridEntry && field == other.field && data == other.data;
  }

  @override
  int get hashCode => toString().hashCode;
}
