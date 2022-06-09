// ignore_for_file: deprecated_member_use_from_same_package

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From UriString parses correctly', () {
      final redirectFormUri = RedirectFormUri.fromUri('/api/a/787878');

      expect(redirectFormUri.uri.toString(), equals('/api/a/787878'));
    });

    test('From Generated Uri String matches original', () {
      final direct = RedirectFormUri(components: ['787878']);
      final parsed = RedirectFormUri.fromUri(direct.uri.toString());
      expect(parsed, equals(direct));
    });

    test('Correct Api String reflects in uri', () {
      final direct = RedirectFormUri(components: ['787878']);

      expect(direct.uri.toString(), equals('/api/a/787878'));
    });

    test('/a/ and /r/ links are equal', () {
      final aUri = RedirectFormUri.fromUri('/api/a/787878');
      final rUri = RedirectFormUri.fromUri('/api/r/787878');

      expect(aUri, equals(rUri));
    });

    test('Updated Link Format Parses', () {
      final uri = RedirectFormUri.fromUri('/api/a/787878/ababab');

      expect(uri.uri.toString(), equals('/api/a/787878/ababab'));
    });
  });

  group('Equality', () {
    test('From UriString equals to direct invocation', () {
      final parsed = RedirectFormUri.fromUri('/api/a/787878');
      final direct = RedirectFormUri(components: ['787878']);
      expect(parsed, equals(direct));
      expect(parsed.hashCode, equals(direct.hashCode));
    });

    test('Different Values do not equal', () {
      final one = RedirectFormUri(components: ['787878']);
      final two = RedirectFormUri(components: ['878787']);
      expect(one, isNot(two));
      expect(one.hashCode, isNot(two.hashCode));
    });
  });
}
