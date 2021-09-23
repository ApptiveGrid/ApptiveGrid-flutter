import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final directFormUri = DirectFormUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878',
      );

      expect(directFormUri.user, '123456');
      expect(directFormUri.space, 'asdfg');
      expect(directFormUri.grid, '1a2s3d4f');
      expect(directFormUri.form, '787878');
    });

    test('Malformatted Uri throws ArgumentError', () {
      const uri = '/api/users/123456/spaces/asdfg/grids/1a2s3d4f';
      expect(
        () => DirectFormUri.fromUri(uri),
        throwsA(
          predicate<ArgumentError>(
            (e) => e.message == 'Could not parse FormUri $uri',
            'ArgumentError with specific Message',
          ),
        ),
      );
    });

    test('From Generated Uri String matches original', () {
      final direct = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      );
      final parsed = DirectFormUri.fromUri(direct.uriString);
      expect(parsed == direct, true);
    });

    test('Without Entity reflects in uri', () {
      final direct = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      );

      expect(
        direct.uriString,
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878',
      );
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = DirectFormUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878',
      );
      final direct = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      );
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
    });

    test('Different Values do not equal', () {
      final one = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      );
      final two = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '878787',
      );
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });

  group('Entity', () {
    test('With Entity reflects in uri', () {
      final entityUri = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '909090',
      );
      final direct = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      ).forEntity(entity: entityUri);

      expect(
        direct.uriString,
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878?uri=/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/909090',
      );
    });

    test('Parse URI with Entity', () {
      final entityUri = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '787878',
      );
      final direct = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      ).forEntity(entity: entityUri);

      final parsed = DirectFormUri.fromUri(direct.uriString);
      expect(parsed, direct);
    });
  });
}
