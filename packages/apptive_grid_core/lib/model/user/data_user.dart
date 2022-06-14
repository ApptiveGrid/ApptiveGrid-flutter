part of apptive_grid_model;

/// A User Object that is held in a [UserDataEntity]
class DataUser {

  const DataUser(
  {
    required this.displayValue,
    required this.uri,
}
      );

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      displayValue: json['displayValue'] ?? '',
      uri: Uri.parse(json['uri'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'displayValue': displayValue,
    'uri': uri.toString(),
  };

  final String displayValue;
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