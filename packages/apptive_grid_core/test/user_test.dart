import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From Json maps correctly', () {
      const id = 'id';
      const firstName = 'Jane';
      const lastName = 'Doe';
      const email = 'jane.doe@zweidenker.de';
      final spaceUri = SpaceUri(user: id, space: 'spaceId');

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        'spaceUris': [
          '/api/users/id/spaces/spaceId',
        ]
      });

      expect(jsonUser.id, equals(id));
      expect(jsonUser.firstName, equals(firstName));
      expect(jsonUser.lastName, equals(lastName));
      expect(jsonUser.email, equals(email));
      expect(jsonUser.spaces.length, equals(1));
      expect(jsonUser.spaces[0], equals(spaceUri));
    });

    test('From Json, toJson equals', () {
      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        'spaceUris': [
          '/api/users/id/spaces/spaceId',
        ]
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
      final spaceUri = SpaceUri(user: id, space: 'spaceId');

      final plain = User(
        email: email,
        lastName: lastName,
        firstName: firstName,
        id: id,
        spaces: [spaceUri],
      );

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        'spaceUris': [
          '/api/users/id/spaces/spaceId',
        ]
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
        spaces: [],
      );

      final jsonUser = User.fromJson({
        'id': 'id',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane.doe@zweidenker.de',
        'spaceUris': [
          '/api/users/id/spaces/spaceId',
        ]
      });

      expect(plain, isNot(jsonUser));
      expect(plain.hashCode, isNot(jsonUser.hashCode));
    });
  });
}
