part of apptive_grid_network;

/// Class for handling authentication related methods for ApptiveGrid
class ApptiveGridAuthenticator {
  /// Create a new [ApptiveGridAuthenticator] for [apptiveGridClient]
  ApptiveGridAuthenticator({
    this.options = const ApptiveGridOptions(),
    this.httpClient,
  }) {
    if (!kIsWeb) {
      _authCallbackSubscription = uni_links.uriLinkStream
          .where(
            (event) =>
                event != null &&
                event.scheme ==
                    options.authenticationOptions.redirectScheme?.toLowerCase(),
          )
          .listen((event) => _handleAuthRedirect(event!));
    }
  }

  /// [ApptiveGridOptions] used for getting the correct [ApptiveGridEnvironment.authRealm]
  /// and checking if authentication should automatically be handled
  ApptiveGridOptions options;

  Uri get _uri => Uri.parse(
        'https://iam.zweidenker.de/auth/realms/${options.environment.authRealm}',
      );

  /// Http Client that should be used for Auth Requests
  final http.Client? httpClient;

  Client? _authClient;

  TokenResponse? _token;
  Credential? _credential;

  /// Override the token for testing purposes
  @visibleForTesting
  void setToken(TokenResponse? token) => _token = token;

  /// Override the Credential for testing purposes
  @visibleForTesting
  void setCredential(Credential? credential) {
    options.authenticationOptions.authenticationStorage
        ?.saveToken(jsonEncode(credential?.toJson()));
    _credential = credential;
  }

  /// Override the [Client] for testing purposes
  @visibleForTesting
  void setAuthClient(Client client) => _authClient = client;

  /// Override the [Authenticator] for testing purposes
  @visibleForTesting
  Authenticator? testAuthenticator;

  late final StreamSubscription<Uri?>? _authCallbackSubscription;

  Future<Client> get _client async {
    Future<Client> createClient() async {
      final issuer = await Issuer.discover(_uri, httpClient: httpClient);
      return Client(issuer, 'app', httpClient: httpClient, clientSecret: '');
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

    final authenticator = testAuthenticator ??
        Authenticator(
          client,
          scopes: [],
          urlLauncher: _launchUrl,
          redirectUri: options.authenticationOptions.redirectScheme != null
              ? Uri(
                  scheme: options.authenticationOptions.redirectScheme,
                  host: Uri.parse(options.environment.url).host,
                )
              : null,
        );
    setCredential(await authenticator.authorize());

    setToken(await _credential?.getTokenResponse());

    try {
      await closeWebView();
    } on MissingPluginException {
      debugPrint('closeWebView is not available on this platform');
    } on UnimplementedError {
      debugPrint('closeWebView is not available on this platform');
    }

    return _credential;
  }

  Future<void> _handleAuthRedirect(Uri uri) async {
    final client = await _client;
    client.createCredential(refreshToken: _token?.refreshToken);
    final authenticator = testAuthenticator ??
        Authenticator(
          client, // coverage:ignore-line
          redirectUri: options.authenticationOptions.redirectScheme != null
              ? Uri(
                  scheme: options.authenticationOptions.redirectScheme,
                  host: Uri.parse(options.environment.url).host,
                )
              : null,
          urlLauncher: _launchUrl,
        );

    await authenticator.processResult(uri.queryParameters);
  }

  /// Dispose any resources in the Authenticator
  void dispose() {
    _authCallbackSubscription?.cancel();
  }

  /// Checks the authentication status and performs actions depending on the status
  ///
  /// If there is a [ApptiveGridAuthenticationOptions.apiKey] is set in [options] this will return without any Action
  ///
  /// If the User is not authenticated and [ApptiveGridAuthenticationOptions.autoAuthenticate] is true this will call [authenticate]
  ///
  /// If the token is expired it will refresh the token using the refresh token
  Future<void> checkAuthentication() async {
    if (_token == null) {
      await Future.value(
              options.authenticationOptions.authenticationStorage?.token)
          .then((credentialString) async {
        final jsonCredential = jsonDecode(credentialString ?? 'null');
        if (jsonCredential != null) {
          final credential = Credential.fromJson(
            jsonCredential,
            httpClient: httpClient,
          );
          setCredential(credential);
          final token = await credential.getTokenResponse();
          setToken(token);
        } else {
          if (options.authenticationOptions.apiKey != null) {
            // User has ApiKey provided
            return;
          } else if (options.authenticationOptions.autoAuthenticate) {
            await authenticate();
          }
        }
      });
    } else if ((_token?.expiresAt?.difference(DateTime.now()).inSeconds ?? 0) <
        70) {
      setToken(await _credential?.getTokenResponse(true));
    }
  }

  /// Performs a call to Logout the User
  ///
  /// even if the Call Fails the token and credential will be cleared
  Future<http.Response?> logout() async {
    final logoutUrl = _credential?.generateLogoutUrl();
    http.Response? response;
    if (logoutUrl != null) {
      response = await (httpClient ?? http.Client()).get(
        logoutUrl,
        headers: {
          HttpHeaders.authorizationHeader: header!,
        },
      );
    }
    setToken(null);
    setCredential(null);
    _authClient = null;

    return response;
  }

  /// If there is a authenticated User this will return the authentication header
  ///
  /// User Authentication is prioritized over ApiKey Authentication
  String? get header {
    if (_token != null) {
      final token = _token!;
      return '${token.tokenType} ${token.accessToken}';
    }
    if (options.authenticationOptions.apiKey != null) {
      final apiKey = options.authenticationOptions.apiKey!;
      return 'Basic ${base64Encode(utf8.encode('${apiKey.authKey}:${apiKey.password}'))}';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } on PlatformException {
        // Could not launch Url
      }
    }
  }

  /// Checks if the User is Authenticated
  bool get isAuthenticated =>
      options.authenticationOptions.apiKey != null || _token != null;
}

/// Interface to provide common functionality for authorization operations
abstract class IAuthenticator {
  /// Authorizes the User against the Auth Server
  Future<Credential?> authorize();
}
