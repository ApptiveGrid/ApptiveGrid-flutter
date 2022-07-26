import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Order that entities can be sorted
enum SortOrder {
  /// Descending Order
  desc(requestValue: 'descending'),

  /// Ascending Sort Order
  asc(requestValue: 'ascending');

  /// Creates a new SortOrder
  const SortOrder({required this.requestValue});

  /// The Value used in the backend for the
  final String requestValue;
}

/// Basic Sorting operation
///
/// Sort classes may extend this class if they need more options for sorting
///
/// See [DistanceApptiveGridSorting]
class ApptiveGridSorting {
  /// Request entities to be sorted by the values of [fieldId] in [order]
  const ApptiveGridSorting({
    required this.fieldId,
    required this.order,
  });

  /// Field Id of the [GridField] the Items should be sorted by
  final String fieldId;

  /// Order the items should be
  final SortOrder order;

  /// Creates a map that the backend understands
  dynamic toRequestObject() => {fieldId: order.requestValue};

  @override
  String toString() {
    return '$runtimeType(${toRequestObject().toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridSorting &&
        fieldId == other.fieldId &&
        order == other.order;
  }

  @override
  int get hashCode => Object.hash(fieldId, order);

  /// Creates a new Version of [ApptiveGridSorting] changing the values of this with [fieldId] and [order] if they are not null
  ApptiveGridSorting copyWith({String? fieldId, SortOrder? order}) {
    return ApptiveGridSorting(
      fieldId: fieldId ?? this.fieldId,
      order: order ?? this.order,
    );
  }
}

/// [ApptiveGridSorting] that sorts items by distance to a specific [Geolocation]
class DistanceApptiveGridSorting extends ApptiveGridSorting {
  /// Creates a new sorting entity with [location]
  ///
  /// [fieldId] needs to be referencing a [GridField] with type [DataType.geolocation]
  const DistanceApptiveGridSorting({
    required this.location,
    required super.fieldId,
    required super.order,
  });

  /// Items will be sorted by the distance to this [location]
  final Geolocation location;

  @override
  toRequestObject() {
    return {
      fieldId: {
        '\$order': order.requestValue,
        '\$distanceTo': {
          'location': {
            'lat': location.latitude,
            'lon': location.longitude,
          }
        }
      }
    };
  }

  @override
  bool operator ==(Object other) {
    return other is DistanceApptiveGridSorting &&
        fieldId == other.fieldId &&
        order == other.order &&
        location == other.location;
  }

  @override
  int get hashCode => Object.hash(fieldId, order, location);

  @override
  DistanceApptiveGridSorting copyWith({
    String? fieldId,
    SortOrder? order,
    Geolocation? location,
  }) {
    return DistanceApptiveGridSorting(
      fieldId: fieldId ?? this.fieldId,
      order: order ?? this.order,
      location: location ?? this.location,
    );
  }
}
