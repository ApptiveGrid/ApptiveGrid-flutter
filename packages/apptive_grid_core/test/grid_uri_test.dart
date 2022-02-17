import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final gridUri =
          GridUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f');

      expect(
        gridUri.uri,
        equals(Uri.parse('/api/users/123456/spaces/asdfg/grids/1a2s3d4f')),
      );
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed =
          GridUri.fromUri('/api/users/123456/spaces/asdfg/grids/1a2s3d4f');
      final direct = GridUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f');
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
    });

    test('Different Values do not equal', () {
      final one = GridUri(user: '12345', space: 'asdf', grid: '1a2s3d4');
      final two = GridUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f');
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });
}
