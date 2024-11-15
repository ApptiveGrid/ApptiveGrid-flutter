import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Model representing a Resource
class DataResource {
  /// Creates a new DataResource
  const DataResource({
    required this.href,
    required this.type,
    required this.name,
  });

  /// Creates a new DataResource from a [json] response
  factory DataResource.fromJson(Map<String, dynamic> json) {
    return DataResource(
      href: linkMapFromJson(json['_links'])['self'] ?? ApptiveLink(method: 'GET', uri: Uri.parse('missing_link')),
      type: DataResourceType.values.firstWhere((e) => e.backendName == json['type'], orElse: () => DataResourceType.unknown),
      name: json['name'] ?? '',
    );
  }

  /// Converts this DataResource to a json representation
  Map<String, dynamic> toJson() => {
        '_links': href.toJson(),
        
        'type': type,
        'name': name,
      };

  /// Uri pointing to the resource
  final ApptiveLink href;

  /// Type of the resource
  final DataResourceType type;

  /// Name of the resource
  final String name;

  @override
  String toString() {
    return 'DataResource(href: $href, type: $type, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return other is DataResource && href == other.href && type == other.type && name == other.name;
  }

  @override
  int get hashCode => Object.hash(href, type, name);
}

/// Types of data resources supported by the system
enum DataResourceType {
  /// A standard grid resource type
  grid(backendName: 'grid'),

  /// A persistent grid resource type
  persistentGrid(backendName: 'persistent'),

  /// A view resource type
  view(backendName: 'view'),

  /// A virtual grid resource type
  virtualGrid(backendName: 'virtual'),

  /// A space resource type
  space(backendName: 'space'),

  /// A form resource type
  form(backendName: 'form'),

  /// A block resource type
  block(backendName: 'block'),

  /// A spreadsheet resource type
  spreadsheet(backendName: 'spreadsheet'),

  /// A kanban board resource type
  kanban(backendName: 'kanban'),

  /// A calendar resource type
  calendar(backendName: 'calendar'),

  /// A map resource type
  map(backendName: 'map'),

  /// A gallery resource type
  gallery(backendName: 'gallery'),

  /// An unknown resource type
  unknown(backendName: 'unknown');

  /// Define a DataResourceTypes with a corresponding [backendName]
  const DataResourceType({
    required this.backendName,
  });

  /// The name that is used in the ApptiveGridBackend for this [DataResourceTypes]
  final String backendName;
}