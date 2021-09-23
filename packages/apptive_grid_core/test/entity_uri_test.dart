import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final entityUri = EntityUri.fromUri(
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/787878');

      expect(entityUri.user, '123456');
      expect(entityUri.space, 'asdfg');
      expect(entityUri.grid, '1a2s3d4f');
      expect(entityUri.entity, '787878');
    });

    test('Malformatted Uri throws ArgumentError', () {
      const uri = '/api/users/123456/spaces/asdfg/grids/124124';
      expect(
          () => EntityUri.fromUri(uri),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'Could not parse EntityUri $uri',
              'ArgumentError with specific Message')));
    });

    test('From Generated Uri String matches original', () {
      final direct = EntityUri(
          user: '123456', space: 'asdfg', grid: '1a2s3d4f', entity: '787878');
      final parsed = EntityUri.fromUri(direct.uriString);
      expect(parsed == direct, true);
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = EntityUri.fromUri(
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/787878');
      final direct = EntityUri(
          user: '123456', space: 'asdfg', grid: '1a2s3d4f', entity: '787878');
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
    });

    test('Different Values do not equal', () {
      final one = EntityUri(
          user: '123456', space: 'asdfg', grid: '1a2s3d4f', entity: '787878');
      final two = EntityUri(
          user: '123456', space: 'asdfg', grid: '1a2s3d4f', entity: '878787');
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });
}
