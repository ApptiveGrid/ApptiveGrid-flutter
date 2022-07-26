// coverage:ignore-file

import 'package:openid_client/openid_client_io.dart' as openid;

/// IO Implementation of Authenticator
class Authenticator {
  /// Creates an Authenticator
  Authenticator(
    openid.Client client, {
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

  /// Process a Response retrieved from an outside Authentication.
  /// For Example if the App was reopened by a Auth Redirect Link
  Future<void> processResult(Map<String, String> result) async {
    await openid.Authenticator.processResult(result);
  }
}
