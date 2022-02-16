part of apptive_grid_model;

/// A Uri representation used for performing Space based Api Calls
class SpaceUri extends ApptiveGridUri {
  /// Creates a new [SpaceUri] based on known ids for [user] and [space]
  SpaceUri({
    required String user,
    required String space,
  }) : super._(
          Uri(
            path: '/api/users/$user/spaces/$space',
          ),
          UriType.space,
        );

  /// Creates a new [SpaceUri] based on a string [uri]
  /// Main usage of this is for [SpaceUri] retrieved through other Api Calls
  SpaceUri.fromUri(String uri) : super.fromUri(uri, UriType.space);
}

/// Model for a Space
class Space {
  /// Creates a new Space Model with a certain [id] and [name]
  /// [grids] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  Space({
    required this.id,
    required this.name,
    required this.grids,
  });

  /// Deserializes [json] into a [Space] Object
  Space.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        grids =
            (json['gridUris'] as List).map((e) => GridUri.fromUri(e)).toList();

  /// Name of this space
  final String name;

  /// Id of this space
  final String id;

  /// [GridUri]s pointing to [Grid]s contained in this [Space]
  final List<GridUri> grids;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'gridUris': grids.map((e) => e.uri.toString()).toList(),
      };

  @override
  String toString() {
    return 'Space(name: $name, id: $id, spaces: ${grids.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is Space &&
        id == other.id &&
        name == other.name &&
        f.listEquals(grids, other.grids);
  }

  @override
  int get hashCode => toString().hashCode;
}
