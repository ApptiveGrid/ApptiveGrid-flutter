part of apptive_grid_model;

/// Response when loading entities of a Grid with [ApptiveGridClient.loadEntities]
class EntitiesResponse<T> {
  /// Creates a new Response Object with [items]
  const EntitiesResponse({this.items = const []});

  /// Items of the Response
  final List<T> items;

  @override
  String toString() => 'EntitiesResponse(items: $items)';

  @override
  bool operator ==(Object other) {
    return other is EntitiesResponse && f.listEquals(other.items, items);
  }

  @override
  int get hashCode => toString().hashCode;

  /// Copies this Object with provided arguments
  EntitiesResponse copyWith({List<T>? items}) {
    return EntitiesResponse(
      items: items ?? this.items,
    );
  }
}
