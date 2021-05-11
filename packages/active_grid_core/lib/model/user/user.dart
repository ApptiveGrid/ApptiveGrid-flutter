part of active_grid_model;

class User {
  User({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.id,
    required this.spaces,
  });

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        lastName = json['lastName'],
        firstName = json['firstName'],
        id = json['id'],
        spaces = (json['spaceUris'] as List)
            .map((e) => SpaceUri.fromUri(e))
            .toList();

  final String email;
  final String lastName;
  final String firstName;
  final String id;

  final List<SpaceUri> spaces;

  Map<String, dynamic> toJson() => {
    'email' : email,
    'lastName' : lastName,
    'firstName' : firstName,
    'id' : id,
    'spaceUris': spaces.map((e) => e.uriString()),
  };

  @override
  String toString() {
    return 'User(email: $email, lastName: $lastName, firstName: $firstName, id: $id, spaces: ${spaces.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
    id == other.id &&
    email == other.email &&
    lastName == other.lastName &&
    firstName == other.firstName &&
    f.listEquals(spaces, other.spaces);
  }

  @override
  int get hashCode => toString().hashCode;
}
