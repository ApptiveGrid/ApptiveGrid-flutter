import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      final a = ApptiveLink(uri: Uri.parse('uri.toParse'), method: 'get');
      final b = ApptiveLink(uri: Uri.parse('uri.toParse'), method: 'get');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('In Equality', () {
      final reference =
          ApptiveLink(uri: Uri.parse('uri.toParse'), method: 'get');
      final uri =
          ApptiveLink(uri: Uri.parse('different.uri.toParse'), method: 'get');
      final method = ApptiveLink(uri: Uri.parse('uri.toParse'), method: 'post');

      expect(reference, isNot(equals(uri)));
      expect(reference.hashCode, isNot(equals(uri.hashCode)));
      expect(reference, isNot(equals(method)));
      expect(reference.hashCode, isNot(equals(method.hashCode)));
    });

    test('From Json', () {
      final reference =
          ApptiveLink(uri: Uri.parse('uri.toParse'), method: 'get');

      final json = {
        'href': 'uri.toParse',
        'method': 'get',
      };

      expect(ApptiveLink.fromJson(json), equals(reference));
      expect(reference.toJson(), equals(json));
    });
  });
}
