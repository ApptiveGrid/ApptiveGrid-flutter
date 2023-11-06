import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';

/// A class for a Statefull View
class SView {
  /// Creates a SView
  const SView({
    required this.name,
    required this.id,
    required this.type,
    required this.links,
    this.slots,
    this.properties,
  });

  /// Creates a SView from value [json]
  factory SView.fromJson(
    dynamic json,
  ) {
    final type =
        SViewType.values.firstWhere((type) => type.backendName == json['type']);
    final slotProperties =
        (json['slotProperties'] as Map?)?.cast<String, dynamic>();
    final slots = (json['_embedded']?['schema']?['slots'] as Map?)
        ?.cast<String, dynamic>()
        .map(
          (key, value) => MapEntry(
            key,
            SViewSlot.fromJson(
              value,
              properties: slotProperties?[key],
            ),
          ),
        );
    return SView(
      name: json['name'],
      id: json['id'],
      type: type,
      links: linkMapFromJson(
        json['_links'],
      ),
      slots: slots,
      properties: json['properties'],
    );
  }

  /// Serializes this sview into a json Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.backendName,
        '_links': links.toJson(),
        if (slots != null) ...{
          'slotProperties':
              slots!.map((key, value) => MapEntry(key, value.properties ?? {})),
          '_embedded': {
            'schema': {
              'slots': slots!.map(
                (key, value) => MapEntry(
                  key,
                  {
                    'position': value.position,
                    'type': {'name': value.type.backendName},
                  },
                ),
              ),
            }
          },
        },
        if (properties != null) 'properties': properties,
      };

  /// The id of the view
  final String id;

  /// The name of the view
  final String name;

  /// The [SViewType] of the View
  final SViewType type;

  /// Map of [ApptiveLinks] relevant to this view
  final LinkMap links;

  /// General properties of this sview
  final Map<dynamic, dynamic>? properties;

  /// Map of field id to sview slot
  final Map<String, SViewSlot>? slots;

  /// List of field ids in this sview
  List<String> get fieldIds => slots?.keys.toList() ?? [];

  @override
  bool operator ==(Object other) {
    return other is SView &&
        name == other.name &&
        id == other.id &&
        type == other.type &&
        mapEquals(links, other.links) &&
        mapEquals(slots, other.slots) &&
        mapEquals(properties, other.properties);
  }

  @override
  int get hashCode => Object.hash(id, name, type, links, slots, properties);

  @override
  String toString() {
    return 'SView(name: $name, type: $type, id: $id, links: $links, slots: $slots, properties: $properties)';
  }
}

/// Available View Types
enum SViewType {
  /// A View that displays data in a spreadsheet
  spreadsheet(backendName: 'spreadsheet'),

  /// A Kanban Board View of entries
  kanban(backendName: 'kanban'),

  /// A View that displays entries in a Calendar
  calendar(backendName: 'calendar'),

  /// A View that displays entries on a map
  map(backendName: 'map'),

  /// A View that displays entries in a Gallery Card View
  gallery(backendName: 'gallery');

  /// Constructor for enum fields
  const SViewType({required this.backendName});

  /// Name used by the backend to identify the view when parsing to and from json
  final String backendName;
}

/// A slot of a sview
class SViewSlot {
  /// Creates an SViewSlot
  SViewSlot({
    required this.position,
    required this.type,
    this.key,
    this.name,
    this.properties,
  });

  /// Creates a SViewSlot from value [json]
  factory SViewSlot.fromJson(
    dynamic json, {
    Map<String, dynamic>? properties,
  }) =>
      SViewSlot(
        position: json['position'],
        type: DataType.values
            .firstWhere((e) => e.backendName == json['type']['name']),
        key: json['key'],
        name: json['name'],
        properties: properties,
      );

  /// Position of the sview slot
  final int position;

  /// A key associated with this sview slot
  final String? key;

  /// Name of the sview slot
  final String? name;

  /// [DataType] of the sview slot
  final DataType type;

  /// Additional properties of the sview slot
  final Map<String, dynamic>? properties;

  @override
  bool operator ==(Object other) {
    return other is SViewSlot &&
        position == other.position &&
        key == other.key &&
        name == other.name &&
        type == other.type &&
        mapEquals(properties, other.properties);
  }

  @override
  int get hashCode => Object.hash(
        position,
        key,
        name,
        type,
        properties,
      );

  @override
  String toString() {
    return 'SViewSlot(position: $position, key: $key, name: $name type: $type, properties: $properties)';
  }
}
