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

      expect(jsonUser.id, id);
      expect(jsonUser.firstName, firstName);
      expect(jsonUser.lastName, lastName);
      expect(jsonUser.email, email);
      expect(jsonUser.spaces.length, 1);
      expect(jsonUser.spaces[0], spaceUri);
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

      expect(doubleParse, jsonUser);
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

      expect(plain == jsonUser, true);
      expect((plain.hashCode - jsonUser.hashCode) == 0, true);
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

      expect(plain == jsonUser, false);
      expect((plain.hashCode - jsonUser.hashCode) == 0, false);
    });
  });
}
