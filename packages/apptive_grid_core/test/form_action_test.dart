// ignore_for_file: deprecated_member_use_from_same_package

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
      final actionA = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final actionB = ApptiveLink(uri: Uri.parse('uri'), method: 'methodB');

      final data = FormData(
        id: 'formId',
        name: 'name',
        title: 'title',
        components: [],
        schema: {},
        links: {},
      );

      final a = ActionItem(link: actionA, data: data);
      final b = ActionItem(link: actionA, data: data);
      final c = ActionItem(link: actionB, data: data);

      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });

    test('Deprecated Action', () {
      final action = FormAction('uri', 'method');
      final link = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final data = FormData(
        id: 'formId',
        name: 'name',
        title: 'title',
        components: [],
        schema: {},
        links: {},
      );
      expect(ActionItem(link: link, data: data).action, action);
    });
  });
}
