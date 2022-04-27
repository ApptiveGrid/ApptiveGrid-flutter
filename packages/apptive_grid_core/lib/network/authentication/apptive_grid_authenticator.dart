part of apptive_grid_network;

/// Class for handling authentication related methods for ApptiveGrid
class ApptiveGridAuthenticator {
  /// Create a new [ApptiveGridAuthenticator] for [apptiveGridClient]
  ApptiveGridAuthenticator({
    this.options = const ApptiveGridOptions(),
    this.httpClient,
    AuthenticationStorage? authenticationStorage,
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

    if (options.authenticationOptions.persistCredentials) {
      _authenticationStorage = authenticationStorage ??
          const FlutterSecureStorageCredentialStorage();
      checkAuthentication(requestNewToken: false)
          .then((_) => _setupCompleter.complete());
    } else {
      _setupCompleter.complete();
    }
  }

  /// Creates an [ApptiveGridAuthenticator] with a specific [AuthenticationStorage]
  @visibleForTesting
  @Deprecated('Use ApptiveGridAuthenticator directly')
  ApptiveGridAuthenticator.withAuthenticationStorage({
    this.options = const ApptiveGridOptions(),
    this.httpClient,
    required AuthenticationStorage? storage,
  })  : _authenticationStorage = storage,
        _authCallbackSubscription = null {
    _setupCompleter.complete();
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

  AuthenticationStorage? _authenticationStorage;

  final _setupCompleter = Completer();

  /// Override the token for testing purposes
  @visibleForTesting
  Future<void> setToken(TokenResponse? token) async {
    if (token != null) {
      _token = token;
      final client = await _client;
      final credential = Credential.fromJson({
        'issuer': client.issuer.metadata.toJson(),
        'client_id': client.clientId,
        'client_secret': client.clientSecret,
        'token': token.toJson(),
      });
      setCredential(credential);
    } else {
      _token = null;
      await setCredential(null);
    }
  }

  /// Authenticates by setting a token
  /// [tokenResponse] needs to be a JWT
  Future<void> setUserToken(Map<String, dynamic> tokenResponse) async {
    final token = TokenResponse.fromJson(tokenResponse);
    setToken(token);
  }

  /// Override the Credential for testing purposes
  @visibleForTesting
  Future<void> setCredential(Credential? credential) async {
    await _authenticationStorage?.saveCredential(
      credential != null ? jsonEncode(credential.toJson()) : null,
    );
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
    await setCredential(await authenticator.authorize());

    await setToken(await _credential?.getTokenResponse());

    try {
      await closeInAppWebView();
    } on MissingPluginException {
      debugPrint('closeWebView is not available on this platform');
    } on UnimplementedError {
      debugPrint('closeWebView is not available on this platform');
    }

    return _credential;
  }

  Future<void> _handleAuthRedirect(Uri uri) async {
    final client = await _client;
    client.createCredential(
      refreshToken: _token?.refreshToken,
    );
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
  /// If [requestNewToken] is true this might open the login page for the user
  /// This is used for the creation of this authenticator to not present the login page when checking for saved tokens
  ///
  /// If there is a [ApptiveGridAuthenticationOptions.apiKey] is set in [options] this will return without any Action
  ///
  /// If the User is not authenticated and [ApptiveGridAuthenticationOptions.autoAuthenticate] is true this will call [authenticate]
  ///
  /// If the token is expired it will refresh the token using the refresh token
  Future<void> checkAuthentication({bool requestNewToken = true}) async {
    if (_token == null) {
      await Future.value(
        _authenticationStorage?.credential,
      ).then((credentialString) async {
        final jsonCredential = jsonDecode(credentialString ?? 'null');
        if (jsonCredential != null) {
          final credential = Credential.fromJson(
            jsonCredential,
            httpClient: httpClient,
          );
          setCredential(credential);
          try {
            final token = await credential.getTokenResponse(true);
            setToken(token);
            return;
          } on OpenIdException catch (_) {
            setCredential(null);
            debugPrint('Could not refresh saved token');
          } catch (error) {
            debugPrint('Error refreshing token: $error');
          }
        }
        if (options.authenticationOptions.apiKey != null) {
          // User has ApiKey provided
          return;
        } else if (requestNewToken &&
            options.authenticationOptions.autoAuthenticate) {
          await authenticate();
        }
      });
    } else if ((_token?.expiresAt?.difference(DateTime.now()).inSeconds ?? 0) <
        70) {
      final newToken = await _credential?.getTokenResponse(true);
      await setToken(newToken);
    }
  }

  /// Performs a call to Logout the User
  ///
  /// even if the Call Fails the token and credential will be cleared
  Future<http.Response?> logout() async {
    http.Response? response;
    try {
      final logoutUrl = _credential?.generateLogoutUrl();
      if (logoutUrl != null) {
        response = await (httpClient ?? http.Client()).get(
          logoutUrl,
          headers: {
            HttpHeaders.authorizationHeader: header!,
          },
        );
      }
    } catch (_) {
    } finally {
      await setToken(null);
      await setCredential(null);
      _authClient = null;
    }

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
    return null;
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      try {
        await launchUrl(Uri.parse(url));
      } on PlatformException {
        // Could not launch Url
      }
    }
  }

  /// Checks if the User is Authenticated
  Future<bool> get isAuthenticated => _setupCompleter.future.then(
        (_) => options.authenticationOptions.apiKey != null || _token != null,
      );

  /// Checks if the User is Authenticated via a Token
  /// Returns true if the user is logged in as a user.
  /// Will return false if there is no authentication set or if the authentication is done using a [ApptiveGridApiKey]
  Future<bool> get isAuthenticatedWithToken =>
      _setupCompleter.future.then((_) => _token != null);
}

/// Interface to provide common functionality for authorization operations
abstract class IAuthenticator {
  /// Authorizes the User against the Auth Server
  Future<Credential?> authorize();
}
