import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equality', () {
    test('Equals', () {
      final response = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0', 'test1']),
          2: const EntitiesResponse(items: ['test2', 'test3']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );
      final response2 = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0', 'test1']),
          2: const EntitiesResponse(items: ['test2', 'test3']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );

      expect(response, equals(response2));
    });

    test('UnEqual', () {
      final response = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0', 'test1']),
          2: const EntitiesResponse(items: ['test2', 'test3']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );
      final response2 = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0', 'test0']),
          2: const EntitiesResponse(items: ['test2', 'test2']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );

      expect(response, isNot(response2));
    });
  });

  test('Hashcode', () {
    final response = PagedEntitiesResponse(
      pages: {
        1: const EntitiesResponse(items: ['test0', 'test1']),
        2: const EntitiesResponse(items: ['test2', 'test3']),
      },
      requestUri: Uri.parse('/test'),
      numberOfItems: 10,
      numberOfPages: 5,
      size: 2,
    );

    expect(
      response.hashCode,
      Object.hash(
        response.pages,
        response.requestUri,
        response.numberOfItems,
        response.numberOfPages,
        response.size,
      ),
    );
  });

  test('toString()', () {
    final response = PagedEntitiesResponse(
      pages: {
        1: const EntitiesResponse(items: ['test']),
      },
      requestUri: Uri.parse('/test'),
      numberOfItems: 5,
      numberOfPages: 5,
      size: 1,
    );

    expect(
      response.toString(),
      equals(
        'PagedEntitiesResponse(numberOfItems: 5, numberOfPages: 5, size: 1, pages: {1: EntitiesResponse(items: [test])}, requestUri: /test)',
      ),
    );
  });

  group('Paging', () {
    test('Item contain all pages', () {
      final response = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0', 'test1']),
          2: const EntitiesResponse(items: ['test2', 'test3']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 10,
        numberOfPages: 5,
        size: 2,
      );

      expect(response.items, equals(['test0', 'test1', 'test2', 'test3']));
    });

    test('Next page', () {
      final response = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0']),
          2: const EntitiesResponse(items: ['test1']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 5,
        numberOfPages: 5,
        size: 1,
      );

      expect(response.nextPage, equals(3));

      expect(response.hasNextPage, isTrue);
    });

    test('Next page is null if at max pages', () {
      final response = PagedEntitiesResponse(
        pages: {
          1: const EntitiesResponse(items: ['test0']),
          2: const EntitiesResponse(items: ['test1']),
        },
        requestUri: Uri.parse('/test'),
        numberOfItems: 2,
        numberOfPages: 2,
        size: 1,
      );

      expect(response.nextPage, equals(null));

      expect(response.hasNextPage, isFalse);
    });

    test('Next page is 1 if no pages loaded', () {
      final response = PagedEntitiesResponse(
        pages: {},
        requestUri: Uri.parse('/test'),
        numberOfItems: 2,
        numberOfPages: 2,
        size: 1,
      );

      expect(response.nextPage, equals(1));

      expect(response.hasNextPage, isTrue);
    });

    test('Page validity', () {
      final response = PagedEntitiesResponse(
        pages: {},
        requestUri: Uri.parse('/test'),
        numberOfItems: 2,
        numberOfPages: 2,
        size: 1,
      );

      expect(response.pageIsValid(0), isFalse);

      expect(response.pageIsValid(1), isTrue);

      expect(response.pageIsValid(2), isTrue);

      expect(response.pageIsValid(3), isFalse);
    });

    group('Updating', () {
      test('Update with new page', () {
        final response = PagedEntitiesResponse(
          pages: {
            1: const EntitiesResponse(items: ['test0', 'test1']),
          },
          requestUri: Uri.parse('/test?pageIndex=1'),
          numberOfItems: 10,
          numberOfPages: 5,
          size: 2,
        );
        final update = PagedEntitiesResponse(
          pages: {
            2: const EntitiesResponse(items: ['test2', 'test3']),
          },
          requestUri: Uri.parse('/test?pageIndex=2'),
          numberOfItems: 9,
          numberOfPages: 5,
          size: 2,
        );

        final updatedResponse = response.updateWith(update);

        expect(updatedResponse.numberOfItems, equals(update.numberOfItems));
        expect(updatedResponse.numberOfPages, equals(update.numberOfPages));
        expect(updatedResponse.size, equals(update.size));
        expect(updatedResponse.requestUri, equals(update.requestUri));
        expect(updatedResponse.nextPage, equals(update.nextPage));

        expect(
          updatedResponse.pages,
          equals({
            ...response.pages,
            ...update.pages,
          }),
        );
        expect(updatedResponse.pages, equals(response.pages));
        for (var pageIndex in update.pages.keys) {
          expect(
            updatedResponse.pages[pageIndex],
            equals(update.pages[pageIndex]),
          );
        }
      });
      test('Update existing page', () {
        final response = PagedEntitiesResponse(
          pages: {
            1: const EntitiesResponse(items: ['test0', 'test1']),
            2: const EntitiesResponse(items: ['test2', 'test3']),
          },
          requestUri: Uri.parse('/test?pageIndex=1'),
          numberOfItems: 10,
          numberOfPages: 5,
          size: 2,
        );
        final update = PagedEntitiesResponse(
          pages: {
            1: const EntitiesResponse(items: ['test4', 'test5']),
            2: const EntitiesResponse(items: ['test2', 'test3']),
          },
          requestUri: Uri.parse('/test?pageIndex=1'),
          numberOfItems: 9,
          numberOfPages: 5,
          size: 2,
        );

        final updatedResponse = response.updateWith(update);

        expect(updatedResponse.numberOfItems, equals(update.numberOfItems));
        expect(updatedResponse.numberOfPages, equals(update.numberOfPages));
        expect(updatedResponse.size, equals(update.size));
        expect(updatedResponse.requestUri, equals(update.requestUri));
        expect(updatedResponse.nextPage, equals(update.nextPage));

        expect(
          updatedResponse.pages,
          equals({
            ...response.pages,
            ...update.pages,
          }),
        );
        expect(updatedResponse.pages, equals(response.pages));
        expect(updatedResponse.pages, equals(update.pages));
      });
    });
  });
}
