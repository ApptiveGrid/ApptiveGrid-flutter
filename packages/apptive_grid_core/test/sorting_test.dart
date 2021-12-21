import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApptiveGridSorting', () {
    test('Parses into correct request object', () {
      const ascending =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc);

      expect(ascending.toRequestObject(), equals({'fieldId': 'ascending'}));

      const descending =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.desc);

      expect(descending.toRequestObject(), equals({'fieldId': 'descending'}));
    });

    test('Copy With adjust values', () {
      const sort1 =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc);

      final copyWithField = sort1.copyWith(fieldId: 'newFieldId');
      final copyWithOrder = sort1.copyWith(order: SortOrder.desc);

      expect(
        copyWithField,
        equals(
          const ApptiveGridSorting(
            fieldId: 'newFieldId',
            order: SortOrder.asc,
          ),
        ),
      );
      expect(
        copyWithOrder,
        equals(
          const ApptiveGridSorting(
            fieldId: 'fieldId',
            order: SortOrder.desc,
          ),
        ),
      );
    });

    test('Equality', () {
      const sort1 =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc);
      const sort2 =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc);
      const sort3 =
          ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.desc);

      expect(sort1, equals(sort2));
      expect(sort1.hashCode, equals(sort2.hashCode));

      expect(sort1, isNot(equals(sort3)));
      expect(sort1.hashCode, isNot(equals(sort3.hashCode)));
    });
  });

  group('DistanceApptiveGridSorting', () {
    test('Parses into correct request object', () {
      const ascending = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.asc,
        location: Geolocation(latitude: 47, longitude: 11),
      );

      expect(
        ascending.toRequestObject(),
        equals({
          'fieldId': {
            '\$order': 'ascending',
            '\$distanceTo': {
              'location': {'lat': 47.0, 'lon': 11.0}
            },
          }
        }),
      );

      const descending = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.desc,
        location: Geolocation(latitude: 47, longitude: 11),
      );

      expect(
        descending.toRequestObject(),
        equals({
          'fieldId': {
            '\$order': 'descending',
            '\$distanceTo': {
              'location': {'lat': 47.0, 'lon': 11.0}
            },
          }
        }),
      );
    });

    test('Copy With adjust values', () {
      const sort1 = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.asc,
        location: Geolocation(latitude: 47, longitude: 11),
      );

      final copyWithField = sort1.copyWith(fieldId: 'newFieldId');
      final copyWithOrder = sort1.copyWith(order: SortOrder.desc);
      final copyWithLocation = sort1.copyWith(
        location: const Geolocation(latitude: 11, longitude: 47),
      );

      expect(
        copyWithField,
        equals(
          const DistanceApptiveGridSorting(
            fieldId: 'newFieldId',
            order: SortOrder.asc,
            location: Geolocation(latitude: 47, longitude: 11),
          ),
        ),
      );
      expect(
        copyWithOrder,
        equals(
          const DistanceApptiveGridSorting(
            fieldId: 'fieldId',
            order: SortOrder.desc,
            location: Geolocation(latitude: 47, longitude: 11),
          ),
        ),
      );
      expect(
        copyWithLocation,
        equals(
          const DistanceApptiveGridSorting(
            fieldId: 'fieldId',
            order: SortOrder.asc,
            location: Geolocation(latitude: 11, longitude: 47),
          ),
        ),
      );
    });

    test('Equality', () {
      const sort1 = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.asc,
        location: Geolocation(latitude: 47, longitude: 11),
      );
      const sort2 = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.asc,
        location: Geolocation(latitude: 47, longitude: 11),
      );
      const sort3 = DistanceApptiveGridSorting(
        fieldId: 'fieldId',
        order: SortOrder.asc,
        location: Geolocation(latitude: 11, longitude: 47),
      );

      expect(sort1, equals(sort2));
      expect(sort1.hashCode, equals(sort2.hashCode));

      expect(sort1, isNot(equals(sort3)));
      expect(sort1.hashCode, isNot(equals(sort3.hashCode)));
    });
  });
}
