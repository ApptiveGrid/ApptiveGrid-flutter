part of active_grid_model;

/// Model for a Action inside a Form
class FormAction {
  /// Creates a Form Action
  FormAction(this.uri, this.method);

  /// Deserialize [json] into a [FormAction]
  FormAction.fromJson(Map<String, dynamic> json)
      : uri = json['uri'],
        method = json['method'];

  /// Path the Action points to
  final String uri;

  /// [http.BaseRequest.method] method this Action uses
  final String method;

  /// Serializes [FormAction] to json
  Map<String, dynamic> toJson() => {
        'uri': uri,
        'method': method,
      };

  @override
  String toString() {
    return 'FormAction(uri: $uri, method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return other is FormAction && uri == other.uri && method == other.method;
  }
}
