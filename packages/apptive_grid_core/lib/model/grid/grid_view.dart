part of apptive_grid_model;

/// A Uri representing a GridView
@Deprecated('Use a normal `Uri` instead')
class GridViewUri extends GridUri {
  /// Creates a new [GridViewUri] based on known ids for [user], [space], [grid] and [view]
  GridViewUri({
    required String user,
    required String space,
    required String grid,
    required String view,
  }) : super(user: user, space: space, grid: grid, view: view);

  /// Creates a new [GridViewUri] based on a string [uri]
  /// Main usage of this is for [GridViewUri] retrieved through other Api Calls
  GridViewUri.fromUri(String uri) : super.fromUri(uri);
}
