import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';

/// A Object representing a Invitation
class Invitation {
  /// Constructs a Invitation
  const Invitation({
    required this.id,
    required this.role,
    required this.email,
    required this.links,
  });

  /// Creates a Invitation from value [json]
  factory Invitation.fromJson(dynamic json) {
    return Invitation(
      id: json['id'],
      role: Role.values.firstWhere((role) => role.backendName == json['role']),
      email: json['email'],
      links: linkMapFromJson(json['_links']),
    );
  }

  /// Serializes this [Invitation] to a json Map
  Map<String, dynamic> toJson() {
    return {
      'role': role.backendName,
      'email': email,
      'id': id,
      '_links': links.toJson()
    };
  }

  /// The id of this Invitation
  final String id;

  /// The Role for this Invitation
  final Role role;

  /// The email this invitation was send to
  final String email;

  /// Map of [ApptiveLinks] relevant to this Invitation
  final LinkMap links;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Invitation &&
        other.id == id &&
        other.role == role &&
        other.email == email &&
        mapEquals(other.links, links);
  }

  @override
  int get hashCode {
    return Object.hash(id, role, email, links);
  }

  @override
  String toString() {
    return 'Invitation(id: $id, role: ${role.backendName}, email: $email, links: $links)';
  }
}
