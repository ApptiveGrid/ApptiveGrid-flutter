import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:collection/collection.dart';

/// A class representing a response containing paged entities, extending the [EntitiesResponse] class.
class PagedEntitiesResponse extends EntitiesResponse {
  /// Constructs a new [PagedEntitiesResponse] instance from a JSON [Map].
  factory PagedEntitiesResponse.fromJson(
    dynamic json, {
    required Uri requestUri,
  }) {
    return PagedEntitiesResponse(
        numberOfItems: json['numberOfItems'],
        numberOfPages: json['numberOfPages'],
        size: json['size'],
        pages: {
          json['page']: EntitiesResponse(items: json['items']),
        },
        requestUri: requestUri);
  }

  /// Constructs a new [PagedEntitiesResponse].
  ///
  /// [numberOfItems] is the total number of entities in the response.
  /// [numberOfPages] is the total number of pages in the response.
  /// [size] is the number of entities in each page.
  /// [pages] is a [Map] of page numbers to [EntitiesResponse] objects.
  PagedEntitiesResponse({
    required this.numberOfItems,
    required this.numberOfPages,
    required this.size,
    required this.pages,
    required this.requestUri,
  }) : super();

  /// The total number of entities in the response.
  final int numberOfItems;

  /// The total number of pages in the response.
  final int numberOfPages;

  /// The number of entities in each page.
  final int size;

  /// A [Map] of page numbers to [EntitiesResponse] objects.
  final Map<int, EntitiesResponse> pages;

  /// The [Uri], with which the last request for pages was made
  final Uri requestUri;

  /// Returns a flattened list of all items in all pages.
  @override
  List<dynamic> get items => pages.values
      .fold([], (previousValue, page) => previousValue + page.items);

  /// Returns the next page index if available
  int? get nextPage => hasNextPage ? (pages.keys.maxOrNull ?? 0) + 1 : null;

  /// Returns true if the latest page is not the last one
  bool get hasNextPage => numberOfPages > (pages.keys.maxOrNull ?? 0);

  /// Checks if a given page index is valid
  bool pageIsValid(int pageIndex) =>
      pageIndex > 0 && pageIndex <= numberOfPages;

  /// Constructs a new [PagedEntitiesResponse] with the meta data of update and a combination of the pages of both. The pages of the update take priority here.
  /// This also adds the new pages to this [PagedEntitiesResponse].
  PagedEntitiesResponse updateWith(PagedEntitiesResponse update) {
    pages.addAll(update.pages);
    return PagedEntitiesResponse(
      numberOfItems: update.numberOfItems,
      numberOfPages: update.numberOfPages,
      size: update.size,
      requestUri: update.requestUri,
      pages: pages,
    );
  }
}
