part of apptive_grid_model;

/// A Uri representation used for performing Grid based Api Calls
class GridUri extends ApptiveGridUri {
  /// Creates a new [GridUri] based on known ids for [user], [space] and [grid]
  GridUri({
    required this.user,
    required this.space,
    required this.grid,
  });

  /// Creates a new [GridUri] based on a string [uri]
  /// Main usage of this is for [GridUri] retrieved through other Api Calls
  /// If the Uri passed in is a [GridViewUri] it will return that
  factory GridUri.fromUri(String uri) {
    try {
      // Try to parse as GridViewUri
      return GridViewUri.fromUri(uri);
    } on ArgumentError {
      final regex = r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)\b';
      final matches = RegExp(regex).allMatches(uri);
      if (matches.isEmpty || matches.elementAt(0).groupCount != 3) {
        throw ArgumentError('Could not parse GridUri $uri');
      }
      final match = matches.elementAt(0);
      return GridUri(
          user: match.group(1)!, space: match.group(2)!, grid: match.group(3)!);
    }
  }

  /// Id of the User that owns this Grid
  final String user;

  /// Id of the Space this Grid is in
  final String space;

  /// Id of the Grid this [GridUri] is representing
  final String grid;

  @override
  String toString() {
    return 'GridUri(user: $user, space: $space grid: $grid)';
  }

  /// Generates the uriString used for ApiCalls referencing this
  @override
  String get uriString => '/api/users/$user/spaces/$space/grids/$grid';

  @override
  bool operator ==(Object other) {
    return other is GridUri &&
        grid == other.grid &&
        user == other.user &&
        space == other.space;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Model for GridData
class Grid {
  /// Creates a GridData Object
  Grid(this.name, this.schema, this.fields, this.rows, {this.filter});

  /// Deserializes [json] into a [Grid] Object
  factory Grid.fromJson(Map<String, dynamic> json) {
    final ids = json['fieldIds'] as List;
    final names = json['fieldNames'] as List;
    final schema = json['schema'];
    final fields = List<GridField>.generate(
        ids.length,
        (i) => GridField(
            ids[i],
            names[i],
            dataTypeFromSchemaProperty(
                schemaProperty: schema['properties']['fields']['items'][i])));
    final entries = (json['entities'] as List)
        .map((e) => GridRow.fromJson(e, fields, schema))
        .toList();
    final filter = json['filter'];
    return Grid(json['name'], schema, fields, entries, filter: filter);
  }

  /// Name of the Form
  final String name;

  /// Schema used for deserializing and validating data send back to the server
  final dynamic schema;

  /// Filter applied to this GridView. If this is not null the Grid is actually a GridView
  final dynamic filter;

  /// List of [GridField] representing the Columns the Grid has
  final List<GridField> fields;

  /// Rows of the Grid
  final List<GridRow> rows;

  /// Serializes [Grid] into a json Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'schema': schema,
        'entities': rows.map((e) => e.toJson()).toList(),
        'fieldIds': fields.map((e) => e.id).toList(),
        'fieldNames': fields.map((e) => e.name).toList(),
        if (filter != null) 'filter': filter,
      };

  @override
  String toString() {
    return 'GridData(name: $name, fields: $fields, rows: $rows, filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return other is Grid &&
        name == other.name &&
        schema == other.schema &&
        f.listEquals(fields, other.fields) &&
        f.listEquals(rows, other.rows);
  }

  @override
  int get hashCode => toString().hashCode;
}
