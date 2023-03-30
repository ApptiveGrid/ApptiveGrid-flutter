import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';

/// A collection of all possible roles users can have in a share
enum Role {
  /// Admin Role. Users with this role have full access to the Space
  admin(backendName: 'admin'),

  /// Reader Role. Users with this role can only read Information
  reader(backendName: 'reader'),

  /// Writer Role. Users with this role can write data into grids but cannot change grid/view settings
  writer(backendName: 'writer');

  /// Creates a [Role] with the given [backendName]
  const Role({required this.backendName});

  /// The name used by the backend for parsing
  final String backendName;
}

/// A Object representing a Share
class Share {
  /// Constructs a Share
  const Share({
    required this.role,
    required this.emails,
    required this.users,
    required this.links,
  });

  /// Creates a Share from value [json]
  factory Share.fromJson(dynamic json) {
    return Share(
      role: Role.values.firstWhere((role) => role.backendName == json['role']),
      emails: List<String>.from(json['emails']),
      users: List<String>.from(json['users']),
      links: linkMapFromJson(json['_links']),
    );
  }

  /// Serializes this [Share] to a json Map
  Map<String, dynamic> toJson() {
    return {
      'role': role.backendName,
      'emails': emails,
      'users': users,
      '_links': links.toJson()
    };
  }

  /// The Role for this Share
  final Role role;

  /// The List of emails associated with this Share
  final List<String> emails;

  /// The List of user ids associated with this Share
  final List<String> users;

  /// Map of [ApptiveLinks] relevant to this Share
  final LinkMap links;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Share &&
        other.role == role &&
        listEquals(other.emails, emails) &&
        listEquals(other.users, users) &&
        mapEquals(other.links, links);
  }

  @override
  int get hashCode {
    return Object.hash(role, emails, users, links);
  }

  @override
  String toString() {
    return 'Share(role: ${role.backendName}, emails: $emails, users: $users, links: $links)';
  }
}
