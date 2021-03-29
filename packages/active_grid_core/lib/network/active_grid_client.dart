part of active_grid_network;

/// Api Client to communicate with the ActiveGrid Backend
class ActiveGridClient {
  /// Creates an ApiClient
  ActiveGridClient({
    this.environment = ActiveGridEnvironment.production,
    this.authentication,
  }) : _client = http.Client();

  /// Creates an Api Client on the Basis of a [http.Client]
  ///
  /// this should only be used for testing in order to pass in a Mocked [http.Client]
  @visibleForTesting
  ActiveGridClient.fromClient(http.Client httpClient, {this.authentication})
      : _client = httpClient,
        environment = ActiveGridEnvironment.production;

  /// Current Environment the Api is connecting to
  ActiveGridEnvironment environment;

  /// Authentication Object
  ActiveGridAuthentication? authentication;

  final http.Client _client;

  /// Close the connection on the httpClient
  void dispose() {
    _client.close();
  }

  /// Headers that are used for multiple Calls
  @visibleForTesting
  Map<String, String> get headers => <String, String>{
        if (authentication != null)
          HttpHeaders.authorizationHeader: authentication!.header,
      };

  /// Loads a [FormData] specified with [formId]
  Future<FormData> loadForm({required String formId}) async {
    final url = Uri.parse('${environment.url}/api/a/$formId');
    final response = await _client.get(url);
    return FormData.fromJson(json.decode(response.body));
  }

  /// Performs a [FormAction] using [formData]
  Future<http.Response> performAction(
      FormAction action, FormData formData) async {
    final uri = Uri.parse('${environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    request.headers
        .addAll({HttpHeaders.contentTypeHeader: ContentType.json.value});
    final response = await _client.send(request);
    return http.Response.fromStream(response);
  }

  /// Loads a [Grid]
  ///
  /// [user] User that owns the [Grid]
  /// [space] Space the [Grid] is in
  /// [grid] id of the [Grid]
  Future<Grid> loadGrid(
      {required String user,
      required String space,
      required String grid}) async {
    final url = Uri.parse('${environment.url}/api/users/$user/spaces/$space/grids/$grid');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Grid.fromJson(json.decode(response.body));
  }
}
