part of apptive_grid_model;

/// Object representing a UserReference
class UserReference {
  /// Creates a new UserReference
  const UserReference({
    this.displayValue,
    required this.id,
    this.name = '',
    required this.type,
  });

  /// Creates a new UserReference from a [json] response
  factory UserReference.fromJson(dynamic json) {
    return UserReference(
      displayValue: json['displayValue'],
      id: json['id'],
      name: json['name'],
      type: UserReferenceType.values
          .firstWhere((element) => element.backendType == json['type']),
    );
  }

  /// Maps the [UserReference] to a format the server can understand
  Map<String, String?> toJson() => {
        'displayValue': displayValue ?? '',
        'id': id,
        'name': name,
        'type': type.backendType,
      };

  /// Display Value for the Reference
  /// If [type] is [UserReferenceType.user] this will be the First Name Last Name of the user
  final String? displayValue;

  /// Id of the user
  ///
  /// Can be a Userid, FormId, ApiCredentials id
  final String id;

  /// Name of the User
  ///
  /// If [type] is [UserReferenceType.user] this will be the email of the user
  /// If [type] is [UserReferenceType.apiCredentials] this will be the name of the api credentials
  final String name;

  /// Type of the creating user
  final UserReferenceType type;

  @override
  String toString() {
    return 'UserReference(displayValue: $displayValue, id: $id, name: $name, type: ${type.name})';
  }

  @override
  bool operator ==(Object other) {
    return other is UserReference &&
        displayValue == other.displayValue &&
        id == other.id &&
        name == other.name &&
        type == other.type;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Different types that have created a specific entity
enum UserReferenceType {
  /// The entity was created by a logged in user
  user,

  /// The entity was submitted via a form by a non logged in user
  formLink,

  /// The entity was created using api credentials
  apiCredentials,
}

extension _UserReferenceX on UserReferenceType {
  String get backendType {
    switch (this) {
      case UserReferenceType.user:
        return 'user';
      case UserReferenceType.formLink:
        return 'link';
      case UserReferenceType.apiCredentials:
        return 'accesscredentials';
    }
  }
}
