part of apptive_grid_model;

class EntitiesResponse<T> {

  const EntitiesResponse({this.items = const []});

  final List<T> items;

  @override
  String toString() => 'EntitiesResponse(items: $items)';

  @override
  bool operator ==(Object other) {
    return other is EntitiesResponse &&
    f.listEquals(other.items, items);
  }

  @override
  int get hashCode => toString().hashCode;


  EntitiesResponse copyWith({List<T>? items}) {
    return EntitiesResponse(
      items: items ?? this.items,
    );
  }
}