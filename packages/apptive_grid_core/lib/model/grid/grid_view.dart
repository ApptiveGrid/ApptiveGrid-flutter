part of apptive_grid_model;

/// A Uri representing a GridView
class GridViewUri extends GridUri {
  /// Creates a new [GridViewUri] based on known ids for [user], [space], [grid] and [view]
  GridViewUri({
    required String user,
    required String space,
    required String grid,
    required this.view,
  }) : super(user: user, space: space, grid: grid);

  /// Creates a new [GridViewUri] based on a string [uri]
  /// Main usage of this is for [GridViewUri] retrieved through other Api Calls
  factory GridViewUri.fromUri(String uri) {
    const regex = r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)/views/(\w+)\b';
    final matches = RegExp(regex).allMatches(uri);
    if (matches.isEmpty || matches.elementAt(0).groupCount != 4) {
      throw ArgumentError('Could not parse GridViewUri $uri');
    }
    final match = matches.elementAt(0);
    return GridViewUri(
        user: match.group(1)!,
        space: match.group(2)!,
        grid: match.group(3)!,
        view: match.group(4)!);
  }

  /// Id of the View this [GridViewUri] is representing
  final String view;

  @override
  String toString() {
    return 'GridViewUri(user: $user, space: $space grid: $grid, view: $view)';
  }

  /// Generates the uriString used for ApiCalls referencing this
  @override
  String get uriString =>
      '/api/users/$user/spaces/$space/grids/$grid/views/$view';

  @override
  bool operator ==(Object other) {
    return other is GridViewUri &&
        view == other.view &&
        grid == other.grid &&
        user == other.user &&
        space == other.space;
  }

  @override
  int get hashCode => toString().hashCode;
}
