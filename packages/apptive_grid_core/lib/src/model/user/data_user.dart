import 'package:apptive_grid_core/apptive_grid_core.dart';

/// A User Object that is held in a [UserDataEntity]
class DataUser {
  /// Creates a new DataUser
  const DataUser({
    required this.displayValue,
    required this.uri,
  });

  /// Creates a new DataUser from a [json] response
  factory DataUser.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'displayValue': String? displayValue,
          'uri': String? uri,
        }) {
      return DataUser(
        displayValue: displayValue ?? '',
        uri: Uri.parse(uri ?? ''),
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid DataUser json: $json',
      );
    }
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
