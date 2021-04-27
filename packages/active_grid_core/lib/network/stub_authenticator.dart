import 'package:openid_client/openid_client.dart';

/// Stub Authenticator used to provide a general interface for importing
/// package:openid_client/openid_client_io.dart for dart:io capable platforms
/// package:openid_client/openid_client_browser.dart for dart:html capable platforms
class Authenticator {
  //ignore: public_member_api_docs
  Authenticator(
    Client? client, {
    Function(String)? urlLancher,
    Iterable<String> scopes = const [],
    Uri? redirectUri,
  });

  //ignore: public_member_api_docs
  Future<Credential> authorize() {
    return Future.error('Should not use StubAuthenticator');
  }
}
