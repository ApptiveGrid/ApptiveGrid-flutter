part of apptive_grid_model;

/// Model for a Action inside a Form
@Deprecated('Use ApptiveLinks instead')
class FormAction {
  /// Creates a Form Action
  FormAction(this.uri, this.method);

  /// Deserialize [json] into a [FormAction]
  FormAction.fromJson(Map<String, dynamic> json)
      : uri = json['uri'] ?? json['href'],
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
    required this.link,
    required this.data,
  });

  /// Creates a ActionItem base on a [json] map
  ActionItem.fromJson(Map<String, dynamic> json)
      // ignore: deprecated_member_use_from_same_package
      : link = ApptiveLink.fromJson(json['link'] ?? json['action']),
        data = FormData.fromJson(json['data']);

  /// Returns [link] as a [FormAction] for compatibility
  @Deprecated('Use link instead')
  FormAction get action => link.asFormAction;

  /// Action to be performed
  // ignore: deprecated_member_use_from_same_package
  final ApptiveLink link;

  /// Data to be send in the Action
  final FormData data;

  /// Serializes the ActionItem to a json map
  Map<String, dynamic> toJson() => {
        'link': link.toJson(),
        'data': data.toJson(),
      };

  @override
  String toString() {
    return 'ActionItem(link: $link, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return other is ActionItem && link == other.link && data == other.data;
  }

  @override
  int get hashCode => toString().hashCode;
}
