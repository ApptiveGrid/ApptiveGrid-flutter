import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Model for GridData
class Grid {
  /// Creates a GridData Object
  Grid({
    required this.id,
    required this.name,
    this.fields,
    this.hiddenFields,
    this.rows,
    this.key,
    this.filter,
    this.sorting,
    required this.links,
    this.embeddedForms,
  });

  /// Deserializes [json] into a [Grid] Object
  factory Grid.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'name': String name,
          'key': String? key,
          'fields': List? fields,
          'hiddenFields': List? hiddenFields,
          'entities': List? entities,
          'filter': dynamic filter,
          'sorting': dynamic sorting,
          '_links': Map<String, dynamic>? links,
          '_embedded': {
            'forms': List? embeddedForms,
          }?,
        }) {
      final parsedFields =
          fields?.map((json) => GridField.fromJson(json)).toList();
      return Grid(
        id: id,
        name: name,
        key: key,
        fields: parsedFields,
        hiddenFields:
            hiddenFields?.map((json) => GridField.fromJson(json)).toList(),
        rows: parsedFields != null
            ? entities?.map((e) => GridRow.fromJson(e, parsedFields)).toList()
            : null,
        filter: filter,
        sorting: sorting,
        links: linkMapFromJson(links),
        embeddedForms: embeddedForms?.map((e) => FormData.fromJson(e)).toList(),
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid Grid json: $json',
      );
    }
  }

  /// Id of this Grid
  final String id;

  /// Name of the Grid
  final String name;

  /// Key of the Grid
  final String? key;

  /// Filter applied to this GridView. If this is not null the Grid is actually a GridView
  final dynamic filter;

  /// Sorting applied to this GridView. If this is not null the Grid is actually a GridView
  final dynamic sorting;

  /// List of [GridField] representing the Columns the Grid has
  final List<GridField>? fields;

  /// List of [GridField]s that are hidden in this View
  final List<GridField>? hiddenFields;

  /// Rows of the Grid
  final List<GridRow>? rows;

  /// Links for actions relevant to this grid
  final LinkMap links;

  /// List of [FormData] that is embedded in this.
  final List<FormData>? embeddedForms;

  /// Serializes [Grid] into a json Map
  Map<String, dynamic> toJson() {
    final jsonMap = {
      'id': id,
      'name': name,
      if (key != null) 'key': key,
      if (rows != null) 'entities': rows!.map((e) => e.toJson()).toList(),
      if (fields != null) 'fields': fields!.map((e) => e.toJson()).toList(),
      if (hiddenFields != null)
        'hiddenFields': hiddenFields!.map((e) => e.toJson()).toList(),
      if (filter != null) 'filter': filter,
      if (sorting != null) 'sorting': sorting,
      '_links': links.toJson(),
    };

    if (embeddedForms != null) {
      final embeddedMap =
          jsonMap['_embedded'] as Map<String, dynamic>? ?? <String, dynamic>{};
      embeddedMap['forms'] = embeddedForms?.map((e) => e.toJson()).toList();

      jsonMap['_embedded'] = embeddedMap;
    }

    return jsonMap;
  }

  @override
  String toString() {
    return 'Grid(id: $id, name: $name, key: $key, fields: $fields, hiddenFields: $hiddenFields, rows: $rows, filter: $filter, sorting: $sorting, links: $links, embeddedForms: $embeddedForms)';
  }

  @override
  bool operator ==(Object other) {
    return other is Grid &&
        id == other.id &&
        name == other.name &&
        key == other.key &&
        f.listEquals(fields, other.fields) &&
        f.listEquals(hiddenFields, other.hiddenFields) &&
        f.listEquals(rows, other.rows) &&
        filter.toString() == other.filter.toString() &&
        sorting.toString() == other.sorting.toString() &&
        f.mapEquals(links, other.links) &&
        f.listEquals(embeddedForms, other.embeddedForms);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        key,
        fields,
        hiddenFields,
        rows,
        filter,
        sorting,
        links,
        embeddedForms,
      );
}
