part of apptive_grid_model;

/// Object representing a UserReference
class UserReference {
  const UserReference({
    this.displayValue = '',
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

  Map<String, String?> toJson() => {
        'displayValue': displayValue,
        'id': id,
        'name': name,
        'type': type.backendType,
      };

  final String? displayValue;

  final String id;

  final String? name;

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

enum UserReferenceType {
  user,
  formLink,
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
