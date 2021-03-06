import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormComponentOptions', () {
    group('Equality', () {
      const a = FormComponentOptions(
        label: 'Label',
        placeholder: 'Placeholder',
        description: 'Description',
      );
      final b = FormComponentOptions.fromJson({
        'label': 'Label',
        'placeholder': 'Placeholder',
        'description': 'Description',
      });
      const c = FormComponentOptions();

      test('a == b', () {
        expect(a, equals(b));
      });

      test('a != c', () {
        expect(a, isNot(c));
        expect(a.hashCode, isNot(c.hashCode));
      });
    });
  });

  group('FormComponentOptions', () {
    group('Equality', () {
      const a =
          FormComponentOptions(label: 'Label', description: 'Description');
      final b = FormComponentOptions.fromJson({
        'label': 'Label',
        'description': 'Description',
      });
      const c = FormComponentOptions(
        label: 'Label',
        description: 'Other Description',
      );

      test('a == b', () {
        expect(a, equals(b));
      });

      test('a != c', () {
        expect(a, isNot(c));
        expect(a.hashCode, isNot(c.hashCode));
      });
    });
  });
}
