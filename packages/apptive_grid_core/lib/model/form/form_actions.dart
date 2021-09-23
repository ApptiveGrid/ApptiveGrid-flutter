part of apptive_grid_model;

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

  @override
  int get hashCode => toString().hashCode;
}

/// Wrapper class to use in [ApptiveGridCache]
class ActionItem {
  /// Creates a new Action Item
  ActionItem({
    required this.action,
    required this.data,
  });

  /// Creates a ActionItem base on a [json] map
  ActionItem.fromJson(Map<String, dynamic> json)
      : action = FormAction.fromJson(json['action']),
        data = FormData.fromJson(json['data']);

  /// Action to be performed
  final FormAction action;

  /// Data to be send in the Action
  final FormData data;

  /// Serializes the ActionItem to a json map
  Map<String, dynamic> toJson() => {
        'action': action.toJson(),
        'data': data.toJson(),
      };

  @override
  String toString() {
    return 'ActionItem(action: $action, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return other is ActionItem && action == other.action && data == other.data;
  }

  @override
  int get hashCode => toString().hashCode;
}
