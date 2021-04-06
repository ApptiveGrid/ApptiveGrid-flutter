part of active_grid_model;

/// Model for a Row in a Grid
class GridRow {
  /// Creates a GridRow
  GridRow(this.id, this.entries);

  /// Creates a GridRow from [json]
  ///
  /// [fields] is used to map the correct type of [entries]
  factory GridRow.fromJson(
      dynamic json, List<GridField> fields, dynamic schema) {
    final data = json['fields'] as List;
    final entries = List<GridEntry>.generate(
        data.length,
        (i) => GridEntry.fromJson(
            data[i], fields[i], schema['properties']['fields']['items'][i]));
    return GridRow(json['_id'], entries);
  }

  /// id of the row
  final String id;

  /// List of entries
  final List<GridEntry> entries;

  /// Serializes a row to a Map
  ///
  /// in the format used by the Server for [GridData.fromJson] and [GridData.toJson]
  Map<String, dynamic> toJson() => {
        '_id': id,
        'fields': entries.map((e) => e.data.schemaValue).toList(),
      };

  @override
  String toString() {
    return 'GridRow(id: $id, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridRow &&
        id == other.id &&
        f.listEquals(entries, other.entries);
  }

  @override
  int get hashCode => toString().hashCode;
}
