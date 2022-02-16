import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('Successful Parse', () {
      const uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
      const method = 'POST';

      final json = {
        'uri': uri,
        'method': method,
      };

      final action = FormAction.fromJson(json);

      expect(action.uri, equals(uri));
      expect(action.method, equals(method));
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      const uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
      const method = 'POST';

      final action = FormAction(uri, method);

      expect(FormAction.fromJson(action.toJson()), equals(action));
    });
  });

  group('Equality', () {
    const uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
    const method = 'POST';

    final json = {
      'uri': uri,
      'method': method,
    };

    final a = FormAction(uri, method);
    final b = FormAction.fromJson(json);
    final c = FormAction(method, uri);

    test('a == b', () {
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a != c', () {
      expect(a, isNot(c));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('ActionItem', () {
    test('Equality Test', () {
      final actionA = FormAction('uri', 'method');
      final actionB = FormAction('uri', 'methodB');

      final data = FormData(
        name: 'name',
        title: 'title',
        components: [],
        actions: [],
        schema: {},
      );

      final a = ActionItem(action: actionA, data: data);
      final b = ActionItem(action: actionA, data: data);
      final c = ActionItem(action: actionB, data: data);

      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });
}
