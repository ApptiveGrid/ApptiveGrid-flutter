import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Response when loading entities of a Grid with [ApptiveGridClient.loadEntities]
class EntitiesResponse {
  /// Creates a new Response Object with [items]
  const EntitiesResponse({this.items = const []});

  /// Items of the Response
  final List<dynamic> items;

  @override
  String toString() => 'EntitiesResponse(items: $items)';

  @override
  bool operator ==(Object other) {
    return other is EntitiesResponse && f.listEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;

  /// Copies this Object with provided arguments
  EntitiesResponse copyWith({List<dynamic>? items}) {
    return EntitiesResponse(
      items: items ?? this.items,
    );
  }
}
