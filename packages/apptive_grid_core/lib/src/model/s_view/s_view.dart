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
    this.fields,
    this.fieldProperties,
    this.properties,
  });

  /// Creates a SView from value [json]
  factory SView.fromJson(
    dynamic json,
  ) {
    final type =
        SViewType.values.firstWhere((type) => type.backendName == json['type']);
    final fields = (json['fields'] as List?)
        ?.map((json) => GridField.fromJson(json))
        .toList();
    final fieldProperties =
        (json['fieldProperties'] as Map?)?.cast<String, dynamic>();

    return SView(
      name: json['name'],
      id: json['id'],
      type: type,
      links: linkMapFromJson(
        json['_links'],
      ),
      fields: fields,
      fieldProperties: fieldProperties,
      properties: json['properties'],
    );
  }

  /// Serializes this sview into a json Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.backendName,
      '_links': links.toJson(),
      if (fields != null) 'fields': fields!.map((e) => e.toJson()).toList(),
      if (fieldProperties != null) 'fieldProperties': fieldProperties,
      if (properties != null) 'properties': properties,
    };
  }

  /// The id of the view
  final String id;

  /// The name of the view
  final String name;

  /// The [SViewType] of the View
  final SViewType type;

  /// Map of [ApptiveLinks] relevant to this view
  final LinkMap links;

  /// The fields in this SView
  final List<GridField>? fields;

  /// Field Properties
  /// For example this can indicate which field to use for Kanban state
  final Map<String, dynamic>? fieldProperties;

  /// General properties of this sview
  final Map<dynamic, dynamic>? properties;

  @override
  bool operator ==(Object other) {
    return other is SView &&
        name == other.name &&
        id == other.id &&
        type == other.type &&
        mapEquals(links, other.links) &&
        listEquals(fields, other.fields) &&
        mapEquals(fieldProperties, other.fieldProperties) &&
        mapEquals(properties, other.properties);
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, links, fields, fieldProperties, properties);

  @override
  String toString() {
    return 'SView(name: $name, type: $type}, id: $id, links: $links)';
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
