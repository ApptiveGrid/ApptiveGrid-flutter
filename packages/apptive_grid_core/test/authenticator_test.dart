@TestOn('!browser')
import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client_fork/openid_client.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'mocks.dart';

void main() {
  late StreamController<String?> streamController;
  late ApptiveGridAuthenticator authenticator;

  setUpAll(() {
    registerFallbackValue(Uri());

    final mockUniLink = MockUniLinks();
    UniLinksPlatform.instance = mockUniLink;
    streamController = StreamController<String?>.broadcast();
    when(() => mockUniLink.linkStream)
        .thenAnswer((_) => streamController.stream);
  });

  tearDownAll(() {
    authenticator.dispose();
    streamController.close();
  });

  group('Header', () {
    test('Has Token returns Token', () {
      authenticator = ApptiveGridAuthenticator(options: ApptiveGridOptions());
      final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      authenticator.setToken(token);

      expect(authenticator.header, 'Bearer 12345');
    });

    test('Has no Token returns null', () {
      authenticator = ApptiveGridAuthenticator(options: ApptiveGridOptions());
      expect(authenticator.header, null);
    });
  });

  group('checkAuthentication', () {
    test('No Token, Auto Authenticate, authenticates', () async {
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});

      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator(
        options: ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
          ),
        ),
      );

      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);

      await authenticator.checkAuthentication();

      verify(() => mockAuthBackend.authorize()).called(1);
    });

    test('Expired Token Refreshes', () async {
      final authenticator =
          ApptiveGridAuthenticator(options: ApptiveGridOptions());

      // Current token should be Expired
      final now = DateTime.now();
      final token = MockToken();
      when(() => token.expiresAt)
          .thenReturn(now.subtract(Duration(seconds: 20)));
      authenticator.setToken(token);

      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      final credential = MockCredential();
      authenticator.setCredential(credential);
      final newToken = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      when(
        () => client.createCredential(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiresAt: any(named: 'expiresAt')),
      ).thenReturn(credential);
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse(any()))
          .thenAnswer((invocation) async => newToken);

      await authenticator.checkAuthentication();

      // Check if new Token is used in Header
      expect(authenticator.header, 'Bearer 12345');
      verify(() => credential.getTokenResponse(any())).called(1);
    });
  });

  group('Authenticate', () {
    setUpAll(() {
      registerFallbackValue<Map<String, String>>(<String, String>{});
    });

    test('Opens Url', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          )).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      unawaited(authenticator.authenticate());
      final launchedUrl = await completer.future;
      expect(
          launchedUrl
              .startsWith('https://iam.zweidenker.de/auth/realms/apptiveGrid/'),
          true);
    });

    test('Missing Plugin Exception gets Caught', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          )).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView())
          .thenThrow(MissingPluginException());
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator();
      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      await authenticator.authenticate();
    });

    test('Unimplemented Error gets Caught', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          )).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView()).thenThrow(UnimplementedError());
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator();
      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      await authenticator.authenticate();
    });
  });

  group('Create Client', () {
    test('Creates new Client', () async {
      final httpClient = MockHttpClient();
      authenticator = ApptiveGridAuthenticator(httpClient: httpClient);
      final discoveryUri = Uri.parse(
          'https://iam.zweidenker.de/auth/realms/apptivegrid/.well-known/openid-configuration');

      when(() => httpClient.get(discoveryUri, headers: any(named: 'headers')))
          .thenAnswer((invocation) async => Response(
                jsonEncode(_zweidenkerIssuer.metadata.toJson()),
                200,
                request: Request('GET', discoveryUri),
              ));

      final client = await authenticator.authClient;
      expect(client.issuer!.metadata.toJson(),
          _zweidenkerIssuer.metadata.toJson());
    });
  });

  group('Logout', () {
    test('Logout calls http Client', () async {
      final httpClient = MockHttpClient();
      final authenticator = ApptiveGridAuthenticator(httpClient: httpClient);
      final logoutUri = Uri.parse('https://log.me/out');

      final credential = MockCredential();
      authenticator.setCredential(credential);
      final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      authenticator.setToken(token);

      when(() => credential.generateLogoutUrl())
          .thenAnswer((invocation) => logoutUri);
      when(() => httpClient.get(logoutUri, headers: any(named: 'headers')))
          .thenAnswer((invocation) async => Response('', 200,
              request: Request('GET', invocation.positionalArguments[0])));

      final response = await authenticator.logout();
      verify(() => httpClient.get(logoutUri, headers: any(named: 'headers')))
          .called(1);
      expect(response!.statusCode, 200);
      expect(response.request!.url, logoutUri);
    });
  });

  group('Is Authenticated', () {
    test('isAuthentcated  returns Status of token', () async {
      final authenticator = ApptiveGridAuthenticator();

      expect(authenticator.isAuthenticated, false);

      final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      authenticator.setToken(token);

      expect(authenticator.isAuthenticated, true);
    });
  });

  group('External Auth', () {
    test('Redirected from outside calls authenticator', () async {
      final tokenTime = DateTime.now();
      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final httpClient = MockHttpClient();
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
              encoding: any(named: 'encoding')))
          .thenAnswer((invocation) async => Response(
              jsonEncode(tokenResponse.toJson()), 200,
              request: Request('POST', invocation.positionalArguments[0])));

      final urlCompleter = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          )).thenAnswer((invocation) async {
        urlCompleter.complete(Uri.parse(invocation.positionalArguments[0])
            .queryParameters['state']);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView())
          .thenThrow(MissingPluginException());
      UrlLauncherPlatform.instance = urlLauncher;

      final customScheme = 'customscheme';
      authenticator = ApptiveGridAuthenticator(
        options: ApptiveGridOptions(
            authenticationOptions: ApptiveGridAuthenticationOptions(
          redirectScheme: customScheme,
        )),
        httpClient: httpClient,
      );
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final credential = Credential.fromJson({
        'issuer': authClient.issuer!.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(() => authClient.createCredential(
            tokenType: any(named: 'tokenType'),
            accessToken: any(named: 'accessToken'),
          )).thenReturn(credential);

      final completer = Completer<Credential>();
      unawaited(authenticator
          .authenticate()
          .then((value) => completer.complete(value)));
      final state = await urlCompleter.future;
      final responseMap = {
        'state': state,
        'code': 'code',
      };

      final uri =
          Uri(scheme: customScheme, queryParameters: responseMap, host: 'host');

      streamController.add(uri.toString());
      final completerResult = await completer.future;
      final resultCredential = await completerResult
          .getTokenResponse()
          .timeout(Duration(seconds: 5));
      final credentialToken =
          await credential.getTokenResponse().timeout(Duration(seconds: 5));
      expect(resultCredential, credentialToken);
    });
  });

  group('ApiKey Authentication', () {
    final options = ApptiveGridOptions(
        authenticationOptions: ApptiveGridAuthenticationOptions(
      apiKey: ApptiveGridApiKey(authKey: 'authKey', password: 'password'),
    ));

    test('isAuthenticated', () {
      final authenticator = ApptiveGridAuthenticator(options: options);

      expect(authenticator.isAuthenticated, true);
    });

    test('Sets Header', () {
      final authenticator = ApptiveGridAuthenticator(options: options);

      expect(authenticator.header!.split(' ')[0], 'Basic');
      expect(authenticator.header!.split(' ')[1],
          base64Encode(utf8.encode('authKey:password')));
    });

    test('Check Authentication calls nothing', () async {
      final httpClient = MockHttpClient();
      final authenticator =
          ApptiveGridAuthenticator(options: options, httpClient: httpClient);

      await authenticator.checkAuthentication();

      verifyZeroInteractions(httpClient);
    });
  });
}

Issuer get _zweidenkerIssuer => Issuer(
      OpenIdProviderMetadata.fromJson({
        'issuer': 'https://iam.zweidenker.de/auth/realms/apptiveGrid',
        'authorization_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/auth',
        'token_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/token',
        'introspection_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/token/introspect',
        'userinfo_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/userinfo',
        'end_session_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/logout',
        'jwks_uri':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/certs',
        'check_session_iframe':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/login-status-iframe.html',
        'grant_types_supported':
            '[authorization_code, implicit, refresh_token, password, client_credentials]',
        'response_types_supported':
            '[code, none, id_token, token, id_token token, code id_token, code token, code id_token token]',
        'subject_types_supported': '[public, pairwise]',
        'id_token_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]',
        'id_token_encryption_alg_values_supported':
            '[RSA-OAEP, RSA-OAEP-256, RSA1_5]',
        'id_token_encryption_enc_values_supported':
            '[A256GCM, A192GCM, A128GCM, A128CBC-HS256, A192CBC-HS384, A256CBC-HS512]',
        'userinfo_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512, none]',
        'request_object_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512, none]',
        'response_modes_supported': '[query, fragment, form_post]',
        'registration_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/clients-registrations/openid-connect',
        'token_endpoint_auth_methods_supported': [
          'private_key_jwt',
          'client_secret_basic',
          'client_secret_post',
          'tls_client_auth',
          'client_secret_jwt'
        ],
        'token_endpoint_auth_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]',
        'claims_supported':
            '[aud, sub, iss, auth_time, name, given_name, family_name, preferred_username, email, acr]',
        'claim_types_supported': '[normal]',
        'claims_parameter_supported': 'true',
        'scopes_supported':
            '[openid, offline_access, profile, email, address, phone, roles, web-origins, microprofile-jwt]',
        'request_parameter_supported': 'true',
        'request_uri_parameter_supported': 'true',
        'require_request_uri_registration': 'true',
        'code_challenge_methods_supported': '[plain, S256]',
        'tls_client_certificate_bound_access_tokens': 'true',
        'revocation_endpoint':
            'https://iam.zweidenker.de/auth/realms/apptiveGrid/protocol/openid-connect/revoke',
        'revocation_endpoint_auth_methods_supported':
            '[private_key_jwt, client_secret_basic, client_secret_post, tls_client_auth, client_secret_jwt]',
        'revocation_endpoint_auth_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]',
        'backchannel_logout_supported': 'true',
        'backchannel_logout_session_supported': 'true',
      }),
    );
