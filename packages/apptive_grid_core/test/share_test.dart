import 'dart:convert';
import 'dart:core';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      final response = Share(
        role: Role.admin,
        emails: ['info@apptivegrid.de'],
        users: ['userId'],
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/share'), method: 'get')
        },
      );
      final response2 = Share(
        role: Role.admin,
        emails: ['info@apptivegrid.de'],
        users: ['userId'],
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/share'), method: 'get')
        },
      );

      expect(response, equals(response2));
    });

    test('From/To Json', () {
      const json =
          """{"users":["userId"],"emails":["info@apptivegrid.de"],"role":"admin","_links":{"self":{"href":"/share","method":"get"}}}""";

      final direct = Share(
        role: Role.admin,
        emails: ['info@apptivegrid.de'],
        users: ['userId'],
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/share'), method: 'get')
        },
      );

      final fromJson = Share.fromJson(jsonDecode(json));

      expect(fromJson, equals(direct));

      expect(Share.fromJson(direct.toJson()), equals(direct));
    });

    test('UnEqual', () {
      final response = Share(
        role: Role.admin,
        emails: ['info@apptivegrid.de'],
        users: ['userId'],
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/share'), method: 'get')
        },
      );
      final response2 = Share(
        role: Role.admin,
        emails: ['info@apptivegrid.de'],
        users: ['differentUser'],
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/share'), method: 'get')
        },
      );

      expect(response, isNot(response2));
    });
  });

  test('Hashcode', () {
    final response = Share(
      role: Role.admin,
      emails: ['info@apptivegrid.de'],
      users: ['userId'],
      links: {
        ApptiveLinkType.self:
            ApptiveLink(uri: Uri.parse('/share'), method: 'get')
      },
    );

    expect(
      response.hashCode,
      Object.hash(
        response.role,
        response.emails,
        response.users,
        response.links,
      ),
    );
  });

  test('toString()', () {
    final response = Share(
      role: Role.admin,
      emails: ['info@apptivegrid.de'],
      users: ['userId'],
      links: {
        ApptiveLinkType.self:
            ApptiveLink(uri: Uri.parse('/share'), method: 'get')
      },
    );

    expect(
      response.toString(),
      equals(
        'Share(role: admin, emails: [info@apptivegrid.de], users: [userId], links: {ApptiveLinkType.self: ApptiveLink(uri: /share, method: get)})',
      ),
    );
  });
}
