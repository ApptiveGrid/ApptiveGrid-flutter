import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      const response = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'B'},
        ],
      );
      const response2 = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'B'},
        ],
      );

      expect(response, equals(response2));
      expect(response.hashCode, equals(response2.hashCode));
    });

    test('UnEqual', () {
      const response = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'B'},
        ],
      );
      const response2 = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'C'},
        ],
      );

      expect(response, isNot(response2));
      expect(response.hashCode, isNot(response2.hashCode));
    });
  });

  group('Copy with', () {
    test('Copy with values', () {
      const response = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'B'},
        ],
      );
      const response2 = EntitiesResponse(
        items: [
          {
            '1': 'A',
          },
          {'1': 'C'},
        ],
      );
      final response3 = response2.copyWith(items: response.items);
      final response4 = response.copyWith();

      expect(response2, isNot(response));
      expect(response2.hashCode, isNot(response.hashCode));
      expect(response3, equals(response));
      expect(response3.hashCode, equals(response.hashCode));
      expect(response4, equals(response));
      expect(response4.hashCode, equals(response.hashCode));
    });
  });
}
