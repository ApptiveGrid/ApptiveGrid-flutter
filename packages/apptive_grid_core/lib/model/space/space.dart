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
    this.embeddedGrids,
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
        gridUris: (json['gridUris'] as List?)
            ?.map((e) => GridUri.fromUri(e))
            .toList(),
        links: linkMapFromJson(json['_links']),
        embeddedGrids: (json['_embedded']?['grids'] as List?)
            ?.map((e) => Grid.fromJson(e))
            .toList(),
      );
    }
  }

  /// Name of this space
  final String name;

  /// Id of this space
  final String id;

  /// [GridUri]s pointing to [Grid]s contained in this [Space]
  final List<GridUri>? gridUris;

  /// Links for relavant actions for this Space
  final LinkMap links;

  /// A List of [Grid]s that are embedded in this Space
  final List<Grid>? embeddedGrids;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() {
    final jsonMap = {
      'name': name,
      'id': id,
      if (gridUris != null)
        'gridUris': gridUris!.map((e) => e.uri.toString()).toList(),
      'type': 'space',
      '_links': links.toJson(),
    };

    if (embeddedGrids != null) {
      final embeddedMap =
          jsonMap['_embedded'] as Map<String, dynamic>? ?? <String, dynamic>{};
      embeddedMap['grids'] = embeddedGrids?.map((e) => e.toJson()).toList();

      jsonMap['_embedded'] = embeddedMap;
    }

    return jsonMap;
  }

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

/// A [Space] shared with a [User]
class SharedSpace extends Space {
  /// Creates a new Space Model with a certain [id] and [name]
  /// [gridUris] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  /// [realSpace] points to the Uri of the actual [Space]
  SharedSpace({
    required String id,
    required String name,
    required this.realSpace,
    List<GridUri>? gridUris,
    required LinkMap links,
    List<Grid>? embeddedGrids,
  }) : super(
          id: id,
          name: name,
          gridUris: gridUris,
          links: links,
          embeddedGrids: embeddedGrids,
        );

  /// Deserializes [json] into a [Space] Object
  factory SharedSpace.fromJson(Map<String, dynamic> json) {
    return SharedSpace(
      name: json['name'],
      id: json['id'],
      realSpace: Uri.parse(json['realSpace']),
      gridUris:
          (json['gridUris'] as List?)?.map((e) => GridUri.fromUri(e)).toList(),
      links: linkMapFromJson(json['_links']),
      embeddedGrids: (json['_embedded']?['grids'] as List?)
          ?.map((e) => Grid.fromJson(e))
          .toList(),
    );
  }

  /// Uri of the [Space] that is shared
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
