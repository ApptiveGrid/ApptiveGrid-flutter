import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Model representing a Resource
class DataResource {
  /// Creates a new DataResource
  const DataResource({
    required this.href,
    required this.type,
    required this.name,
    required this.metaType,
  });

  /// Creates a new DataResource from a [json] response
  ///
  /// The resource is usually a nested object with a `_links.self` link. When a
  /// value was written with [ResourceDataEntity.schemaValue] (or comes from an
  /// older backend) it may only carry a bare `href` or `uri`, so those are
  /// accepted as well.
  factory DataResource.fromJson(Map<String, dynamic> json) {
    final links = linkMapFromJson(json['_links'] ?? {});
    final bareUri = json['href'] ?? json['uri'];
    return DataResource(
      href: links[ApptiveLinkType.self] ??
          (bareUri is String
              ? ApptiveLink(method: 'GET', uri: Uri.parse(bareUri))
              : ApptiveLink(method: 'GET', uri: Uri.parse('missing_link'))),
      type: DataResourceType.values.firstWhere(
        (e) => e.backendName == json['type'],
        orElse: () => DataResourceType.unknown,
      ),
      name: json['displayValue'] ?? json['name'] ?? '',
      metaType: DataResourceMetaType.values.firstWhere(
        (e) => e.name == json['metaType'],
        orElse: () => DataResourceMetaType.unknown,
      ),
    );
  }

  /// Converts this DataResource to a json representation
  Map<String, dynamic> toJson() => {
        '_links': {ApptiveLinkType.self.name: href.toJson()},
        'type': type.backendName,
        'name': name,
        'metaType': metaType.name,
      };

  /// Uri pointing to the resource
  final ApptiveLink href;

  /// Type of the resource
  final DataResourceType type;

  /// Name of the resource
  final String name;

  /// Meta type of the resource
  final DataResourceMetaType metaType;

  @override
  String toString() {
    return 'DataResource(href: $href, type: $type, name: $name, metaType: $metaType)';
  }

  @override
  bool operator ==(Object other) {
    return other is DataResource &&
        href == other.href &&
        type == other.type &&
        name == other.name &&
        metaType == other.metaType;
  }

  @override
  int get hashCode => Object.hash(href, type, name, metaType);
}

/// Enum representing the different meta types of data resources
enum DataResourceMetaType {
  /// A view meta type
  view,

  /// A grid meta type
  grid,

  /// A space meta type
  space,

  /// A form meta type
  form,

  /// A block meta type
  block,

  /// A view of a grid, e.g. a spreadsheet or kanban view
  gridView,

  /// An external link, e.g. a form link or a flow trigger
  externalHook,

  /// A node inside of a flow
  flowNode,

  /// A unknown meta type
  unknown,
}

/// Types of data resources supported by the system
enum DataResourceType {
  /// A space resource type
  space(backendName: 'space'),

  /// A persistent grid resource type
  persistentGrid(backendName: 'persistent'),

  /// A virtual grid resource type
  virtualGrid(backendName: 'virtual'),

  /// A block of type page
  pageBlock(backendName: 'page'),

  /// A resource of type form
  form(backendName: 'form'),

  /// A spreadsheet resource type
  spreadsheetView(backendName: 'spreadsheet'),

  /// A kanban board resource type
  kanbanView(backendName: 'kanban'),

  /// A calendar resource type
  calendarView(backendName: 'calendar'),

  /// A map resource type
  mapView(backendName: 'map'),

  /// A gallery resource type
  galleryView(backendName: 'gallery'),

  /// A list resource type
  listView(backendName: 'list'),

  /// A timeline resource type
  timelineView(backendName: 'timeline'),

  /// A flow
  flow(backendName: 'flow'),

  /// A running instance of a flow. These are listed by the backend but not
  /// meant to be selected in forms
  flowInstance(backendName: 'flowInstance'),

  /// An external link that triggers a flow
  externalFlowTrigger(backendName: 'externalFlowTrigger'),

  /// An external link that adds an entity to a grid
  addEntity(backendName: 'addEntity'),

  /// An unknown resource type
  unknown(backendName: 'unknown');

  /// Define a DataResourceTypes with a corresponding [backendName]
  const DataResourceType({
    required this.backendName,
  });

  /// The name that is used in the ApptiveGridBackend for this [DataResourceTypes]
  final String backendName;
}
