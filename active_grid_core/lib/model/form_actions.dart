part of active_grid_model;

class FormAction<T> {
  final String uri;
  final String method;

  FormAction(this.uri, this.method);

  FormAction.fromJson(Map<String, dynamic> json)
      : uri = json['uri'],
        method = json['method'];

  Map<String, dynamic> toJson() => {
    'uri': uri,
    'method': method,
  };
}