/// Object representing a CreatedBy Field
class CreatedBy {
  /// Creates a new CreatedBy
  const CreatedBy({
    this.displayValue,
    required this.id,
    this.name = '',
    required this.type,
  });

  /// Creates a new CreatedBy Object from a [json] response
  factory CreatedBy.fromJson(dynamic json) => switch (json) {
        {
          'id': String id,
          'name': String name,
          'displayValue': String? displayValue,
          'type': String type,
        } =>
          CreatedBy(
            displayValue: displayValue,
            id: id,
            name: name,
            type: CreatedByType.values.firstWhere(
              (element) => element.backendType == type,
            ),
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid CreatedBy json: $json',
          ),
      };

  /// Maps the [CreatedBy] to a format the server can understand
  Map<String, String?> toJson() => {
        'displayValue': displayValue ?? '',
        'id': id,
        'name': name,
        'type': type.backendType,
      };

  /// Display Value for the Reference
  /// If [type] is [CreatedByType.user] this will be the First Name Last Name of the user
  final String? displayValue;

  /// Id of the user
  ///
  /// Can be a Userid, FormId, ApiCredentials id
  final String id;

  /// Name of the User
  ///
  /// If [type] is [CreatedByType.user] this will be the email of the user
  /// If [type] is [CreatedByType.apiCredentials] this will be the name of the api credentials
  final String name;

  /// Type of the creating user
  final CreatedByType type;

  @override
  String toString() {
    return 'CreatedBy(displayValue: $displayValue, id: $id, name: $name, type: ${type.name})';
  }

  @override
  bool operator ==(Object other) {
    return other is CreatedBy &&
        displayValue == other.displayValue &&
        id == other.id &&
        name == other.name &&
        type == other.type;
  }

  @override
  int get hashCode => Object.hash(displayValue, id, name, type);
}

/// Different types that have created a specific entity
enum CreatedByType {
  /// The entity was created by a logged in user
  user,

  /// The entity was submitted via a form by a non logged in user
  formLink,

  /// The entity was created using api credentials
  apiCredentials,
}

extension _UserReferenceX on CreatedByType {
  String get backendType => switch (this) {
        CreatedByType.user => 'user',
        CreatedByType.formLink => 'link',
        CreatedByType.apiCredentials => 'accesscredentials',
      };
}
