import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Response when loading entities of a Grid with [ApptiveGridClient.loadEntities]
class EntitiesResponse<T> {
  /// Constructs a new [EntitiesResponse] instance from a JSON [Map].
  factory EntitiesResponse.fromJson(dynamic json) => switch (json) {
        {
          'item': List items,
        } =>
          EntitiesResponse(
            items: items.cast<T>(),
            pageMetaData: PageMetaData.fromJson(json),
          ),
        List items => EntitiesResponse(items: items.cast<T>()),
        _ => throw ArgumentError.value(
            json,
            'Invalid EntitiesResponse json: $json',
          ),
      };

  /// Creates a new Response Object with [items] and [pageMetaData]
  const EntitiesResponse({
    this.items = const [],
    this.pageMetaData,
  });

  /// Items of the Response
  final List<T> items;

  /// Contains the meta data for paging if available
  final PageMetaData? pageMetaData;

  @override
  String toString() =>
      'EntitiesResponse(items: $items, pageMetaData: $pageMetaData)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitiesResponse &&
            f.listEquals(other.items, items) &&
            pageMetaData == other.pageMetaData;
  }

  @override
  int get hashCode => items.hashCode;

  /// Copies this Object with provided arguments
  EntitiesResponse copyWith({List<T>? items, PageMetaData? pageMetaData}) {
    return EntitiesResponse(
      items: items ?? this.items,
      pageMetaData: pageMetaData ?? this.pageMetaData,
    );
  }
}

/// A class representing a response containing the paging meta data.
class PageMetaData {
  /// Constructs a new [PageMetaData] instance from a JSON [Map].
  factory PageMetaData.fromJson(dynamic json) => switch (json) {
        {
          'numberOfItems': int numberOfItems,
          'numberOfPages': int numberOfPages,
          'size': int size,
          'page': int page,
        } =>
          PageMetaData(
            numberOfItems: numberOfItems,
            numberOfPages: numberOfPages,
            size: size,
            page: page,
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid PageMetaData json: $json',
          ),
      };

  /// Constructs a new [PageMetaData].
  ///
  /// [numberOfItems] is the total number of entities in the response.
  /// [numberOfPages] is the total number of pages in the response.
  /// [size] is the number of entities in each page.
  /// [page] is the current page index (starting at 1).
  const PageMetaData({
    required this.numberOfItems,
    required this.numberOfPages,
    required this.size,
    required this.page,
  }) : super();

  /// The total number of entities available.
  final int numberOfItems;

  /// The total number of pages available.
  final int numberOfPages;

  /// The number of entities in each page.
  final int size;

  /// The current page index (starting at 1).
  final int page;

  @override
  String toString() {
    return 'PageMetaData(numberOfItems: $numberOfItems, numberOfPages: $numberOfPages, size: $size, page: $page)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageMetaData &&
          runtimeType == other.runtimeType &&
          numberOfItems == other.numberOfItems &&
          numberOfPages == other.numberOfPages &&
          size == other.size &&
          page == other.page;

  @override
  int get hashCode => Object.hash(
        page,
        numberOfItems,
        numberOfPages,
        size,
      );
}
