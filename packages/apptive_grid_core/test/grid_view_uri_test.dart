// ignore_for_file: deprecated_member_use_from_same_package

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final gridViewUri = GridViewUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/views/9999',
      );

      expect(
        gridViewUri.uri,
        equals(
          Uri.parse(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/views/9999',
          ),
        ),
      );
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = GridViewUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/views/9999',
      );
      final direct = GridViewUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        view: '9999',
      );
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
    });

    test('Different Values do not equal', () {
      final one = GridViewUri(
        user: '12345',
        space: 'asdf',
        grid: '1a2s3d4',
        view: '9999',
      );
      final two = GridViewUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        view: '8888',
      );
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });
}
