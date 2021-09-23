part of apptive_grid_model;

/// A Uri representation used for performing Grid based Api Calls
class EntityUri extends ApptiveGridUri {
  /// Creates a new [EntityUri] based on known ids for [user], [space] and [grid]
  EntityUri(
      {required this.user,
      required this.space,
      required this.grid,
      required this.entity});

  /// Creates a new [EntityUri] based on a string [uri]
  /// Main usage of this is for [EntityUri] retrieved through other Api Calls
  factory EntityUri.fromUri(String uri) {
    const regex = r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)/entities/(\w+)\b';
    final matches = RegExp(regex).allMatches(uri);
    if (matches.isEmpty || matches.elementAt(0).groupCount != 4) {
      throw ArgumentError('Could not parse EntityUri $uri');
    }
    final match = matches.elementAt(0);
    return EntityUri(
        user: match.group(1)!,
        space: match.group(2)!,
        grid: match.group(3)!,
        entity: match.group(4)!);
  }

  /// Id of the User that owns this Grid
  final String user;

  /// Id of the Space this Grid is in
  final String space;

  /// Id of the Grid this is in
  final String grid;

  /// Id of the Entity this [EntityUri] is representing
  final String entity;

  @override
  String toString() {
    return 'EntityUri(user: $user, space: $space grid: $grid, entity: $entity)';
  }

  /// Generates the uriString used for ApiCalls referencing this
  @override
  String get uriString =>
      '/api/users/$user/spaces/$space/grids/$grid/entities/$entity';

  @override
  bool operator ==(Object other) {
    return other is EntityUri &&
        entity == other.entity &&
        grid == other.grid &&
        user == other.user &&
        space == other.space;
  }

  @override
  int get hashCode => toString().hashCode;
}
