import 'package:active_grid_core/active_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Direct FormUri', () {
    group('Parsing', () {
      test('From UriString parses correctly', () {
        final gridUri = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');

        expect(gridUri.uriString, '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
      });

      test('Malformatted Uri throws ArgumentError', () {
        expect(() => FormUri.fromUri('/api/users/123456/spaces/asdfg/'),
            throwsArgumentError);
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
        final direct = FormUri.fromDirectUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f', form: 'a1s2d3f4');
        expect(parsed == direct, true);
        expect(parsed.hashCode - direct.hashCode, 0);
      });

      test('Different Values do not equal', () {
        final one = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
        final two = FormUri.fromDirectUri(user: '123456', space: 'asdfg', grid: '1a2s3d4f', form: 'a1s2d3f45');
        expect(one == two, false);
        expect((one.hashCode - two.hashCode) != 0, true);
      });
    });
  });

  group('Redirect FormUri', () {
    group('Parsing', () {
      test('From UriString parses correctly', () {
        final gridUri = FormUri.fromUri('/api/r/a1s2d3f4');

        expect(gridUri.uriString, '/api/a/a1s2d3f4');
      });

      test('Direct api  UriString parses correctly', () {
        final gridUri = FormUri.fromUri('/api/a/a1s2d3f4');

        expect(gridUri.uriString, '/api/a/a1s2d3f4');
      });

      test('Malformatted Uri throws ArgumentError', () {
        expect(() => FormUri.fromUri('/api/a/'),
            throwsArgumentError);
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = FormUri.fromUri('/api/r/a1s2d3f4');
        final direct = FormUri.fromRedirectUri(form: 'a1s2d3f4');
        expect(parsed == direct, true);
        expect(parsed.hashCode - direct.hashCode, 0);
      });

      test('Different Values do not equal', () {
        final one = FormUri.fromUri('/api/r/a1s2d3f4');
        final two = FormUri.fromRedirectUri(form: 'a1s2d3f45');
        expect(one == two, false);
        expect((one.hashCode - two.hashCode) != 0, true);
      });
    });
  });
}