import 'dart:convert';
import 'dart:core';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      final response = Invitation(
        role: Role.admin,
        email: 'info@apptivegrid.de',
        id: 'invitationId',
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
        },
      );
      final response2 = Invitation(
        role: Role.admin,
        email: 'info@apptivegrid.de',
        id: 'invitationId',
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
        },
      );

      expect(response, equals(response2));
    });

    test('From/To Json', () {
      const json =
          """{"link":"/api/users/userId/spaces/spaceId/links/linkId","role":"admin","id":"invitationId","email":"info@apptivegrid.de","_links":{"self":{"href":"/invitation","method":"get"}}}""";

      final direct = Invitation(
        role: Role.admin,
        email: 'info@apptivegrid.de',
        id: 'invitationId',
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
        },
      );

      final fromJson = Invitation.fromJson(jsonDecode(json));

      expect(fromJson, equals(direct));

      expect(Invitation.fromJson(direct.toJson()), equals(direct));
    });

    test('UnEqual', () {
      final response = Invitation(
        role: Role.admin,
        email: 'info@apptivegrid.de',
        id: 'invitationId',
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
        },
      );
      final response2 = Invitation(
        role: Role.admin,
        email: 'info@apptivegrid.de',
        id: 'differentInvitation',
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
        },
      );

      expect(response, isNot(response2));
    });
  });

  test('Hashcode', () {
    final response = Invitation(
      role: Role.admin,
      email: 'info@apptivegrid.de',
      id: 'invitationId',
      links: {
        ApptiveLinkType.self:
            ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
      },
    );

    expect(
      response.hashCode,
      Object.hash(
        response.id,
        response.role,
        response.email,
        response.links,
      ),
    );
  });

  test('toString()', () {
    final response = Invitation(
      role: Role.admin,
      email: 'info@apptivegrid.de',
      id: 'invitationId',
      links: {
        ApptiveLinkType.self:
            ApptiveLink(uri: Uri.parse('/invitation'), method: 'get')
      },
    );

    expect(
      response.toString(),
      equals(
        'Invitation(id: invitationId, role: admin, email: info@apptivegrid.de, links: {ApptiveLinkType.self: ApptiveLink(uri: /invitation, method: get)})',
      ),
    );
  });
}
