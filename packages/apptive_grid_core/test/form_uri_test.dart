import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: deprecated_member_use_from_same_package
void main() {
  group('Direct FormUri', () {
    group('Parsing', () {
      test('From UriString parses correctly', () {
        final gridUri = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');

        expect(gridUri.uriString,
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
      });

      test('Malformatted Uri throws ArgumentError', () {
        const uri = '/api/users/123456/spaces/asdfg/';
        expect(
            () => FormUri.fromUri(uri),
            throwsA(predicate<ArgumentError>(
                (e) => e.message == 'Could not parse FormUri $uri',
                'ArgumentError with specific Message')));
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
        final direct = FormUri.directForm(
            user: '123456', space: 'asdfg', grid: '1a2s3d4f', form: 'a1s2d3f4');
        expect(parsed == direct, true);
        expect(parsed.hashCode - direct.hashCode, 0);
      });

      test('Different Values do not equal', () {
        final one = FormUri.fromUri(
            '/api/users/123456/spaces/asdfg/grids/1a2s3d4f/forms/a1s2d3f4');
        final two = FormUri.directForm(
            user: '123456',
            space: 'asdfg',
            grid: '1a2s3d4f',
            form: 'a1s2d3f45');
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
        const uri = '/api/a';
        expect(
            () => FormUri.fromUri(uri),
            throwsA(predicate<ArgumentError>(
                (e) => e.message == 'Could not parse FormUri $uri',
                'ArgumentError with specific Message')));
      });
    });

    group('Equality', () {
      test('From UriString equals to direct invocation', () {
        final parsed = FormUri.fromUri('/api/r/a1s2d3f4');
        final direct = FormUri.redirectForm(form: 'a1s2d3f4');
        expect(parsed == direct, true);
        expect(parsed.hashCode - direct.hashCode, 0);
      });

      test('Different Values do not equal', () {
        final one = FormUri.fromUri('/api/r/a1s2d3f4');
        final two = FormUri.redirectForm(form: 'a1s2d3f45');
        expect(one == two, false);
        expect((one.hashCode - two.hashCode) != 0, true);
      });
    });
  });
}
