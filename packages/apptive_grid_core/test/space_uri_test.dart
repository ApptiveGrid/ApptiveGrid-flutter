import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final spaceUri = SpaceUri.fromUri('/api/users/123456/spaces/asdfg/');

      expect(spaceUri.user, '123456');
      expect(spaceUri.space, 'asdfg');
    });

    test('Too long Uri still produces correct SpaceUri', () {
      final spaceUri =
          SpaceUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f');

      expect(spaceUri.user, '123456');
      expect(spaceUri.space, 'asdfg');
    });

    test('Malformatted Uri throws ArgumentError', () {
      final uri = '/api/users/123456';
      expect(
          () => SpaceUri.fromUri(uri),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'Could not parse SpaceUri $uri',
              'ArgumentError with specific Message')));
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed =
          SpaceUri.fromUri('/api/users/123456/spaces/asdfg/spaces/1a2s3d4f');
      final direct = SpaceUri(
        user: '123456',
        space: 'asdfg',
      );
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
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
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });
}
