import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      const response = PageMetaData(
        page: 1,
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );
      const response2 = PageMetaData(
        page: 1,
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );

      expect(response, equals(response2));
    });

    test('UnEqual', () {
      const response = PageMetaData(
        page: 1,
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );
      const response2 = PageMetaData(
        page: 1,
        numberOfItems: 10,
        numberOfPages: 7,
        size: 2,
      );

      expect(response, isNot(response2));
    });
  });

  test('Hashcode', () {
    const response = PageMetaData(
      page: 1,
      numberOfItems: 10,
      numberOfPages: 5,
      size: 2,
    );

    expect(
      response.hashCode,
      Object.hash(
        response.page,
        response.numberOfItems,
        response.numberOfPages,
        response.size,
      ),
    );
  });

  test('toString()', () {
    const response = PageMetaData(
      page: 1,
      numberOfItems: 10,
      numberOfPages: 5,
      size: 2,
    );

    expect(
      response.toString(),
      equals(
        'PageMetaData(numberOfItems: 10, numberOfPages: 5, size: 2, page: 1)',
      ),
    );
  });
}
