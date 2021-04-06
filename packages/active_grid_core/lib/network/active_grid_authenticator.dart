import 'package:active_grid_core/active_grid_core.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveGridAuthenticator {
  ActiveGridAuthenticator({required this.options})
      : _uri =
            Uri.parse('https://iam.zweidenker.de/auth/realms/${options.environment.authRealm}');

  final ActiveGridOptions options;

  final Uri _uri;

  Client? _authClient;

  TokenResponse? _token;

  Future<Client> get _client async {
    Future<Client> createClient() async {
      final issuer = await Issuer.discover(_uri);
      return Client(issuer, 'web');
    }
    return _authClient ??= await createClient();
  }

  Future<Credential> authenticate() async {
    final client = await _client;

    urlLauncher(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    final authenticator = Authenticator(
      client,
      scopes: [],
      urlLancher: urlLauncher,
    );

    final credential = await authenticator.authorize();

    _token = await credential.getTokenResponse();

    closeWebView();

    return credential;
  }

  Future<bool> checkAuthentication() async {
    if(_token == null && options.authenticationOptions?.autoAuthenticate == true) {
      await authenticate();
    }

    if(_token != null && _token?.expiresIn?.isNegative == true) {
      // Token is expired refresh it
      final client = await _client;
      client.createCredential(refreshToken: _token?.refreshToken);
      final authenticator = Authenticator(client);
      final credential = await authenticator.authorize();

      _token = await credential.getTokenResponse();
    }
    return true;
  }

  String? get header {
    if(_token != null) {
      return '${_token?.tokenType} ${_token?.accessToken}';
    } else {
      return null;
    }
  }
}
