part of apptive_grid_model;

/// A Link that is found in the _links section of a response
class ApptiveLink {
  /// Creates a new ApptiveLink. The content/action is reachable via a http call with [method] against [uri]
  const ApptiveLink({required this.uri, required this.method});

  /// Creates a [ApptiveLink] from [json]
  /// Expect [uri] in a field called `href` and [method] in a field called `method`
  factory ApptiveLink.fromJson(dynamic json) {
    return ApptiveLink(
      uri: Uri.parse(json['href']),
      method: json['method'],
    );
  }

  /// Parses this into a json object
  Map<String, dynamic> toJson() {
    return {
      'href': uri.toString(),
      'method': method,
    };
  }

  /// The [uri] to call for the link
  final Uri uri;

  /// The http method to use
  final String method;

  @override
  String toString() {
    return 'ApptiveLink(uri: $uri, method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveLink && other.uri == uri && other.method == method;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// A Map of Links
typedef LinkMap = Map<ApptiveLinkType, ApptiveLink>;

/// Extensions for [LinkMap]
extension LinkMapX on LinkMap {
  /// Parses this LinkMap to a json object
  Map<String, dynamic> toJson() {
    return map(
      (key, value) => MapEntry(
        key.name,
        value.toJson(),
      ),
    );
  }
}

/// Parses [json] into a [LinkMap]
/// The keys in [json] are expected to be the `name` of a [ApptiveLinkType]
/// If the name does not match a know [ApptiveLinkType] the entry will be ignored
LinkMap linkMapFromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return {};
  }
  final linkTypeNames = ApptiveLinkType.values.map((type) => type.name);
  final knownTypes = json.keys.where((key) => linkTypeNames.contains(key));

  return Map.fromEntries(
    knownTypes.map(
      (type) => MapEntry(
        ApptiveLinkType.values.firstWhere((linkType) => linkType.name == type),
        ApptiveLink.fromJson(json[type]),
      ),
    ),
  );
}
