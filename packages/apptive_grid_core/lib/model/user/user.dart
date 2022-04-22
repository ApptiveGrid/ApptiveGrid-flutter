part of apptive_grid_model;

/// Model for a User
class User {
  /// Creates a new User Model with a certain [id], [firstName], [lastName] and [email]
  /// [spaceUris] is [List<SpaceUri>] pointing to the [Spaces]s of this [User]
  User({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.id,
    required this.spaceUris,
    required this.links,
  });

  /// Deserializes [json] into a [User] Object
  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        lastName = json['lastName'],
        firstName = json['firstName'],
        id = json['id'],
        spaceUris = (json['spaceUris'] as List)
            .map((e) => SpaceUri.fromUri(e))
            .toList(),
        links = linkMapFromJson(json['_links']);

  /// Email of the this [User]
  final String email;

  /// Last Name of this [User]
  final String lastName;

  /// First Name of this [User]
  final String firstName;

  /// Id of this [User]
  final String id;

  /// [SpaceUri]s pointing to [Space]s created by this [User]
  final List<SpaceUri> spaceUris;

  final LinkMap links;

  /// Serializes this [Space] into a json Map
  Map<String, dynamic> toJson() => {
        'email': email,
        'lastName': lastName,
        'firstName': firstName,
        'id': id,
        'spaceUris': spaceUris.map((e) => e.uri.toString()).toList(),
        '_links': links.toJson(),
      };

  @override
  String toString() {
    return 'User(email: $email, lastName: $lastName, firstName: $firstName, id: $id, spaceUris: ${spaceUris.toString()}, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
        id == other.id &&
        email == other.email &&
        lastName == other.lastName &&
        firstName == other.firstName &&
        f.listEquals(spaceUris, other.spaceUris) &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => toString().hashCode;
}
