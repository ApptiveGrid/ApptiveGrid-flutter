import 'dart:html';

import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/network/web_authenticator.dart';
import 'package:openid_client/openid_client.dart' as openid;

/// Enable Authentication for Flutter Web
/// This checks if the Flutter App was redirected to by the Authentication Server and request an AccessToken
Future<void> enableWebAuth() async {
  final url = window.location.href;
  if (url.contains('state=')) {
    final issuerUri = Uri.parse(
        'https://iam.zweidenker.de/auth/realms/${ActiveGridEnvironment.beta.authRealm}');
    final issuer = await openid.Issuer.discover(issuerUri);
    final client = openid.Client(issuer, 'web');
    final webAuthenticator = Authenticator(client, redirectUri: Uri.parse(url));
    await webAuthenticator.authorize();
  }
}
