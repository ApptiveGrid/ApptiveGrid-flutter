part of active_grid_network;

class ActiveGridClient {
  ActiveGridEnvironment _environment;
  final http.Client _client;

  ActiveGridClient({ActiveGridEnvironment environment})
      : _environment = environment,
        _client = http.Client();

  Future<FormData> loadForm({@required String formId}) async {
    final url = '${_environment.url}/api/a/$formId';
    final response = await _client.get(url);
    return FormData.fromJson(json.decode(response.body));
  }

  void dispose() {
    _client.close();
  }

  Future<http.Response> performAction(FormAction action, FormData formData) async {
    final uri = Uri.parse('${_environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    final response = await _client.send(request);
    return http.Response.fromStream(response);
  }
}
