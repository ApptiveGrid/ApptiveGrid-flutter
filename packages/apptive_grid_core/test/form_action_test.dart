// ignore_for_file: deprecated_member_use_from_same_package

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActionItem', () {
    test('Equality Test', () {
      final actionA = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final actionB = ApptiveLink(uri: Uri.parse('uri'), method: 'methodB');

      final data = FormData(
        id: 'formId',
        name: 'name',
        title: 'title',
        components: [],
        fields: [],
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
  });
}
