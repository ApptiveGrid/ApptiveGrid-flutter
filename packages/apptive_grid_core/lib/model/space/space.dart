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
  /// [gridUris] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  Space({
    required this.id,
    required this.name,
    this.gridUris,
    required this.links,
  });

  /// Deserializes [json] into a [Space] Object
  factory Space.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type == 'sharedSpace') {
      return SharedSpace.fromJson(json);
    } else {
      return Space(
        name: json['name'],
        id: json['id'],
        gridUris: (json['gridUris'] as List?)?.map((e) => GridUri.fromUri(e)).toList(),
        links: linkMapFromJson(json['_links']),
      );
    }
  }

  /// Name of this space
  final String name;

  /// Id of this space
  final String id;

  /// [GridUri]s pointing to [Grid]s contained in this [Space]
  final List<GridUri>? gridUris;

  final LinkMap links;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
    if (gridUris != null)
        'gridUris': gridUris!.map((e) => e.uri.toString()).toList(),
    'type': 'space',
    '_links': links.toJson(),
      };

  @override
  String toString() {
    return 'Space(name: $name, id: $id, gridUris: ${gridUris.toString()}, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return other is Space &&
        id == other.id &&
        name == other.name &&
        f.listEquals(gridUris, other.gridUris) &&
    f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => toString().hashCode;
}

class SharedSpace extends Space {
  /// Creates a new Space Model with a certain [id] and [name]
  /// [gridUris] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  SharedSpace({
    required String id,
    required String name,
    required this.realSpace,
    List<GridUri>? gridUris,
    required LinkMap links,
  }) : super(id: id, name: name, gridUris: gridUris, links: links);

  /// Deserializes [json] into a [Space] Object
  factory SharedSpace.fromJson(Map<String, dynamic> json) {
    return SharedSpace(
      name: json['name'],
      id: json['id'],
      realSpace: Uri.parse(json['realSpace']),
      gridUris: (json['gridUris'] as List?)?.map((e) => GridUri.fromUri(e)).toList(),
      links: linkMapFromJson(json['_links']),
    );
  }

  final Uri realSpace;

  @override
  Map<String, dynamic> toJson() {
    final superJson = super.toJson();
    superJson['type'] = 'sharedSpace';
    superJson['realSpace'] = realSpace.toString();
    return superJson;
  }

  @override
  String toString() {
    return 'SharedSpace(name: $name, id: $id, realSpace: ${realSpace.toString()} gridUris: ${gridUris.toString()}, links: $links)';
  }


  @override
  bool operator ==(Object other) {
    return other is SharedSpace &&
        id == other.id &&
        name == other.name &&
        f.listEquals(gridUris, other.gridUris) &&
        realSpace == other.realSpace &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => toString().hashCode;
}
