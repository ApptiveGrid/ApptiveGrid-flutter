part of active_grid_model;

class SpaceUri {
  SpaceUri({required this.user, required this.id,});

  factory SpaceUri.fromUri(String uri) {
    final regex = r'/api/users/(\w+)/spaces/(\w+)';
    final match = RegExp(regex).allMatches(uri).elementAt(0);
    if(match.groupCount != 2) {
      throw ArgumentError('Could not parse SpaceUri $uri');
    }
    return SpaceUri(user: match.group(1)!, id: match.group(2)!);
  }

  final String user;
  final String id;

  @override
  String toString() {
    return 'SpaceUri(user: $user, id: $id)';
  }

  String uriString() => '/api/users/$user/spaces/$id';

  @override
  bool operator ==(Object other) {
    return other is SpaceUri &&
        id == other.id &&
        user == other.user;
  }

  @override
  int get hashCode => toString().hashCode;
}
