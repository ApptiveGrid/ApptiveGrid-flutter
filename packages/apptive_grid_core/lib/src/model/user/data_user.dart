part of apptive_grid_model;

/// A User Object that is held in a [UserDataEntity]
class DataUser {
  /// Creates a new DataUser
  const DataUser({
    required this.displayValue,
    required this.uri,
  });

  /// Creates a new DataUser from a [json] response
  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      displayValue: json['displayValue'] ?? '',
      uri: Uri.parse(json['uri'] ?? ''),
    );
  }

  /// Converts this DataUser to a json representation
  Map<String, dynamic> toJson() => {
        'displayValue': displayValue,
        'uri': uri.toString(),
      };

  /// Display Value for the User. This usually is the Name
  final String displayValue;

  /// Uri to query the user
  final Uri uri;

  @override
  String toString() {
    return 'DataUser(displayValue: $displayValue, uri: $uri)';
  }

  @override
  operator ==(Object other) {
    return other is DataUser &&
        displayValue == other.displayValue &&
        uri == other.uri;
  }

  @override
  int get hashCode => Object.hash(displayValue, uri);
}
