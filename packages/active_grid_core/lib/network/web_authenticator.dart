import 'dart:convert';
import 'dart:html';
import 'package:active_grid_core/network/authenticator.dart';
import 'package:http/http.dart' as http;

import 'package:openid_client/openid_client.dart';

/// Custom Authenticator for handling Authentication for Flutter Web
///
/// It uses the Constructor from the io implementation of openid client
class Authenticator implements IAuthenticator {

  /// Creates a authenticator object
  ///
  /// [redirectUri] should be the uri the Auth Provider redirected to.
  /// It is currently not possible to set a custom redirect Url for the authentication process itself
  Authenticator(
      Client client, {
        Function(String)? urlLancher,
        Iterable<String> scopes = const [],
        Uri? redirectUri,
      }) : _authenticator = _CustomAuthenticator(
    client,
    scopes: scopes,
    redirectedUri: redirectUri.toString(),
  );

  late final _CustomAuthenticator _authenticator;

  @override
  Future<Credential?> authorize() async {
    final credential = await _authenticator.credential;
    if(credential == null) {
      _authenticator.authorize();
      return _authenticator.flow.callback({'code': 'some code'});
    } else {
      return credential;
    }
  }
}

/// Custom Implementation based on Authenticator from openid_client_browser to match specific criteria needed for ActiveGrid
class _CustomAuthenticator {
  _CustomAuthenticator._(this.flow, {String? redirectedUri, required Client client}) : credential = _credentialFromUri(flow, redirectedUri: redirectedUri, client: client);

  _CustomAuthenticator(client, {Iterable<String> scopes = const [], String? redirectedUri})
      : this._(Flow.authorizationCode(client,
      state: window.localStorage['openid_client:state'])
    ..scopes.addAll(scopes)
    ..redirectUri = Uri(
      host: Uri.base.host,
      scheme: Uri.base.scheme,
      port: Uri.base.port,
      fragment: null,
    ), redirectedUri: redirectedUri, client: client);

  final Future<Credential?> credential;

  final Flow flow;

  void authorize() {
    _forgetCredentials();
    window.localStorage['openid_client:state'] = flow.state;
    window.location.href = flow.authenticationUri.toString();
  }

  void logout() async {
    _forgetCredentials();
    var c = await credential;
    if (c == null) return;
    var uri = c.generateLogoutUrl(
        redirectUri: Uri.parse(window.location.href));
    if (uri != null) {
      window.location.href = uri.toString();
    }
  }

  void _forgetCredentials() {
    window.localStorage.remove('openid_client:state');
    window.localStorage.remove('openid_client:auth');
  }

  static Future<Credential?> _credentialFromUri(Flow flow, {String? redirectedUri, required Client client}) async {
    Map? q;
    if(window.localStorage.containsKey('openid_client:credential')) {
      /// Saved Credentials
      final json = jsonDecode(window.localStorage['openid_client:credential']!);
      return Credential.fromJson(json);
    }
    if (window.localStorage.containsKey('openid_client:auth')) {
      /// Saved Code Token
      q = json.decode(window.localStorage['openid_client:auth']!);
    } else {
      var uri = Uri.parse(redirectedUri ?? window.location.href);
      q = uri.queryParameters;
      if (q.containsKey('access_token') ||
          q.containsKey('code') ||
          q.containsKey('id_token')) {
        window.localStorage['openid_client:auth'] = json.encode(q);
        window.location.href =
            Uri.parse(window.location.href).toString();
      }
    }
    if (q!.containsKey('access_token') ||
        q.containsKey('code') ||
        q.containsKey('id_token')) {
      final code= q['code'];
      final json = await http.post(client.issuer!.metadata.tokenEndpoint!,
          body: {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': Uri(
              host: Uri.base.host,
              scheme: Uri.base.scheme,
              port: Uri.base.port,
              fragment: null,
            ).toString(),
            'client_id': client.clientId,
          },);
      final token = TokenResponse.fromJson(jsonDecode(json.body));
      final credential =  Credential.fromJson({
        'issuer': client.issuer!.metadata.toJson(),
        'client_id': client.clientId,
        'client_secret': client.clientSecret,
        'token': token.toJson(),
        'nonce': null
      });
      window.localStorage['openid_client:credential'] = jsonEncode(credential.toJson());
      return credential;
    }
    return null;
  }
}