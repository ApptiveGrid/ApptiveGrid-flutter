import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('Successful Parse', () {
      final uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
      final method = 'POST';

      final json = {
        'uri': uri,
        'method': method,
      };

      final action = FormAction.fromJson(json);

      expect(action.uri, uri);
      expect(action.method, method);
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      final uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
      final method = 'POST';

      final action = FormAction(uri, method);

      expect(FormAction.fromJson(action.toJson()), action);
    });
  });

  group('Equality', () {
    final uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
    final method = 'POST';

    final json = {
      'uri': uri,
      'method': method,
    };

    final a = FormAction(uri, method);
    final b = FormAction.fromJson(json);
    final c = FormAction(method, uri);

    test('a == b', () {
      expect(a == b, true);
      expect(a.hashCode - b.hashCode, 0);
    });

    test('a != c', () {
      expect(a == c, false);
      expect((a.hashCode - c.hashCode) == 0, false);
    });
  });
}
