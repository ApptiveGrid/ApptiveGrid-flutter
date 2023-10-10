import 'dart:ui';

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
    this.color,
    this.icon,
    this.iconSet,
  });

  /// Deserializes [json] into a [Space] Object
  factory Space.fromJson(Map<String, dynamic> json) => switch (json) {
        {'type': 'sharedSpace'} => SharedSpace.fromJson(json),
        {
          'id': String id,
          'name': String name,
          'key': String? key,
          'belongsTo': String? category,
          'color': String? color,
          'icon': String? icon,
          'iconset': String? iconSet,
          '_links': Map<String, dynamic>? links,
          '_embedded': {
            'grids': List? embeddedGrids,
          }?,
        } =>
          Space(
            id: id,
            name: name,
            key: key,
            category: category,
            icon: icon,
            iconSet: iconSet,
            links: linkMapFromJson(links),
            embeddedGrids: embeddedGrids?.map((e) => Grid.fromJson(e)).toList(),
            color: color != null
                ? Color(
                    int.parse(color.substring(1, 7), radix: 16) + 0xFF000000,
                  )
                : null,
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid Space json: $json',
          ),
      };

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

  /// Color of this space
  final Color? color;

  /// Icon name of this space. This should also take into account [iconSet] in order to find the correct Icon to display
  final String? icon;

  /// IconSet that [icon] is from
  final String? iconSet;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() {
    final jsonMap = {
      'name': name,
      'id': id,
      'type': 'space',
      '_links': links.toJson(),
      if (key != null) 'key': key,
      if (category != null) 'belongsTo': category,
      if (color != null)
        'color':
            '#${color!.red.toRadixString(16)}${color!.green.toRadixString(16)}${color!.blue.toRadixString(16)}',
      if (icon != null) 'icon': icon,
      if (iconSet != null) 'iconset': iconSet,
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
    return 'Space(name: $name, id: $id, key: $key, category: $category, color: $color, icon: $icon, iconSet: $iconSet, links: $links, embeddedGrids: $embeddedGrids)';
  }

  @override
  bool operator ==(Object other) {
    return other is Space &&
        id == other.id &&
        name == other.name &&
        key == other.key &&
        category == other.category &&
        f.mapEquals(links, other.links) &&
        f.listEquals(embeddedGrids, other.embeddedGrids) &&
        color == other.color &&
        iconSet == other.iconSet &&
        icon == other.icon;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        key,
        category,
        links,
        embeddedGrids,
        color,
        iconSet,
        icon,
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
    super.color,
    super.icon,
    super.iconSet,
  });

  /// Deserializes [json] into a [Space] Object
  factory SharedSpace.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'name': String name,
          'realSpace': String realSpace,
          'key': String? key,
          'belongsTo': String? category,
          'color': String? color,
          'icon': String? icon,
          'iconset': String? iconSet,
          '_links': Map<String, dynamic>? links,
          '_embedded': {
            'grids': List? embeddedGrids,
          }?,
        }) {
      return SharedSpace(
        id: id,
        name: name,
        realSpace: Uri.parse(realSpace),
        key: key,
        category: category,
        icon: icon,
        iconSet: iconSet,
        links: linkMapFromJson(links),
        embeddedGrids: embeddedGrids?.map((e) => Grid.fromJson(e)).toList(),
        color: color != null
            ? Color(
                int.parse(color.substring(1, 7), radix: 16) + 0xFF000000,
              )
            : null,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid SharedSpace json: $json',
      );
    }
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
    return 'SharedSpace(name: $name, id: $id, key: $key, category: $category, realSpace: ${realSpace.toString()}, color: $color, icon: $icon, iconSet: $iconSet, links: $links, embeddedGrids: $embeddedGrids)';
  }

  @override
  bool operator ==(Object other) {
    return other is SharedSpace && super == other;
  }

  @override
  int get hashCode => Object.hash(
        realSpace,
        super.hashCode,
      );
}
