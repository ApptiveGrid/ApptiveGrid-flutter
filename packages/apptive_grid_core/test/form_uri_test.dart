import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Direct FormUri', () {
    group('Parsing', () {
      test('From UriString parses correctly', () {
        final formUri = DirectFormUri.fromUri(
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4',
        );

        expect(
          formUri.uri.toString(),
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4',
        );
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = DirectFormUri.fromUri(
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4',
        );
        final direct = DirectFormUri(
          user: '123456',
          space: 'asdfg',
          grid: '1a2s3d4f',
          form: 'a1s2d3f4',
        );
        expect(parsed, equals(direct));
        expect(parsed.hashCode, equals(direct.hashCode));
      });

      test('Different Values do not equal', () {
        final one = DirectFormUri.fromUri(
          '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4',
        );
        final two = DirectFormUri(
          user: '123456',
          space: 'asdfg',
          grid: '1a2s3d4f',
          form: 'a1s2d3f45',
        );
        expect(one, isNot(two));
        expect(one.hashCode, isNot(two.hashCode));
      });
    });
  });

  group('Redirect FormUri', () {
    group('Parsing', () {
      test('From UriString parses correctly', () {
        final formUri = DirectFormUri.fromUri('/api/r/a1s2d3f4');

        expect(formUri.uri.toString(), equals('/api/a/a1s2d3f4'));
      });

      test('Direct api  UriString parses correctly', () {
        final formUri = DirectFormUri.fromUri('/api/a/a1s2d3f4');

        expect(formUri.uri.toString(), equals('/api/a/a1s2d3f4'));
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = RedirectFormUri.fromUri('/api/r/a1s2d3f4');
        final direct = RedirectFormUri(components: ['a1s2d3f4']);
        expect(parsed, equals(direct));
        expect(parsed.hashCode, equals(direct.hashCode));
      });

      test('Different Values do not equal', () {
        final one = RedirectFormUri.fromUri('/api/r/a1s2d3f4');
        final two = RedirectFormUri(components: ['a1s2d3f45']);
        expect(one, isNot(two));
        expect(one.hashCode, isNot(two.hashCode));
      });
    });
  });
}
