import 'package:active_grid_core/active_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final gridUri =
          GridUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f');

      expect(gridUri.user, '123456');
      expect(gridUri.space, 'asdfg');
      expect(gridUri.grid, '1a2s3d4f');
    });

    test('Malformatted Uri throws ArgumentError', () {
      expect(() => GridUri.fromUri('/api/users/123456/spaces/asdfg/'),
          throwsArgumentError);
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed =
          GridUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f');
      final direct = GridUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f');
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
    });

    test('Different Values do not equal', () {
      final one = GridUri(user: '12345', space: 'asdf', grid: '1a2s3d4');
      final two = GridUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f');
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });
}
