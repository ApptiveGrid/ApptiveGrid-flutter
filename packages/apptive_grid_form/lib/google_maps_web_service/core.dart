// ignore_for_file: public_member_api_docs

part 'core.g.dart';

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  final double lat;
  final double lng;
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() => '$lat,$lng';
}

class Geometry {
  Geometry({
    required this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
  final Location location;

  /// JSON location_type
  final String? locationType;

  final Bounds? viewport;

  final Bounds? bounds;
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

class Bounds {
  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);

  Bounds({
    required this.northeast,
    required this.southwest,
  });
  final Location northeast;
  final Location southwest;

  @override
  String toString() =>
      '${northeast.lat},${northeast.lng}|${southwest.lat},${southwest.lng}';
  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}

abstract class GoogleResponseStatus {
  GoogleResponseStatus({required this.status, this.errorMessage});
  static const okay = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownErrorStatus = 'UNKNOWN_ERROR';
  static const notFound = 'NOT_FOUND';
  static const maxWaypointsExceeded = 'MAX_WAYPOINTS_EXCEEDED';
  static const maxRouteLengthExceeded = 'MAX_ROUTE_LENGTH_EXCEEDED';

  // TODO use enum for Response status
  final String status;

  /// JSON error_message
  final String? errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;
}

abstract class GoogleResponseList<T> extends GoogleResponseStatus {
  GoogleResponseList(String status, String? errorMessage, this.results)
      : super(status: status, errorMessage: errorMessage);
  final List<T> results;
}

abstract class GoogleResponse<T> extends GoogleResponseStatus {
  GoogleResponse(String status, String? errorMessage, this.result)
      : super(status: status, errorMessage: errorMessage);
  final T result;
}

class AddressComponent {
  AddressComponent({
    required this.types,
    required this.longName,
    required this.shortName,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
  final List<String> types;

  /// JSON long_name
  final String longName;

  /// JSON short_name
  final String shortName;
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}

class Component {
  Component(this.component, this.value);
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  @override
  String toString() => '$component:$value';
}

enum TravelMode {
  driving,

  walking,

  bicycling,

  transit,
}

class _TravelMode {
  _TravelMode(this.value);

  // ignore: unused_element
  factory _TravelMode.fromJson(Map<String, dynamic> json) =>
      _$_TravelModeFromJson(json);
  final TravelMode value;
  Map<String, dynamic> toJson() => _$_TravelModeToJson(this);
}

extension TravelModeExt on TravelMode {
  static TravelMode fromApiString(String mode) {
    return _$enumDecode(_$TravelModeEnumMap, mode);
  }

  String toApiString() {
    return _$TravelModeEnumMap[this] ?? '';
  }
}

enum RouteType {
  tolls,
  highways,
  ferries,
  indoor,
}

class _RouteType {
  _RouteType(this.value);

  // ignore: unused_element
  factory _RouteType.fromJson(Map<String, dynamic> json) =>
      _$_RouteTypeFromJson(json);
  final RouteType value;
  Map<String, dynamic> toJson() => _$_RouteTypeToJson(this);
}

extension RouteTypeExt on RouteType {
  static RouteType fromApiString(String mode) {
    return _$enumDecode(_$RouteTypeEnumMap, mode);
  }

  String toApiString() {
    return _$RouteTypeEnumMap[this] ?? '';
  }
}

enum Unit {
  metric,
  imperial,
}

class _Unit {
  _Unit(this.value);

  // ignore: unused_element
  factory _Unit.fromJson(Map<String, dynamic> json) => _$_UnitFromJson(json);
  final Unit value;
  Map<String, dynamic> toJson() => _$_UnitToJson(this);
}

extension UnitExt on Unit {
  static Unit fromApiString(String mode) {
    return _$enumDecode(_$UnitEnumMap, mode);
  }

  String toApiString() {
    return _$UnitEnumMap[this] ?? '';
  }
}

enum TrafficModel {
  bestGuess,
  pessimistic,
  optimistic,
}

class _TrafficModel {
  _TrafficModel(this.value);

  // ignore: unused_element
  factory _TrafficModel.fromJson(Map<String, dynamic> json) =>
      _$_TrafficModelFromJson(json);
  final TrafficModel value;
  Map<String, dynamic> toJson() => _$_TrafficModelToJson(this);
}

extension TrafficModelExt on TrafficModel {
  static TrafficModel fromApiString(String mode) {
    return _$enumDecode(_$TrafficModelEnumMap, mode);
  }

  String toApiString() {
    return _$TrafficModelEnumMap[this] ?? '';
  }
}

enum TransitMode {
  bus,
  subway,
  train,
  tram,
  rail,
}

class _TransitMode {
  _TransitMode(this.value);

  // ignore: unused_element
  factory _TransitMode.fromJson(Map<String, dynamic> json) =>
      _$_TransitModeFromJson(json);
  final TransitMode value;
  Map<String, dynamic> toJson() => _$_TransitModeToJson(this);
}

extension TransitModeExt on TransitMode {
  static TransitMode fromApiString(String mode) {
    return _$enumDecode(_$TransitModeEnumMap, mode);
  }

  String toApiString() {
    return _$TransitModeEnumMap[this] ?? '';
  }
}

enum TransitRoutingPreferences {
  lessWalking,

  fewerTransfers,
}

class _TransitRoutingPreferences {
  _TransitRoutingPreferences(this.value);

  // ignore: unused_element
  factory _TransitRoutingPreferences.fromJson(Map<String, dynamic> json) =>
      _$_TransitRoutingPreferencesFromJson(json);
  final TransitRoutingPreferences value;
  Map<String, dynamic> toJson() => _$_TransitRoutingPreferencesToJson(this);
}

extension TransitRoutingPreferencesExt on TransitRoutingPreferences {
  static TransitRoutingPreferences fromApiString(String mode) {
    return _$enumDecode(_$TransitRoutingPreferencesEnumMap, mode);
  }

  String toApiString() {
    return _$TransitRoutingPreferencesEnumMap[this] ?? '';
  }
}
