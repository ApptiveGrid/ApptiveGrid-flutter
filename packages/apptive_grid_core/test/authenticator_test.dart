@TestOn('!browser')
import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:apptive_grid_core/src/network/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart' as openid;
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'mocks.dart';

void main() {
  late StreamController<String?> streamController;
  late ApptiveGridAuthenticator authenticator;

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(const LaunchOptions());

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
      when(
        () => httpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer(
        (invocation) async => Response(
          jsonEncode(tokenResponse.toJson()),
          200,
          request: Request('POST', invocation.positionalArguments[0]),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json},
        ),
      );

      final urlCompleter = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(
        () => urlLauncher.launch(
          any(),
          useSafariVC: any(named: 'useSafariVC'),
          useWebView: any(named: 'useWebView'),
          enableJavaScript: any(named: 'enableJavaScript'),
          enableDomStorage: any(named: 'enableDomStorage'),
          universalLinksOnly: any(named: 'universalLinksOnly'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        urlCompleter.complete(
          Uri.parse(invocation.positionalArguments[0]).queryParameters['state'],
        );
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView())
          .thenThrow(MissingPluginException());
      UrlLauncherPlatform.instance = urlLauncher;

      const customScheme = 'customscheme';
      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            redirectScheme: customScheme,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        client: client,
        httpClient: httpClient,
      );
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final credential = Credential.fromJson({
        'issuer': authClient.issuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(
        () => authClient.createCredential(
          tokenType: any(named: 'tokenType'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenReturn(credential);

      final completer = Completer<Credential>();

      final testAuthenticator = MockAuthenticator();
      final mockCredential = MockCredential();
      final token = MockToken();
      when(() => token.toJson()).thenReturn(<String, dynamic>{});
      when(() => mockCredential.getTokenResponse())
          .thenAnswer((invocation) async => token);
      authenticator.testAuthenticator = testAuthenticator;
      when(() => testAuthenticator.authorize()).thenAnswer((invocation) async {
        //launch(_zweidenkerIssuer.metadata.tokenEndpoint.toString());
        completer.complete(mockCredential);
        urlCompleter.complete('state');
        return mockCredential;
      });
      when(() => testAuthenticator.processResult(any()))
          .thenAnswer((_) async {});

      await authenticator.authenticate();
      final state = await urlCompleter.future;
      final responseMap = {
        'state': state,
        'code': 'code',
      };

      final uri =
          Uri(scheme: customScheme, queryParameters: responseMap, host: 'host');

      streamController.add(uri.toString());
      final completerResult = await completer.future;
      await completerResult.getTokenResponse();
      await credential.getTokenResponse();
      verify(() => testAuthenticator.processResult(responseMap)).called(1);
    });

    test('True Client', () async {
      final tokenTime = DateTime.now();
      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final httpClient = MockHttpClient();
      when(
        () => httpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer(
        (invocation) async => Response(
          jsonEncode(tokenResponse.toJson()),
          200,
          request: Request('POST', invocation.positionalArguments[0]),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json},
        ),
      );

      final urlCompleter = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(
        () => urlLauncher.launchUrl(
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async {
        urlCompleter.complete(
          Uri.parse(invocation.positionalArguments[0]).queryParameters['state'],
        );
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView())
          .thenThrow(MissingPluginException());
      UrlLauncherPlatform.instance = urlLauncher;

      const customScheme = 'customscheme';
      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            redirectScheme: customScheme,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        client: client,
        httpClient: httpClient,
      );
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      authenticator.setAuthClient(authClient);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final credential = Credential.fromJson({
        'issuer': authClient.issuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(
        () => authClient.createCredential(
          tokenType: any(named: 'tokenType'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenReturn(credential);

      final mockCredential = MockCredential();
      final token = MockToken();
      when(() => token.toJson()).thenReturn(<String, dynamic>{});
      when(() => mockCredential.getTokenResponse())
          .thenAnswer((invocation) async => token);

      final credentialCompleter = Completer<Credential>();
      authenticator
          .authenticate()
          .then((value) => credentialCompleter.complete(value));
      final state = await urlCompleter.future;
      final responseMap = {
        'state': state,
        'code': 'code',
      };

      final uri =
          Uri(scheme: customScheme, queryParameters: responseMap, host: 'host');

      streamController.add(uri.toString());
      final authResult = await credentialCompleter.future;

      expect(authResult.toJson(), credential.toJson());
    });
  });

  group('Header', () {
    late MockHttpClient httpClient;
    final client = MockApptiveGridClient();
    when(() => client.options).thenReturn(const ApptiveGridOptions());

    setUp(() {
      httpClient = MockHttpClient();
    });

    test('Has Token returns Token', () {
      authenticator = ApptiveGridAuthenticator(
        client: client,
        httpClient: httpClient,
      );
      final token = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );
      authenticator.setToken(token);

      expect(authenticator.header, equals('Bearer 12345'));
    });

    test('Has no Token returns null', () {
      authenticator = ApptiveGridAuthenticator(
        client: client,
        httpClient: httpClient,
      );
      expect(authenticator.header, isNull);
    });
  });

  group('checkAuthentication', () {
    late MockHttpClient httpClient;

    setUp(() {
      httpClient = MockHttpClient();
    });

    test('No Token, Auto Authenticate, authenticates', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final urlLauncher = MockUrlLauncher();
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});

      UrlLauncherPlatform.instance = urlLauncher;

      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        httpClient: httpClient,
        client: client,
      );

      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );
      final authClient = MockAuthClient();
      authenticator.setAuthClient(authClient);
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('clientId');
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);
      await authenticator.setCredential(credential);
      await authenticator.checkAuthentication();

      verify(() => mockAuthBackend.authorize()).called(1);
    });

    test('Expired Token Refreshes', () async {
      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(const ApptiveGridOptions());
      authenticator = ApptiveGridAuthenticator(
        client: client,
        httpClient: httpClient,
      );

      // Current token should be Expired
      final now = DateTime.now();
      final token = MockToken();
      when(() => token.expiresAt)
          .thenReturn(now.subtract(const Duration(seconds: 20)));
      when(() => token.toJson()).thenReturn(<String, dynamic>{});

      await authenticator.setToken(token);

      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final authClient = MockAuthClient();
      authenticator.setAuthClient(authClient);
      final credential = MockCredential();
      await authenticator.setCredential(credential);
      final newToken = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );
      when(
        () => authClient.createCredential(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
          expiresAt: any(named: 'expiresAt'),
        ),
      ).thenReturn(credential);
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('clientId');
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse(any()))
          .thenAnswer((invocation) async => newToken);

      await authenticator.checkAuthentication();

      // Check if new Token is used in Header
      expect(authenticator.header, equals('Bearer 12345'));
      verify(() => credential.getTokenResponse(any())).called(1);
    });
  });

  group('Authenticate', () {
    setUpAll(() {
      registerFallbackValue(<String, String>{});
    });

    final client = MockApptiveGridClient();
    when(() => client.options).thenReturn(const ApptiveGridOptions());

    test('Opens Url', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(
        () => urlLauncher.launchUrl(
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView()).thenAnswer((invocation) async {});
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator(client: client);

      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('Id');
      when(() => authClient.httpClient).thenReturn(MockHttpClient());
      authenticator.setAuthClient(authClient);

      final testAuthenticator = MockAuthenticator();
      final credential = MockCredential();
      final token = MockToken();
      when(() => token.toJson()).thenReturn(<String, dynamic>{});
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => token);
      authenticator.testAuthenticator = testAuthenticator;
      when(() => testAuthenticator.authorize()).thenAnswer((invocation) async {
        launchUrl(_zweidenkerIssuer.metadata.tokenEndpoint!);
        return credential;
      });

      await authenticator.authenticate();
      final launchedUrl = await completer.future;
      expect(
        launchedUrl,
        'https://app.apptivegrid.de/auth/apptivegrid/token',
      );
    });

    test('Missing Plugin Exception gets Caught', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(
        () => urlLauncher.launch(
          any(),
          useSafariVC: any(named: 'useSafariVC'),
          useWebView: any(named: 'useWebView'),
          enableJavaScript: any(named: 'enableJavaScript'),
          enableDomStorage: any(named: 'enableDomStorage'),
          universalLinksOnly: any(named: 'universalLinksOnly'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView())
          .thenThrow(MissingPluginException());
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator(client: client);

      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('Id');
      when(() => authClient.httpClient).thenReturn(MockHttpClient());
      authenticator.setAuthClient(authClient);
      await authenticator.authenticate();
    });

    test('Unimplemented Error gets Caught', () async {
      final completer = Completer<String>();
      final urlLauncher = MockUrlLauncher();
      when(
        () => urlLauncher.launch(
          any(),
          useSafariVC: any(named: 'useSafariVC'),
          useWebView: any(named: 'useWebView'),
          enableJavaScript: any(named: 'enableJavaScript'),
          enableDomStorage: any(named: 'enableDomStorage'),
          universalLinksOnly: any(named: 'universalLinksOnly'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        completer.complete(invocation.positionalArguments[0]);
        return true;
      });
      when(() => urlLauncher.canLaunch(any()))
          .thenAnswer((invocation) async => true);
      when(() => urlLauncher.closeWebView()).thenThrow(UnimplementedError());
      UrlLauncherPlatform.instance = urlLauncher;

      authenticator = ApptiveGridAuthenticator(client: client);
      // Mock AuthBackend Return a new Token
      final mockAuthBackend = MockAuthenticator();
      authenticator.testAuthenticator = mockAuthBackend;
      final credential = MockCredential();
      final newToken = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );
      when(() => mockAuthBackend.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => credential.getTokenResponse())
          .thenAnswer((invocation) async => newToken);
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('Id');
      when(() => authClient.httpClient).thenReturn(MockHttpClient());
      authenticator.setAuthClient(authClient);
      await authenticator.authenticate();
    });
  });

  group('Create Client', () {
    final agClient = MockApptiveGridClient();
    when(() => agClient.options).thenReturn(const ApptiveGridOptions());
    test('Creates new Client', () async {
      final httpClient = MockHttpClient();
      authenticator =
          ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);

      final client = await authenticator.authClient;
      expect(
        client.issuer.metadata.toJson(),
        _zweidenkerIssuer.metadata.toJson(),
      );
    });

    test('No saved token, auto authenticate true, not authenticate', () async {
      final httpClient = MockHttpClient();
      final tokenStorage = MockAuthenticationStorage();
      final originalUniLinks = UniLinksPlatform.instance;
      final mockUniLinks = MockUniLinks();
      when(() => mockUniLinks.linkStream).thenAnswer((_) => Stream.value(null));
      UniLinksPlatform.instance = mockUniLinks;
      when(() => tokenStorage.credential).thenAnswer((_) => null);

      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );

      authenticator = ApptiveGridAuthenticator(
        authenticationStorage: tokenStorage,
        client: client,
        httpClient: httpClient,
      );

      final isAuthenticated = await authenticator.isAuthenticated;

      expect(isAuthenticated, equals(false));

      UniLinksPlatform.instance = originalUniLinks;
    });
  });

  group('Logout', () {
    test('Logout calls http Client', () async {
      final httpClient = MockHttpClient();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(const ApptiveGridOptions());
      authenticator =
          ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);
      final logoutUri = Uri.parse('https://log.me/out');

      final credential = MockCredential();
      final token = TokenResponse.fromJson(
        {
          'token_type': 'Bearer',
          'access_token': '12345',
          'id_token':
              '''eyJraWQiOiIxZTlnZGs3IiwiYWxnIjoiUlMyNTYifQ.ewogImlzcyI6ICJodHRwOi8vc2VydmVyLmV4YW1wbGUuY29tIiwKICJzdWIiOiAiMjQ4Mjg5NzYxMDAxIiwKICJhdWQiOiAiczZCaGRSa3F0MyIsCiAibm9uY2UiOiAibi0wUzZfV3pBMk1qIiwKICJleHAiOiAxMzExMjgxOTcwLAogImlhdCI6IDEzMTEyODA5NzAsCiAibmFtZSI6ICJKYW5lIERvZSIsCiAiZ2l2ZW5fbmFtZSI6ICJKYW5lIiwKICJmYW1pbHlfbmFtZSI6ICJEb2UiLAogImdlbmRlciI6ICJmZW1hbGUiLAogImJpcnRoZGF0ZSI6ICIwMDAwLTEwLTMxIiwKICJlbWFpbCI6ICJqYW5lZG9lQGV4YW1wbGUuY29tIiwKICJwaWN0dXJlIjogImh0dHA6Ly9leGFtcGxlLmNvbS9qYW5lZG9lL21lLmpwZyIKfQ.rHQjEmBqn9Jre0OLykYNnspA10Qql2rvx4FsD00jwlB0Sym4NzpgvPKsDjn_wMkHxcp6CilPcoKrWHcipR2iAjzLvDNAReF97zoJqq880ZD1bwY82JDauCXELVR9O6_B0w3K-E7yM2macAAgNCUwtik6SjoSUZRcf-O5lygIyLENx882p6MtmwaL1hd6qn5RZOQ0TLrOYu0532g9Exxcm-ChymrB4xLykpDj3lUivJt63eEGGN6DH5K6o33TcxkIjNrCD4XB1CKKumZvCedgHHF3IAK4dVEDSUoGlH9z4pP_eWYNXvqQOjGs-rDaQzUHl6cQQWNiDpWOl_lxXjQEvQ'''
        },
      );

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      await authenticator.setToken(token);
      await authenticator.setCredential(credential);

      when(() => credential.generateLogoutUrl())
          .thenAnswer((invocation) => logoutUri);
      when(() => httpClient.get(logoutUri, headers: any(named: 'headers')))
          .thenAnswer(
        (invocation) async => Response(
          '',
          200,
          request: Request('GET', invocation.positionalArguments[0]),
        ),
      );

      final response = await authenticator.logout();
      /* verify(() => httpClient.get(logoutUri, headers: any(named: 'headers')))
          .called(1);*/
      expect(response!.statusCode, equals(200));
      expect(response.request!.url, equals(logoutUri));
      expect(await authenticator.isAuthenticated, false);
    });

    test('Logout call throws error, still clears token', () async {
      final httpClient = MockHttpClient();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(const ApptiveGridOptions());
      authenticator =
          ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);
      final logoutUri = Uri.parse('https://log.me/out');

      final credential = MockCredential();
      final token = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      await authenticator.setToken(token);
      await authenticator.setCredential(credential);

      when(() => credential.generateLogoutUrl())
          .thenAnswer((invocation) => logoutUri);
      when(() => httpClient.get(logoutUri, headers: any(named: 'headers')))
          .thenAnswer(
        (invocation) => Future.error(
          Response(
            '',
            400,
            request: Request('GET', invocation.positionalArguments[0]),
          ),
        ),
      );
      await authenticator.logout();
      expect(await authenticator.isAuthenticated, false);
    });
  });

  group('Is Authenticated', () {
    late MockHttpClient httpClient;

    setUp(() {
      httpClient = MockHttpClient();
    });

    group('isAuthenticated', () {
      test('With token returns true', () async {
        final agClient = MockApptiveGridClient();
        when(() => agClient.options).thenReturn(const ApptiveGridOptions());
        authenticator =
            ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);

        expect(await authenticator.isAuthenticated, equals(false));

        final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'},
        );

        await authenticator.setToken(token);

        expect(await authenticator.isAuthenticated, true);
      });

      test('With Api Key returns true', () async {
        final client = MockApptiveGridClient();
        when(() => client.options).thenReturn(
          const ApptiveGridOptions(
            authenticationOptions: ApptiveGridAuthenticationOptions(
              apiKey: ApptiveGridApiKey(
                authKey: 'authKey',
                password: 'password',
              ),
            ),
          ),
        );
        authenticator = ApptiveGridAuthenticator(
          httpClient: httpClient,
          client: client,
        );

        expect(await authenticator.isAuthenticated, equals(true));
      });
    });

    group('isAuthenticated with User token', () {
      test('With token returns true', () async {
        final agClient = MockApptiveGridClient();
        when(() => agClient.options).thenReturn(const ApptiveGridOptions());
        authenticator =
            ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);

        expect(await authenticator.isAuthenticatedWithToken, false);

        final token = TokenResponse.fromJson(
          {'token_type': 'Bearer', 'access_token': '12345'},
        );

        await authenticator.setToken(token);

        expect(await authenticator.isAuthenticatedWithToken, true);
      });

      test('With Api Key returns true', () async {
        final client = MockApptiveGridClient();
        when(() => client.options).thenReturn(
          const ApptiveGridOptions(
            authenticationOptions: ApptiveGridAuthenticationOptions(
              apiKey: ApptiveGridApiKey(
                authKey: 'authKey',
                password: 'password',
              ),
            ),
          ),
        );
        authenticator = ApptiveGridAuthenticator(
          httpClient: httpClient,
          client: client,
        );

        expect(await authenticator.isAuthenticatedWithToken, false);
      });
    });
  });

  group('ApiKey Authentication', () {
    const options = ApptiveGridOptions(
      authenticationOptions: ApptiveGridAuthenticationOptions(
        apiKey: ApptiveGridApiKey(authKey: 'authKey', password: 'password'),
      ),
    );

    final agClient = MockApptiveGridClient();
    when(() => agClient.options).thenReturn(options);

    test('isAuthenticated', () async {
      authenticator = ApptiveGridAuthenticator(client: agClient);

      expect(await authenticator.isAuthenticated, equals(true));
    });

    test('Sets Header', () {
      authenticator = ApptiveGridAuthenticator(client: agClient);

      expect(authenticator.header!.split(' ')[0], equals('Basic'));
      expect(
        authenticator.header!.split(' ')[1],
        base64Encode(utf8.encode('authKey:password')),
      );
    });

    test('Check Authentication calls nothing', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final httpClient = MockHttpClient();
      authenticator =
          ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);

      await authenticator.checkAuthentication();

      verifyZeroInteractions(httpClient);
    });
  });

  group('Token Storage', () {
    test(
        'Storage Provided '
        'Credential gets saved', () async {
      final httpClient = MockHttpClient();
      final storage = MockAuthenticationStorage();
      final testAuthenticator = MockAuthenticator();
      final credential = MockCredential();
      final jsonCredential = {'mock': 'credential'};
      final token = TokenResponse.fromJson(
        {'token_type': 'Bearer', 'access_token': '12345'},
      );

      when(() => credential.getTokenResponse(any()))
          .thenAnswer((invocation) async => token);
      when(() => credential.toJson()).thenReturn(jsonCredential);

      final client = MockApptiveGridClient();
      when(() => client.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );

      authenticator = ApptiveGridAuthenticator(
        httpClient: httpClient,
        client: client,
        authenticationStorage: storage,
      );

      when(() => storage.saveCredential(any())).thenAnswer((_) {});
      when(() => testAuthenticator.authorize())
          .thenAnswer((_) async => credential);

      authenticator.testAuthenticator = testAuthenticator;

      final authClient = MockAuthClient();
      authenticator.setAuthClient(authClient);
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientId).thenReturn('clientId');

      await authenticator.authenticate();

      verify(() => storage.saveCredential(jsonEncode(jsonCredential)))
          .called(1);
    });

    test(
        'Storage Provided '
        'Credential gets restored', () async {
      final tokenTime = DateTime.now();
      final httpClient = MockHttpClient();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final credential = Credential.fromJson({
        'issuer': authClient.issuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(
        () => authClient.createCredential(
          tokenType: any(named: 'tokenType'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenReturn(credential);
      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer(
        (invocation) async => Response(
          jsonEncode(tokenResponse.toJson()),
          200,
          headers: {HttpHeaders.contentTypeHeader: ContentType.json},
          request: Request('POST', invocation.positionalArguments[0]),
        ),
      );

      final testAuthenticator = MockAuthenticator();

      final storage = MockAuthenticationStorage();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        client: agClient,
        authenticationStorage: storage,
        httpClient: httpClient,
      );
      authenticator.testAuthenticator = testAuthenticator;

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      when(() => storage.credential)
          .thenAnswer((invocation) => jsonEncode(credential.toJson()));

      await authenticator.checkAuthentication();

      verifyNever(testAuthenticator.authorize);
      expect(await authenticator.isAuthenticated, equals(true));
    });

    test(
        'Storage Provided '
        'Saved Credential Invalid '
        'Calls authenticate', () async {
      final tokenTime = DateTime.now();
      final httpClient = MockHttpClient();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final credential = Credential.fromJson({
        'issuer': authClient.issuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(
        () => authClient.createCredential(
          tokenType: any(named: 'tokenType'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenReturn(credential);
      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer(
        (invocation) => Future.error(OpenIdException('Invalid Token', 'Test')),
      );

      final testAuthenticator = MockAuthenticator();

      final storage = MockAuthenticationStorage();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        client: agClient,
        authenticationStorage: storage,
        httpClient: httpClient,
      );
      authenticator.testAuthenticator = testAuthenticator;
      authenticator.setAuthClient(MockAuthClient());

      when(() => storage.credential)
          .thenAnswer((invocation) => jsonEncode(credential.toJson()));
      final authCredential = MockCredential();
      when(() => authCredential.getTokenResponse(any()))
          .thenAnswer((invocation) async => tokenResponse);
      when(() => testAuthenticator.authorize())
          .thenAnswer((_) async => authCredential);
      when(() => authCredential.toJson()).thenReturn({});

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      await authenticator.checkAuthentication();

      verify(testAuthenticator.authorize).called(1);
      expect(await authenticator.isAuthenticated, equals(true));
    });

    test(
        'Storage Provided '
        'Saved Credential from invalid issuer '
        'Deletes token', () async {
      final tokenTime = DateTime.now();
      final httpClient = MockHttpClient();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final credential = Credential.fromJson({
        'issuer': _invalidIssuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });

      final storage = MockAuthenticationStorage();

      when(() => storage.credential)
          .thenAnswer((invocation) => jsonEncode(credential.toJson()));

      final testAuthenticator = MockAuthenticator();
      when(() => testAuthenticator.authorize()).thenAnswer((_) async => null);

      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );

      authenticator = ApptiveGridAuthenticator(
        client: agClient,
        authenticationStorage: storage,
        httpClient: httpClient,
      );
      authenticator.setAuthClient(authClient);
      authenticator.testAuthenticator = testAuthenticator;

      await authenticator.checkAuthentication();

      verify(
        () => storage.saveCredential(null),
      ).called(greaterThanOrEqualTo(1));
    });

    test(
        'Storage Provided '
        'Error '
        'Calls authenticate', () async {
      final tokenTime = DateTime.now();
      final httpClient = MockHttpClient();
      final authClient = MockAuthClient();
      when(() => authClient.issuer).thenReturn(_zweidenkerIssuer);
      when(() => authClient.clientSecret).thenReturn('');
      when(() => authClient.clientId).thenReturn('test');
      when(() => authClient.httpClient).thenReturn(httpClient);

      final tokenResponse = TokenResponse.fromJson({
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      });
      final credential = Credential.fromJson({
        'issuer': authClient.issuer.metadata.toJson(),
        'client_id': authClient.clientId,
        'client_secret': authClient.clientSecret,
        'token': tokenResponse.toJson(),
        'nonce': null
      });
      when(
        () => authClient.createCredential(
          tokenType: any(named: 'tokenType'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenReturn(credential);
      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer(
        (invocation) => Future.error(Exception('Error')),
      );

      final testAuthenticator = MockAuthenticator();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );

      final storage = MockAuthenticationStorage();
      authenticator = ApptiveGridAuthenticator(
        client: agClient,
        authenticationStorage: storage,
        httpClient: httpClient,
      );
      authenticator.testAuthenticator = testAuthenticator;
      authenticator.setAuthClient(MockAuthClient());

      when(() => storage.credential)
          .thenAnswer((invocation) => jsonEncode(credential.toJson()));
      final authCredential = MockCredential();
      when(() => authCredential.getTokenResponse(any()))
          .thenAnswer((invocation) async => tokenResponse);
      when(() => testAuthenticator.authorize())
          .thenAnswer((_) async => authCredential);
      when(() => authCredential.toJson()).thenReturn({});

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      await authenticator.checkAuthentication();

      verify(testAuthenticator.authorize).called(1);
      expect(await authenticator.isAuthenticated, equals(true));
    });

    test(
        'Storage Provided '
        'No Stored '
        'Authenticate is called', () async {
      final testAuthenticator = MockAuthenticator();

      final storage = MockAuthenticationStorage();

      final httpClient = MockHttpClient();

      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        httpClient: httpClient,
        client: agClient,
        authenticationStorage: storage,
      );
      authenticator.testAuthenticator = testAuthenticator;

      final credential = MockCredential();
      final token = MockToken();
      when(() => credential.toJson()).thenAnswer((_) => <String, dynamic>{});
      when(() => credential.getTokenResponse(any()))
          .thenAnswer((_) async => token);
      when(() => token.toJson()).thenReturn(<String, dynamic>{});
      when(() => testAuthenticator.authorize())
          .thenAnswer((invocation) async => credential);
      when(() => storage.credential).thenAnswer((_) => null);

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      await authenticator.checkAuthentication();

      verify(testAuthenticator.authorize).called(1);
      expect(await authenticator.isAuthenticated, equals(true));
    });

    test(
        'Default Secure Storage '
        'uses FlutterSecureStorage', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final secureStorage = MockSecureStorage();
      FlutterSecureStoragePlatform.instance = secureStorage;
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => secureStorage.read(
          key: any(named: 'key'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => null);

      final testAuthenticator = MockAuthenticator();

      final httpClient = MockHttpClient();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
            persistCredentials: true,
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        httpClient: httpClient,
        client: agClient,
      );
      authenticator.testAuthenticator = testAuthenticator;

      final client = MockAuthClient();
      authenticator.setAuthClient(client);
      when(() => client.issuer).thenReturn(_zweidenkerIssuer);
      when(() => client.clientId).thenReturn('clientId');

      final credential = MockCredential();
      final token = MockToken();
      when(() => credential.toJson()).thenAnswer((_) => <String, dynamic>{});
      when(() => credential.getTokenResponse(any()))
          .thenAnswer((_) async => token);
      when(() => token.toJson()).thenReturn(<String, dynamic>{});
      when(() => testAuthenticator.authorize())
          .thenAnswer((invocation) async => credential);

      await authenticator.checkAuthentication();

      verify(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          options: any(named: 'options'),
        ),
      ).called(
        2, // Creation of Authenticator reloads credential, Setting token also saves credential
      );
      verify(
        () => secureStorage.read(
          key: any(named: 'key'),
          options: any(named: 'options'),
        ),
      ).called(2); // Value is read also at creation of authenticator
    });
  });

  group('Set User token', () {
    test('Set Token authenticates User', () async {
      final httpClient = MockHttpClient();
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(const ApptiveGridOptions());
      authenticator =
          ApptiveGridAuthenticator(client: agClient, httpClient: httpClient);

      final tokenTime = DateTime.now();
      final tokenResponse = {
        'token_type': 'Bearer',
        'access_token': '12345',
        'expires_at': tokenTime.millisecondsSinceEpoch,
        'expires_in': tokenTime.microsecondsSinceEpoch
      };

      await authenticator.setUserToken(tokenResponse);

      expect(await authenticator.isAuthenticatedWithToken, true);
    });
  });

  group('Authenticator', () {
    final urlLauncher = MockUrlLauncher();

    setUp(() {
      UrlLauncherPlatform.instance = urlLauncher;
    });

    test('Authenticates', () async {
      final httpClient = MockHttpClient();

      late final openid.Credential credential;
      final agClient = MockApptiveGridClient();
      when(() => agClient.options).thenReturn(
        const ApptiveGridOptions(
          authenticationOptions: ApptiveGridAuthenticationOptions(
            redirectScheme: 'customRedirect',
          ),
        ),
      );
      authenticator = ApptiveGridAuthenticator(
        httpClient: httpClient,
        client: agClient,
      );

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => urlLauncher.closeWebView()).thenAnswer((_) async {});
      when(
        () => urlLauncher.launchUrl(
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async {
        final uri = Uri.parse(invocation.positionalArguments.first as String);
        final state = uri.queryParameters['state']!;

        final tokenResponse = TokenResponse.fromJson({
          'state': state,
          'token_type': 'Bearer',
          'access_token': '12345',
        });

        credential = Credential.fromJson(
          {
            'state': state,
            'issuer': _zweidenkerIssuer.metadata.toJson(),
            'client_id': 'web',
            'client_secret': '',
            'token': tokenResponse.toJson(),
          },
          httpClient: httpClient,
        );

        final response = {
          'state': state,
          ...tokenResponse
              .toJson()
              .map((key, value) => MapEntry(key, value.toString())),
        };
        await openid.Authenticator.processResult(response);

        return true;
      });

      final authResult = await authenticator.authenticate();

      expect(authResult!.toJson(), credential.toJson());
    });
  });
}

Issuer get _zweidenkerIssuer => Issuer(
      OpenIdProviderMetadata.fromJson({
        'issuer': 'https://app.apptivegrid.de/auth/apptivegrid',
        'authorization_endpoint':
            'https://app.apptivegrid.de/auth/apptivegrid/authorize',
        'token_endpoint': 'https://app.apptivegrid.de/auth/apptivegrid/token',
        'introspection_endpoint':
            'https://app.apptivegrid.de/auth/apptivegrid/protocol/openid-connect/token/introspect',
        'userinfo_endpoint':
            'https://app.apptivegrid.de/auth/apptivegrid/protocol/openid-connect/userinfo',
        'end_session_endpoint':
            'https://app.apptivegrid.de/auth/apptivegrid/logout',
        'jwks_uri':
            'https://app.apptivegrid.de/auth/apptivegrid/protocol/openid-connect/certs',
        'check_session_iframe':
            'https://app.apptivegrid.de/auth/apptivegrid/protocol/openid-connect/login-status-iframe.html',
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
            'https://app.apptivegrid.de/auth/apptivegrid/clients-registrations/openid-connect',
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
            'https://app.apptivegrid.de/auth/apptivegrid/protocol/openid-connect/revoke',
        'revocation_endpoint_auth_methods_supported':
            '[private_key_jwt, client_secret_basic, client_secret_post, tls_client_auth, client_secret_jwt]',
        'revocation_endpoint_auth_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]',
        'backchannel_logout_supported': 'true',
        'backchannel_logout_session_supported': 'true',
      }),
    );

Issuer get _invalidIssuer => Issuer(
      OpenIdProviderMetadata.fromJson({
        'issuer': 'https://iam.zweidenker.de/auth/apptivegrid',
        'authorization_endpoint':
            'https://iam.zweidenkerde/auth/apptivegrid/authorize',
        'token_endpoint': 'https://iam.zweidenkerde/auth/apptivegrid/token',
        'introspection_endpoint':
            'https://iam.zweidenkerde/auth/apptivegrid/protocol/openid-connect/token/introspect',
        'userinfo_endpoint':
            'https://iam.zweidenkerde/auth/apptivegrid/protocol/openid-connect/userinfo',
        'end_session_endpoint':
            'https://iam.zweidenkerde/auth/apptivegrid/logout',
        'jwks_uri':
            'https://iam.zweidenkerde/auth/apptivegrid/protocol/openid-connect/certs',
        'check_session_iframe':
            'https://iam.zweidenkerde/auth/apptivegrid/protocol/openid-connect/login-status-iframe.html',
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
            'https://iam.zweidenkerde/auth/apptivegrid/clients-registrations/openid-connect',
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
            'https://iam.zweidenkerde/auth/apptivegrid/protocol/openid-connect/revoke',
        'revocation_endpoint_auth_methods_supported':
            '[private_key_jwt, client_secret_basic, client_secret_post, tls_client_auth, client_secret_jwt]',
        'revocation_endpoint_auth_signing_alg_values_supported':
            '[PS384, ES384, RS384, HS256, HS512, ES256, RS256, HS384, ES512, PS256, PS512, RS512]',
        'backchannel_logout_supported': 'true',
        'backchannel_logout_session_supported': 'true',
      }),
    );
