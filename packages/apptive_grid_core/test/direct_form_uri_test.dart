import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final directFormUri = DirectFormUri.fromUri(
        '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878',
      );

      expect(
        directFormUri.uri,
        equals(
          Uri.parse(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878',
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
      expect(parsed, equals(direct));
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
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
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
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });

  group('Entity', () {
    test('FormUri for Entity reflects in uri', () {
      final entityUri = EntityUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        entity: '909090',
      );
      final forEntity = DirectFormUri(
        user: '123456',
        space: 'asdfg',
        grid: '1a2s3d4f',
        form: '787878',
      ).forEntity(entity: entityUri);

      expect(
        forEntity.uri,
        equals(
          Uri.parse(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878?uri=/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/909090',
          ),
        ),
      );
    });

      test('DirectFormUri with Entity reflects in uri', () {
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
          entity: entityUri,
        );

        expect(
          direct.uri,
          equals(
            Uri.parse(
              '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/787878?uri=/api/users/123456/spaces/asdfg/grids/1a2s3d4f/entities/909090',
            ),
          ),
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
      expect(parsed, equals(direct));
    });
  });
}
