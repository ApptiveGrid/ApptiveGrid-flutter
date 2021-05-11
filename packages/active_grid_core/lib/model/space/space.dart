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

class Space {
  Space({
    required this.id,
    required this.name,
    required this.grids
  });

  Space.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        grids = (json['gridUris'] as List)
            .map((e) => GridUri.fromUri(e))
            .toList();

  final String name;
  final String id;
  final List<GridUri> grids;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id,
    'gridUris': grids.map((e) => e.uriString()),
  };

  @override
  String toString() {
    return 'Space(name: $name, id: $id, spaces: ${grids.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is Space &&
        id == other.id &&
        name == other.name &&
        f.listEquals(grids, other.grids);
  }

  @override
  int get hashCode => toString().hashCode;
}