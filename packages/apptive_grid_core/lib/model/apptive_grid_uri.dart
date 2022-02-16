part of apptive_grid_model;

/// Base class used to represent Objects with a Uri
abstract class ApptiveGridUri {
  ApptiveGridUri._(Uri uri, this.type) : _uri = uri;
  /// Creates a new ApptiveGridUri from an [uri]
  /// Uses [Uri.parse]
  ApptiveGridUri.fromUri(String uri, this.type) : _uri = Uri.parse(uri);

  final Uri _uri;
  /// The type that this object represents
  final UriType type;

  /// The uri that this is pointing to
  String get uriString => _uri.toString();

  /// The uri that this is pointing to
  Uri get uri => _uri;

  @override
  String toString() => 'ApptiveGridUri(uri: $uri, type: ${type.name})';

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridUri && type == other.type && _uri == other.uri;
  }

  @override
  int get hashCode => uri.hashCode;
}

/// The type that a [ApptiveGridUri] is pointing to
enum UriType {
  /// An unknown type. This should normally not occur
  unknown,
  /// Performing a GET request on this should return [FormData]
  form,
  /// Performing a GET request on this should return [Map] of an Entity
  entity,
  /// Performing a GET request on this should return [Grid]
  grid,
  /// Performing a GET request on this should return [Space]
  space,
}
