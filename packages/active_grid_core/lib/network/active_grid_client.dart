part of active_grid_network;

/// Api Client to communicate with the ApptiveGrid Backend
class ApptiveGridClient {
  /// Creates an ApiClient
  ApptiveGridClient({
    this.options = const ApptiveGridOptions(),
  })  : _client = http.Client(),
        _authenticator = ApptiveGridAuthenticator(options: options);

  /// Creates an Api Client on the Basis of a [http.Client]
  ///
  /// this should only be used for testing in order to pass in a Mocked [http.Client]
  @visibleForTesting
  ApptiveGridClient.fromClient(
    http.Client httpClient, {
    this.options = const ApptiveGridOptions(),
    ApptiveGridAuthenticator? authenticator,
  })  : _client = httpClient,
        _authenticator =
            authenticator ?? ApptiveGridAuthenticator(options: options);

  /// Current Environment the Api is connecting to
  ApptiveGridOptions options;

  final ApptiveGridAuthenticator _authenticator;

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

  /// Loads a [FormData] represented by [formUri]
  ///
  /// Based on [formUri] this might require Authentication
  /// throws [Response] if the request fails
  Future<FormData> loadForm({
    required FormUri formUri,
  }) async {
    if (formUri.needsAuthorization) {
      await _authenticator.checkAuthentication();
    }
    final url = Uri.parse('${options.environment.url}${formUri.uriString}');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return FormData.fromJson(json.decode(response.body));
  }

  /// Performs a [FormAction] using [formData]
  ///
  /// throws [Response] if the request fails
  Future<http.Response> performAction(
    FormAction action,
    FormData formData,
  ) async {
    final uri = Uri.parse('${options.environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    request.headers.addAll({HttpHeaders.contentTypeHeader: ContentType.json});
    request.headers.addAll(headers);
    final response = await _client.send(request);
    if (response.statusCode >= 400) {
      throw response;
    }
    return http.Response.fromStream(response);
  }

  /// Loads a [Grid] represented by [gridUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Grid> loadGrid({required GridUri gridUri}) async {
    await _authenticator.checkAuthentication();
    final url = Uri.parse('${options.environment.url}${gridUri.uriString}');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Grid.fromJson(json.decode(response.body));
  }

  /// Get the [User] that is authenticated
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<User> getMe() async {
    await _authenticator.checkAuthentication();

    final url = Uri.parse('${options.environment.url}/api/users/me');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return User.fromJson(json.decode(response.body));
  }

  /// Get the [Space] represented by [spaceUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Space> getSpace({required SpaceUri spaceUri}) async {
    await _authenticator.checkAuthentication();

    final url = Uri.parse('${options.environment.url}${spaceUri.uriString}');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Space.fromJson(json.decode(response.body));
  }

  /// Get all [FormUris] that are contained in a [Grid] represented by [gridUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<List<FormUri>> getForms({required GridUri gridUri}) async {
    await _authenticator.checkAuthentication();

    final url =
        Uri.parse('${options.environment.url}${gridUri.uriString}/forms');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return (json.decode(response.body) as List)
        .map((e) => FormUri.fromUri(e))
        .toList();
  }

  /// Authenticate the User
  ///
  /// This will open a Webpage for the User Auth
  Future<Credential?> authenticate() {
    return _authenticator.authenticate();
  }
}
