part of active_grid_network;

/// Api Client to communicate with the ActiveGrid Backend
class ActiveGridClient {
  /// Creates a ApiClient
  ActiveGridClient({this.environment = ActiveGridEnvironment.production})
      :         _client = http.Client();

  /// Current Environment the Api is connecting to
  ActiveGridEnvironment environment;

  final http.Client _client;

  /// Close the connection on the httpClient
  void dispose() {
    _client.close();
  }

  /// Loads a form specified with [formId]
  Future<FormData> loadForm({@required String formId}) async {
    final url = '${environment.url}/api/a/$formId';
    final response = await _client.get(url);
    return FormData.fromJson(json.decode(response.body));
  }

  /// Performs a [FormAction] using [formData]
  Future<http.Response> performAction(
      FormAction action, FormData formData) async {
    final uri = Uri.parse('${environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    final response = await _client.send(request);
    return http.Response.fromStream(response);
  }
}
