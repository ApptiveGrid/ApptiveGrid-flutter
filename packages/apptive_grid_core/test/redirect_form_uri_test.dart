import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final redirectFormUri = RedirectFormUri.fromUri('/api/a/787878');

      expect(redirectFormUri.uriString, '/api/a/787878');
    });

    test('Malformatted Uri throws ArgumentError', () {
      const uri = '/api/a';
      expect(
        () => RedirectFormUri.fromUri(uri),
        throwsA(
          predicate<ArgumentError>(
            (e) => e.message == 'Could not parse FormUri $uri',
            'ArgumentError with specific Message',
          ),
        ),
      );
    });

    test('From Generated Uri String matches original', () {
      final direct = RedirectFormUri(components: ['787878']);
      final parsed = RedirectFormUri.fromUri(direct.uriString);
      expect(parsed == direct, true);
    });

    test('Correct Api String reflects in uri', () {
      final direct = RedirectFormUri(components: ['787878']);

      expect(direct.uriString, '/api/a/787878');
    });

    test('/a/ and /r/ links are equal', () {
      final aUri = RedirectFormUri.fromUri('/api/a/787878');
      final rUri = RedirectFormUri.fromUri('/api/r/787878');

      expect(aUri, rUri);
    });

    test('Updated Link Format Parses', () {
      final uri = RedirectFormUri.fromUri('/api/a/787878/ababab');

      expect(uri.uriString, '/api/a/787878/ababab');
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = RedirectFormUri.fromUri('/api/a/787878');
      final direct = RedirectFormUri(components: ['787878']);
      expect(parsed == direct, true);
      expect(parsed.hashCode - direct.hashCode, 0);
    });

    test('Different Values do not equal', () {
      final one = RedirectFormUri(components: ['787878']);
      final two = RedirectFormUri(components: ['878787']);
      expect(one == two, false);
      expect((one.hashCode - two.hashCode) != 0, true);
    });
  });
}
