part of apptive_grid_model;

/// A Uri representation used for performing Grid based Api Calls
class GridUri extends ApptiveGridUri {
  /// Creates a new [GridUri] based on known ids for [user], [space] and [grid]
  GridUri({
    required String user,
    required String space,
    required String grid,
    String? view,
  }) : super._(
          Uri(
            pathSegments: [
              ...'/api/users/$user/spaces/$space/grids/$grid'.split('/'),
              if (view != null) ...['views', view]
            ],
          ),
          UriType.grid,
        );

  /// Creates a new [GridUri] based on a string [uri]
  /// Main usage of this is for [GridUri] retrieved through other Api Calls
  /// If the Uri passed in is a [GridViewUri] it will return that
  GridUri.fromUri(String uri) : super.fromUri(uri, UriType.grid);
}

/// Model for GridData
class Grid {
  /// Creates a GridData Object
  Grid({
    required this.id,
    required this.name,
    this.schema,
    this.fields,
    this.rows,
    this.filter,
    this.sorting,
    required this.links,
    this.embeddedForms,
  });

  /// Deserializes [json] into a [Grid] Object
  factory Grid.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final ids = json['fieldIds'] as List?;
    final names = json['fieldNames'] as List?;
    final schema = json['schema'];
    final fields = ids != null && names != null
        ? List<GridField>.generate(
            ids.length,
            (i) => GridField(
              ids[i],
              names[i],
              dataTypeFromSchemaProperty(
                schemaProperty: schema['properties']['fields']['items'][i],
              ),
            ),
          )
        : null;
    final entries = fields != null
        ? (json['entities'] as List)
            .map((e) => GridRow.fromJson(e, fields, schema))
            .toList()
        : null;
    final filter = json['filter'];
    final sorting = json['sorting'];
    return Grid(
      id: id,
      name: json['name'],
      schema: schema,
      fields: fields,
      rows: entries,
      filter: filter,
      sorting: sorting,
      links: linkMapFromJson(json['_links']),
      embeddedForms: (json['_embedded']?['forms'] as List?)
          ?.map((e) => FormData.fromJson(e))
          .toList(),
    );
  }

  /// Id of this Grid
  final String id;

  /// Name of the Grid
  final String name;

  /// Schema used for deserializing and validating data send back to the server
  final dynamic schema;

  /// Filter applied to this GridView. If this is not null the Grid is actually a GridView
  final dynamic filter;

  /// Sorting applied to this GridView. If this is not null the Grid is actually a GridView
  final dynamic sorting;

  /// List of [GridField] representing the Columns the Grid has
  final List<GridField>? fields;

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
      'schema': schema,
      if (rows != null) 'entities': rows!.map((e) => e.toJson()).toList(),
      if (fields != null) 'fieldIds': fields!.map((e) => e.id).toList(),
      if (fields != null) 'fieldNames': fields!.map((e) => e.name).toList(),
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
    return 'Grid(id: $id, name: $name, fields: $fields, rows: $rows, filter: $filter, sorting: $sorting, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return other is Grid &&
        id == other.id &&
        name == other.name &&
        schema.toString() == other.schema.toString() &&
        f.listEquals(fields, other.fields) &&
        f.listEquals(rows, other.rows) &&
        filter.toString() == other.filter.toString() &&
        sorting.toString() == other.sorting.toString() &&
        f.mapEquals(links, other.links) &&
        f.listEquals(embeddedForms, other.embeddedForms);
  }

  @override
  int get hashCode => toString().hashCode;
}
