import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextComponentOptions', () {
    group('Equality', () {
      final a = TextComponentOptions(
        label: 'Label',
        placeholder: 'Placeholder',
        description: 'Description',
      );
      final b = TextComponentOptions.fromJson({
        'label': 'Label',
        'placeholder': 'Placeholder',
        'description': 'Description',
      });
      final c = TextComponentOptions();

      test('a == b', () {
        expect(a == b, true);
        expect(a.hashCode - b.hashCode, 0);
      });

      test('a != c', () {
        expect(a == c, false);
        expect((a.hashCode - c.hashCode) == 0, false);
      });
    });
  });

  group('FormComponentOptions', () {
    group('Equality', () {
      final a = FormComponentOptions(label: 'Label', description: 'Description');
      final b = FormComponentOptions.fromJson({
        'label': 'Label',
        'description': 'Description',
      });

      test('a == b', () {
        expect(a == b, true);
        expect(a.hashCode - b.hashCode, 0);
      });
    });
  });
}
