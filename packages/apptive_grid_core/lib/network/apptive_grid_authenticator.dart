part of apptive_grid_network;

/// Class for handling authentication related methods for ApptiveGrid
class ApptiveGridAuthenticator {
  /// Create a new [ApptiveGridAuthenticator]
  /// [options] is used to get the [ApptiveGridEnvironment.authRealm] for the [_uri]
  ApptiveGridAuthenticator(
      {this.options = const ApptiveGridOptions(), this.httpClient})
      : _uri = Uri.parse(
            'https://iam.zweidenker.de/auth/realms/${options.environment.authRealm}');

  /// [ApptiveGridOptions] used for getting the correct [ApptiveGridEnvironment.authRealm]
  /// and checking if authentication should automatically be handled
  final ApptiveGridOptions options;

  final Uri _uri;

  /// Http Client that should be used for Auth Requests
  final http.Client? httpClient;

  Client? _authClient;

  TokenResponse? _token;

  /// Override the token for testing purposes
  @visibleForTesting
  void setToken(TokenResponse token) => _token = token;

  /// Override the [Client] for testing purposes
  @visibleForTesting
  void setAuthClient(Client client) => _authClient = client;

  /// Override the [Authenticator] for testing purposes
  @visibleForTesting
  Authenticator? testAuthenticator;

  Future<Client> get _client async {
    Future<Client> createClient() async {
      final issuer = await Issuer.discover(_uri, httpClient: httpClient);
      return Client(issuer, 'web', httpClient: httpClient);
    }

    return _authClient ??= await createClient();
  }

  /// Used to test implementation of get _client
  @visibleForTesting
  Future<Client> get authClient => _client;

  /// Open the Authentication Webpage
  ///
  /// Returns [Credential] from the authentication call
  Future<Credential?> authenticate() async {
    final client = await _client;
    Future<void> urlLauncher(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      }
    }

    final authenticator = testAuthenticator ??
        Authenticator(
          client,
          scopes: [],
          urlLauncher: urlLauncher,
        );

    final credential = await authenticator.authorize();

    _token = await credential?.getTokenResponse();

    try {
      await closeWebView();
    } on MissingPluginException {
      debugPrint('closeWebView is not available on this platform');
    } on UnimplementedError {
      debugPrint('closeWebView is not available on this platform');
    }

    return credential;
  }

  /// Checks the authentication status and performs actions depending on the status
  ///
  /// If the User is not authenticated and [ApptiveGridAuthenticationOptions.autoAuthenticate] is true this will call [authenticate]
  ///
  /// If the token is expired it will refresh the token using the refresh token
  Future<void> checkAuthentication() async {
    if (_token == null &&
        options.authenticationOptions?.autoAuthenticate == true) {
      await authenticate();
    } else if (_token != null &&
        (_token?.expiresAt?.difference(DateTime.now()).inSeconds ?? 0) < 70) {
      // Token is expired refresh it
      final client = await _client;
      final credential = client.createCredential(
        accessToken: _token?.accessToken,
        refreshToken: _token?.refreshToken,
        expiresAt: _token?.expiresAt,
      );

      _token = await credential.getTokenResponse(true);
    }
  }

  /// If there is a authenticated User this will return the authentication header
  String? get header {
    final token = _token;
    if (token != null) {
      return '${token.tokenType} ${token.accessToken}';
    }
  }
}

/// Interface to provide common functionality for authorization operations
abstract class IAuthenticator {
  /// Authorizes the User against the Auth Server
  Future<Credential?> authorize();
}
