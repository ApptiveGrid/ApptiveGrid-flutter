import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final gridViewUri =
          GridViewUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f/views/9999');

      expect(gridViewUri.user, '123456');
      expect(gridViewUri.space, 'asdfg');
      expect(gridViewUri.grid, '1a2s3d4f');
      expect(gridViewUri.view, '9999');
    });

    test('Malformatted Uri throws ArgumentError', () {
      final uri = '/api/users/123456/spaces/asdfg/';
      expect(
          () => GridViewUri.fromUri(uri),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'Could not parse GridViewUri $uri',
              'ArgumentError with specific Message')));
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed =
          GridViewUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f/views/9999');
      final direct = GridViewUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f', view: '9999');
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
    });

    test('Different Values do not equal', () {
      final one = GridViewUri(user: '12345', space: 'asdf', grid: '1a2s3d4', view: '9999');
      final two = GridViewUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f', view: '8888');
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });
}
