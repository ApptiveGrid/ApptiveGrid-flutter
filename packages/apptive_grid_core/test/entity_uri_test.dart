// ignore_for_file: deprecated_member_use_from_same_package

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final entityUri = EntityUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/787878',
      );

      expect(
        entityUri.uri,
        equals(
          Uri.parse(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/787878',
          ),
        ),
      );
    });

    test('From Generated Uri String matches original', () {
      final direct = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '787878',
      );
      final parsed = EntityUri.fromUri(direct.uri.toString());
      expect(parsed, equals(direct));
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = EntityUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/787878',
      );
      final direct = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '787878',
      );
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
    });

    test('Different Values do not equal', () {
      final one = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '787878',
      );
      final two = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '878787',
      );
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });
}
