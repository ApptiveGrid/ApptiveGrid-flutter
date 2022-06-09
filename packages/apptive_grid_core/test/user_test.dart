import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From Json maps correctly', () {
      const id = 'id';
      const firstName = 'Jane';
      const lastName = 'Doe';
      const email = 'jane.doe@zweidenker.de';

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        '_links': {
          "accessCredentials": {
            "href": "/api/users/id/accessKeys",
            "method": "get"
          },
          "spaces": {"href": "/api/users/id/spaces", "method": "get"},
          "hooks": {"href": "/api/users/id/hooks", "method": "get"},
          "addHook": {"href": "/api/users/id/hooks", "method": "post"},
          "self": {"href": "/api/users/id", "method": "get"},
          "addAccessCredentials": {
            "href": "/api/users/id/accessKeys",
            "method": "post"
          },
          "addSpace": {"href": "/api/users/id/spaces", "method": "post"},
        },
      });

      expect(jsonUser.id, equals(id));
      expect(jsonUser.firstName, equals(firstName));
      expect(jsonUser.lastName, equals(lastName));
      expect(jsonUser.email, equals(email));
      expect(jsonUser.links.length, equals(7));
    });

    test('From Json, toJson equals', () {
      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        'spaceUris': [
          '/api/users/id/spaces/spaceId',
        ],
        '_links': {
          'self': {'href': '/api/users/id', 'method': 'get'},
        },
      });

      final doubleParse = User.fromJson(jsonUser.toJson());

      expect(doubleParse, equals(jsonUser));
    });
  });

  group('Equality', () {
    test('Plain and From json equal', () {
      const id = 'id';
      const firstName = 'Jane';
      const lastName = 'Doe';
      const email = 'jane.doe@zweidenker.de';

      final plain = User(
        email: email,
        lastName: lastName,
        firstName: firstName,
        id: id,
        links: {
          ApptiveLinkType.self:
              ApptiveLink(uri: Uri.parse('/api/users/id'), method: 'get'),
        },
      );

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        '_links': {
          'self': {'href': '/api/users/id', 'method': 'get'},
        },
      });

      expect(plain, equals(jsonUser));
      expect(plain.hashCode, equals(jsonUser.hashCode));
    });

    test('Plain and From json not equal with different values', () {
      const id = 'id';
      const firstName = 'Jane';
      const lastName = 'Doe';
      const email = 'jane.doe@zweidenker.de';

      final plain = User(
        email: email,
        lastName: lastName,
        firstName: firstName,
        id: id,
        links: {},
      );

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        '_links': {
          'self': {'href': '/api/users/id', 'method': 'get'},
        },
      });

      expect(plain, isNot(jsonUser));
      expect(plain.hashCode, isNot(jsonUser.hashCode));
    });
  });
}
