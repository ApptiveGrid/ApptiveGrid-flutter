import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Model for a Space
class Space {
  /// Creates a new Space Model with a certain [id] and [name]
  /// [gridUris] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  Space({
    required this.id,
    required this.name,
    required this.links,
    this.embeddedGrids,
    this.key,
    this.category,
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
        links: linkMapFromJson(json['_links']),
        embeddedGrids: (json['_embedded']?['grids'] as List?)
            ?.map((e) => Grid.fromJson(e))
            .toList(),
        key: json['key'],
        category: json['belongsTo'],
      );
    }
  }

  /// Name of this space
  final String name;

  /// Id of this space
  final String id;

  /// Links for relevant actions for this Space
  final LinkMap links;

  /// The key of this space
  final String? key;

  /// The category this space belongs to
  final String? category;

  /// A List of [Grid]s that are embedded in this Space
  final List<Grid>? embeddedGrids;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() {
    final jsonMap = {
      'name': name,
      'id': id,
      'type': 'space',
      '_links': links.toJson(),
      if (key != null) 'key': key,
      if (category != null) 'belongsTo': category,
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
    return 'Space(name: $name, id: $id, key: $key, category: $category, links: $links, embeddedGrids: $embeddedGrids)';
  }

  @override
  bool operator ==(Object other) {
    return other is Space &&
        id == other.id &&
        name == other.name &&
        key == other.key &&
        category == other.category &&
        f.mapEquals(links, other.links) &&
        f.listEquals(embeddedGrids, other.embeddedGrids);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        key,
        category,
        links,
        embeddedGrids,
      );
}

/// A [Space] shared with a [User]
class SharedSpace extends Space {
  /// Creates a new Space Model with a certain [id] and [name]
  /// [gridUris] is [List<GridUri>] pointing to the [Grid]s contained in this [Space]
  /// [realSpace] points to the Uri of the actual [Space]
  SharedSpace({
    required this.realSpace,
    required super.id,
    required super.name,
    required super.links,
    super.embeddedGrids,
    super.key,
    super.category,
  });

  /// Deserializes [json] into a [Space] Object
  factory SharedSpace.fromJson(Map<String, dynamic> json) {
    return SharedSpace(
      name: json['name'],
      id: json['id'],
      realSpace: Uri.parse(json['realSpace']),
      links: linkMapFromJson(json['_links']),
      embeddedGrids: (json['_embedded']?['grids'] as List?)
          ?.map((e) => Grid.fromJson(e))
          .toList(),
      key: json['key'],
      category: json['belongsTo'],
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
    return 'SharedSpace(name: $name, id: $id, key: $key, category: $category, realSpace: ${realSpace.toString()}, links: $links, embeddedGrids: $embeddedGrids)';
  }

  @override
  bool operator ==(Object other) {
    return other is SharedSpace &&
        id == other.id &&
        name == other.name &&
        realSpace == other.realSpace &&
        key == other.key &&
        category == other.category &&
        f.mapEquals(links, other.links) &&
        f.listEquals(embeddedGrids, other.embeddedGrids);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        realSpace,
        key,
        category,
        links,
        embeddedGrids,
      );
}
