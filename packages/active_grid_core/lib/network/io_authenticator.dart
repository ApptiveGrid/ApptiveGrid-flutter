import 'package:openid_client/openid_client_io.dart' as openid;

/// IO Implementation of Authenticator
class Authenticator {
  /// Creates an Authenticator
  Authenticator(
    openid.Client? client, {
    required Function(String) urlLauncher,
    Iterable<String> scopes = const [],
    Uri? redirectUri,
  }) : _authenticator = openid.Authenticator(
          client,
          scopes: scopes,
          redirectUri: redirectUri,
          urlLancher: urlLauncher,
        );

  final openid.Authenticator _authenticator;

  /// Authorizes the client
  Future<openid.Credential?> authorize() {
    return _authenticator.authorize();
  }
}
