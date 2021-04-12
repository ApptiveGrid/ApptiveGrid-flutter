import 'dart:async';

import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/network/active_grid_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'mocks.dart';

main() {
  group("Header", () {
    test('Has Token returns Token', () {
      final authenticator =
          ActiveGridAuthenticator(options: ActiveGridOptions());
      final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'});
      authenticator.setToken(token);

      expect(authenticator.header, 'Bearer 12345');
    });

    test('Has no Token returns null', () {
      final authenticator =
          ActiveGridAuthenticator(options: ActiveGridOptions());
      expect(authenticator.header, null);
    });
  });

  group('checkAuthentication', () {
    test('No Token, Auto Authenticate, authenticates', () async {
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});

      UrlLauncherPlatform.instance = urlLauncher;

      final authenticator = ActiveGridAuthenticator(
        options: ActiveGridOptions(
          authenticationOptions: ActiveGridAuthenticationOptions(
            autoAuthenticate: true,
          ),
        ),
      );

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

      await authenticator.checkAuthentication();

      verify(() => mockAuthBackend.authorize()).called(1);
    });

    test('Expired Token Refreshes', () async {
      final authenticator =
          ActiveGridAuthenticator(options: ActiveGridOptions());

      // Current token should be Expired
      final token = MockToken();
      when(() => token.expiresIn).thenReturn(Duration(seconds: -1));
      authenticator.setToken(token);

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

      await authenticator.checkAuthentication();

      // Check if new Token is used in Header
      expect(authenticator.header, 'Bearer 12345');
    });
  });

  group('Authenticate', () {
    setUpAll(() {
      registerFallbackValue<Map<String, String>>(Map<String, String>());
    });

    test('Opens Url', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.launch(
            any(),
            useSafariVC: any(named: "useSafariVC"),
            useWebView: any(named: "useWebView"),
            enableJavaScript: any(named: "enableJavaScript"),
            enableDomStorage: any(named: "enableDomStorage"),
            universalLinksOnly: any(named: "universalLinksOnly"),
            headers: any(named: "headers"),
          )).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});
      UrlLauncherPlatform.instance = urlLauncher;

      final authenticator = ActiveGridAuthenticator();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      authenticator.authenticate();
      final launchedUrl = await completer.future;
      expect(
          launchedUrl
              .startsWith('https://iam.zweidenker.de/auth/realms/activegrid/'),
          true);
    });
  });
}

Issuer get _zweidenkerIssuer => Issuer(
      OpenIdProviderMetadata.fromJson({
        "issuer": "https://iam.zweidenker.de/auth/realms/activegrid",
        "authorization_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/auth",
        "token_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/token",
        "introspection_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/token/introspect",
        "userinfo_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/userinfo",
        "end_session_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/logout",
        "jwks_uri":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/certs",
        "check_session_iframe":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/login-status-iframe.html",
        "grant_types_supported":
            "[authorization_code, implicit, refresh_token, password, client_credentials]",
        "response_types_supported":
            "[code, none, id_token, token, id_token token, code id_token, code token, code id_token token]",
        "subject_types_supported": "[public, pairwise]",
        "id_token_signing_alg_values_supported":
            "[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]",
        "id_token_encryption_alg_values_supported":
            "[RSA-OAEP, RSA-OAEP-256, RSA1_5]",
        "id_token_encryption_enc_values_supported":
            "[A256GCM, A192GCM, A128GCM, A128CBC-HS256, A192CBC-HS384, A256CBC-HS512]",
        "userinfo_signing_alg_values_supported":
            "[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512, none]",
        "request_object_signing_alg_values_supported":
            "[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512, none]",
        "response_modes_supported": "[query, fragment, form_post]",
        "registration_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/clients-registrations/openid-connect",
        "token_endpoint_auth_methods_supported":
            "[private_key_jwt, client_secret_basic, client_secret_post, tls_client_auth, client_secret_jwt]",
        "token_endpoint_auth_signing_alg_values_supported":
            "[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]",
        "claims_supported":
            "[aud, sub, iss, auth_time, name, given_name, family_name, preferred_username, email, acr]",
        "claim_types_supported": "[normal]",
        "claims_parameter_supported": "true",
        "scopes_supported":
            "[openid, offline_access, profile, email, address, phone, roles, web-origins, microprofile-jwt]",
        "request_parameter_supported": "true",
        "request_uri_parameter_supported": "true",
        "require_request_uri_registration": "true",
        "code_challenge_methods_supported": "[plain, S256]",
        "tls_client_certificate_bound_access_tokens": "true",
        "revocation_endpoint":
            "https://iam.zweidenker.de/auth/realms/activegrid/protocol/openid-connect/revoke",
        "revocation_endpoint_auth_methods_supported":
            "[private_key_jwt, client_secret_basic, client_secret_post, tls_client_auth, client_secret_jwt]",
        "revocation_endpoint_auth_signing_alg_values_supported":
            "[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]",
        "backchannel_logout_supported": "true",
        "backchannel_logout_session_supported": "true",
      }),
    );
