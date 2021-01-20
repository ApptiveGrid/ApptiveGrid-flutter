part of active_grid_model;

class GridRow {
  GridRow(this.id, this.entries);

  factory GridRow.fromJson(dynamic json, List<GridField> fields) {
    final data = json['fields'] as List;
    final entries = List<GridEntry>.filled(data.length, null);
    for (var i = 0; i < data.length; i++) {
      entries[i] = GridEntry.fromJson(data[i], fields[i]);
    }
    return GridRow(json['_id'], entries);
  }
  final String id;

  final List<GridEntry> entries;

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
