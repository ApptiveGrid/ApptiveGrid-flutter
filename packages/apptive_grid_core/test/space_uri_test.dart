import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final spaceUri = SpaceUri.fromUri('/api/users/123456/spaces/asdfg/');

      expect(
        spaceUri.uri,
        equals(Uri.parse('/api/users/123456/spaces/asdfg/')),
      );
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed =
          SpaceUri.fromUri('/api/users/123456/spaces/asdfg');
      final direct = SpaceUri(
        user: '123456',
        space: 'asdfg',
      );
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
    });

    test('Different Values do not equal', () {
      final one = SpaceUri(
        user: '12345',
        space: 'asdf',
      );
      final two = SpaceUri(
        user: '123456',
        space: 'asdfg',
      );
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });
}
