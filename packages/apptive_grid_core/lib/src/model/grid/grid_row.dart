import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Model for a Row in a Grid
class GridRow {
  /// Creates a GridRow
  GridRow({
    required this.id,
    required this.entries,
    required this.links,
  });

  /// Creates a GridRow from [json]
  ///
  /// [fields] is used to map the correct type of [entries]
  factory GridRow.fromJson(
    dynamic json,
    List<GridField> fields,
  ) {
    final data = json['fields'] as List;
    final entries = List<GridEntry>.generate(
      data.length,
      (i) => GridEntry.fromJson(data[i], fields[i]),
    );
    return GridRow(
      id: json['_id'],
      entries: entries,
      links: linkMapFromJson(
        json['_links'],
      ),
    );
  }

  /// id of the row
  final String id;

  /// List of entries
  final List<GridEntry> entries;

  /// Links for actions related to this [GridRow]
  final LinkMap links;

  /// Serializes a row to a Map
  ///
  /// in the format used by the Server for [GridData.fromJson] and [GridData.toJson]
  Map<String, dynamic> toJson() => {
        '_id': id,
        'fields': entries.map((e) => e.data.schemaValue).toList(),
        '_links': links.toJson(),
      };

  @override
  String toString() {
    return 'GridRow(id: $id, entries: $entries, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridRow &&
        id == other.id &&
        f.listEquals(entries, other.entries) &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(id, entries, links);
}
