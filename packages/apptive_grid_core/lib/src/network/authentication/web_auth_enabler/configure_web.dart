// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/web_authenticator.dart';
import 'package:openid_client/openid_client.dart' as openid;

/// Enable Authentication for Flutter Web
/// This checks if the Flutter App was redirected to by the Authentication Server and request an AccessToken
Future<void> enableWebAuth(ApptiveGridOptions options) async {
  final url = window.location.href;
  if (url.contains('state=')) {
    final issuerUri = Uri.parse(
      '${options.environment.url}/auth/${options.authenticationOptions.authGroup}/authorize',
    );
    final issuer = await openid.Issuer.discover(issuerUri);
    final client = openid.Client(issuer, 'web');
    final webAuthenticator = Authenticator(client, redirectUri: Uri.parse(url));
    await webAuthenticator.authorize();
  }
}
