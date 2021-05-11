part of active_grid_network;

/// Api Client to communicate with the ActiveGrid Backend
class ActiveGridClient {
  /// Creates an ApiClient
  ActiveGridClient({
    this.options = const ActiveGridOptions(),
  })  : _client = http.Client(),
        _authenticator = ActiveGridAuthenticator(options: options);

  /// Creates an Api Client on the Basis of a [http.Client]
  ///
  /// this should only be used for testing in order to pass in a Mocked [http.Client]
  @visibleForTesting
  ActiveGridClient.fromClient(
    http.Client httpClient, {
    this.options = const ActiveGridOptions(),
    ActiveGridAuthenticator? authenticator,
  })  : _client = httpClient,
        _authenticator =
            authenticator ?? ActiveGridAuthenticator(options: options);

  /// Current Environment the Api is connecting to
  ActiveGridOptions options;

  final ActiveGridAuthenticator _authenticator;

  final http.Client _client;

  /// Close the connection on the httpClient
  void dispose() {
    _client.close();
  }

  /// Headers that are used for multiple Calls
  @visibleForTesting
  Map<String, String> get headers => (<String, String?>{
        HttpHeaders.authorizationHeader: _authenticator.header,
      }..removeWhere((key, value) => value == null))
          .map((key, value) => MapEntry(key, value!));

  /// Loads a [FormData] specified with [formId]
  Future<FormData> loadForm({
    required String formId,
  }) async {
    final url = Uri.parse('${options.environment.url}/api/a/$formId');
    final response = await _client.get(url);
    return FormData.fromJson(json.decode(response.body));
  }

  /// Performs a [FormAction] using [formData]
  Future<http.Response> performAction(
    FormAction action,
    FormData formData,
  ) async {
    final uri = Uri.parse('${options.environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    request.headers.addAll({HttpHeaders.contentTypeHeader: ContentType.json});
    final response = await _client.send(request);
    return http.Response.fromStream(response);
  }

  /// Loads a [Grid]
  ///
  /// [user] User that owns the [Grid]
  /// [space] Space the [Grid] is in
  /// [grid] id of the [Grid]
  Future<Grid> loadGrid({
    required GridUri gridUri
  }) async {
    await _authenticator.checkAuthentication();
    final url = Uri.parse(
        '${options.environment.url}${gridUri.uriString}');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Grid.fromJson(json.decode(response.body));
  }

  Future<User> getMe() async {
    await _authenticator.checkAuthentication();

    final url = Uri.parse('${options.environment.url}/api/users/me');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return User.fromJson(json.decode(response.body));
  }

  Future<Space> getSpace({
    required SpaceUri spaceUri
  }) async {
    await _authenticator.checkAuthentication();

    final url =
        Uri.parse('${options.environment.url}${spaceUri.uriString}');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Space.fromJson(json.decode(response.body));
  }

  /// Authenticate the User
  ///
  /// This will open a Webpage for the User Auth
  Future<Credential?> authenticate() {
    return _authenticator.authenticate();
  }
}
