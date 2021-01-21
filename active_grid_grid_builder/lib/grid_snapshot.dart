part of active_grid_grid_builder;

class GridSnapshot {
  GridSnapshot({this.data, this.error});

  final Grid data;
  final Object error;

  bool get hasData => data != null;
  bool get hasError => error != null;
}
