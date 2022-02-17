part of apptive_grid_model;

/// A Uri representation used for performing Grid based Api Calls
class EntityUri extends ApptiveGridUri {
  /// Creates a new [EntityUri] based on known ids for [user], [space] and [grid]
  EntityUri({
    required String user,
    required String space,
    required String grid,
    required String entity,
  }) : super._(
          Uri(
            path: '/api/users/$user/spaces/$space/grids/$grid/entities/$entity',
          ),
          UriType.entity,
        );

  /// Creates a new [EntityUri] based on a string [uri]
  /// Main usage of this is for [EntityUri] retrieved through other Api Calls
  EntityUri.fromUri(String uri) : super.fromUri(uri, UriType.entity);
}
