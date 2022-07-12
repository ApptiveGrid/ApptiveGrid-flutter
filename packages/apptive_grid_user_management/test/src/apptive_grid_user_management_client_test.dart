import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('Register', () {
    test('Call returns response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final response = Response('', 200);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('users'),
            ),
          ),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        await client.register(
          firstName: 'firstName',
          lastName: 'lastName',
          email: 'email',
          password: 'password',
        ),
        response,
      );
    });

    test('Include Redirect Scheme', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        redirectScheme: 'customRedirect',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final response = Response('', 200);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('users'),
            ),
          ),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      await client.register(
        firstName: 'firstName',
        lastName: 'lastName',
        email: 'email',
        password: 'password',
      );
      final body = verify(
        () => httpClient.post(
          any(),
          body: captureAny(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).captured.first;

      expect(
        (jsonDecode(body) as Map).containsValue('customRedirect'),
        equals(true),
      );
    });

    test('Error throws response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final response = Response('', 400);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>((uri) => uri.pathSegments.contains('users')),
          ),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Future.error(response),
      );

      expect(
        () => client.register(
          firstName: 'firstName',
          lastName: 'lastName',
          email: 'email',
          password: 'password',
        ),
        throwsA(
          equals(response),
        ),
      );
    });
  });

  group('Login', () {
    test('Call returns response', () async {
      const group = 'group';
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      when(() => apptiveGridClient.setUserToken(any()))
          .thenAnswer((_) async {});
      final client = ApptiveGridUserManagementClient(
        group: group,
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final response = Response('{"key":"value"}', 200);
      when(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (uri) =>
                  uri.pathSegments.contains(group) &&
                  uri.pathSegments.contains('login'),
            ),
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        await client.login(email: 'email', password: 'password'),
        response,
      );

      verify(() => apptiveGridClient.setUserToken(jsonDecode(response.body)))
          .called(1);
    });

    test('Error throws response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final response = Response('', 400);
      when(
        () => httpClient.get(
          any(
            that: predicate<Uri>((uri) => uri.pathSegments.contains('login')),
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Future.error(response),
      );

      expect(
        () => client.login(email: 'email', password: 'password'),
        throwsA(
          equals(response),
        ),
      );
    });
  });

  group('Confirm', () {
    test('Call returns response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );
      final confirmationUri = Uri.parse('https://confirm.this');
      final response = Response('', 200);
      when(
        () => httpClient.get(confirmationUri, headers: any(named: 'headers')),
      ).thenAnswer((_) async => response);

      expect(
        await client.confirmAccount(confirmationUri: confirmationUri),
        response,
      );
    });

    test('Error throws response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final confirmationUri = Uri.parse('https://confirm.this');
      final response = Response('', 400);
      when(
        () => httpClient.get(confirmationUri, headers: any(named: 'headers')),
      ).thenAnswer((_) async => response);

      expect(
        () => client.confirmAccount(confirmationUri: confirmationUri),
        throwsA(
          equals(response),
        ),
      );
    });
  });

  group('Login after Confirmation', () {
    group('Confirmation', () {
      test('Registered before, Login success returns true', () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        when(() => apptiveGridClient.setUserToken(any()))
            .thenAnswer((_) async {});
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        final loginResponse = Response('{"key":"value"}', 200);
        when(
          () => httpClient.get(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('login'),
              ),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => loginResponse);

        final registrationResponse = Response('', 200);
        when(
          () => httpClient.post(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('users'),
              ),
            ),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => registrationResponse);

        await client.register(
          firstName: 'firstName',
          lastName: 'lastName',
          email: 'email',
          password: 'password',
        );

        expect(await client.loginAfterConfirmation(), equals(true));
      });

      test('Registered before, Login error returns false', () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        final loginResponse = Response('{"key":"value"}', 400);
        when(
          () => httpClient.get(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('login'),
              ),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => loginResponse);

        final registrationResponse = Response('', 200);
        when(
          () => httpClient.post(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('users'),
              ),
            ),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => registrationResponse);

        await client.register(
          firstName: 'firstName',
          lastName: 'lastName',
          email: 'email',
          password: 'password',
        );

        expect(await client.loginAfterConfirmation(), equals(false));
      });

      test('No registration returns false', () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        expect(await client.loginAfterConfirmation(), equals(false));
      });
    });

    group('Reset Password', () {
      test('Request reset, Reset Password, Login success returns true',
          () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        when(() => apptiveGridClient.setUserToken(any()))
            .thenAnswer((_) async {});
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        final loginResponse = Response('{"key":"value"}', 200);
        when(
          () => httpClient.get(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('login'),
              ),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => loginResponse);

        final requestResetResponse = Response('', 200);
        when(
          () => httpClient.post(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('forgotPassword'),
              ),
            ),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => requestResetResponse);

        final resetResponse = Response('', 200);
        final resetUri = Uri.parse('reset');
        when(
          () => httpClient.put(
            resetUri,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => resetResponse);

        await client.requestResetPassword(
          email: 'email',
        );

        await client.resetPassword(
          resetUri: resetUri,
          newPassword: 'newPassword',
        );

        expect(await client.loginAfterConfirmation(), equals(true));
      });

      test('Registered before, Login error returns false', () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        final loginResponse = Response('{"key":"value"}', 400);
        when(
          () => httpClient.get(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('login'),
              ),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => loginResponse);

        final requestResetResponse = Response('', 200);
        when(
          () => httpClient.post(
            any(
              that: predicate<Uri>(
                (uri) => uri.pathSegments.contains('forgotPassword'),
              ),
            ),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => requestResetResponse);

        final resetResponse = Response('', 200);
        final resetUri = Uri.parse('reset');
        when(
          () => httpClient.put(
            resetUri,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => resetResponse);

        await client.requestResetPassword(
          email: 'email',
        );

        await client.resetPassword(resetUri: resetUri, newPassword: 'password');

        expect(await client.loginAfterConfirmation(), equals(false));
      });

      test('No registration returns false', () async {
        final httpClient = MockHttpClient();
        final apptiveGridClient = MockApptiveGridClient();
        when(() => apptiveGridClient.options)
            .thenReturn(const ApptiveGridOptions());
        final client = ApptiveGridUserManagementClient(
          group: 'group',
          clientId: 'clientId',
          apptiveGridClient: apptiveGridClient,
          client: httpClient,
        );

        final resetResponse = Response('', 200);
        final resetUri = Uri.parse('reset');
        when(
          () => httpClient.put(
            resetUri,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => resetResponse);

        await client.resetPassword(resetUri: resetUri, newPassword: 'password');

        expect(await client.loginAfterConfirmation(), equals(false));
      });
    });
  });

  group('Request Reset', () {
    test('Call returns response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );
      const email = 'emailAddress';
      final response = Response('', 200);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('forgotPassword'),
            ),
          ),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        await client.requestResetPassword(email: email),
        response,
      );

      final capturedBody = jsonDecode(
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
          ),
        ).captured.first as String,
      );
      expect(capturedBody['email'], equals(email));
    });

    test('Error throws response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );
      const email = 'emailAddress';
      final response = Response('', 400);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('forgotPassword'),
            ),
          ),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () => client.requestResetPassword(email: email),
        throwsA(
          equals(response),
        ),
      );
    });

    test('404 Error returns OK Response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );
      const email = 'emailAddress';
      final response = Response('', 404);
      when(
        () => httpClient.post(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('forgotPassword'),
            ),
          ),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        (await client.requestResetPassword(email: email)).statusCode,
        equals(200),
      );
    });
  });

  group('Reset Password', () {
    test('Call returns response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );
      final resetUri = Uri.parse('https://reset.this');
      const newPassword = 'newPassword';
      final response = Response('', 200);
      when(
        () => httpClient.put(
          resetUri,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        await client.resetPassword(
          resetUri: resetUri,
          newPassword: newPassword,
        ),
        response,
      );

      final capturedBody = jsonDecode(
        verify(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
          ),
        ).captured.first as String,
      );
      expect(capturedBody['newPassword'], equals(newPassword));
    });

    test('Error throws response', () async {
      final httpClient = MockHttpClient();
      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      final client = ApptiveGridUserManagementClient(
        group: 'group',
        clientId: 'clientId',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      final resetUri = Uri.parse('https://reset.this');
      const newPassword = 'newPassword';
      final response = Response('', 400);
      when(
        () => httpClient.put(
          resetUri,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      expect(
        () =>
            client.resetPassword(resetUri: resetUri, newPassword: newPassword),
        throwsA(
          equals(response),
        ),
      );
    });
  });

  group('Delete Account', () {
    test('Delete Account successfully', () async {
      const group = 'group';
      final authenticator = MockAuthenticator();
      when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});

      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      when(() => apptiveGridClient.isAuthenticatedWithToken)
          .thenAnswer((_) async => true);
      when(() => apptiveGridClient.defaultHeaders).thenReturn({
        'Authentication': 'Bearer token',
      });
      when(() => apptiveGridClient.authenticator).thenReturn(authenticator);

      final httpClient = MockHttpClient();
      when(() => httpClient.delete(
              Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('', 200));

      final userManagementClient = ApptiveGridUserManagementClient(
        group: group,
        clientId: 'app',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      expect(await userManagementClient.deleteAccount(), true);
      verify(() => httpClient.delete(
          Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
          headers: any(named: 'headers'))).called(1);
    });

    test('Delete Account Throws Error', () async {
      const group = 'group';
      final authenticator = MockAuthenticator();
      when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});

      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      when(() => apptiveGridClient.isAuthenticatedWithToken)
          .thenAnswer((_) async => true);
      when(() => apptiveGridClient.defaultHeaders).thenReturn({
        'Authentication': 'Bearer token',
      });
      when(() => apptiveGridClient.authenticator).thenReturn(authenticator);

      final httpClient = MockHttpClient();
      when(() => httpClient.delete(
              Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => Future.error(Exception('Error')));

      final userManagementClient = ApptiveGridUserManagementClient(
        group: group,
        clientId: 'app',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      expect(() => userManagementClient.deleteAccount(), throwsException);
    });

    test('Delete Account Throws Response if StatusCode >= 400', () async {
      const group = 'group';
      final authenticator = MockAuthenticator();
      when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});

      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      when(() => apptiveGridClient.isAuthenticatedWithToken)
          .thenAnswer((_) async => true);
      when(() => apptiveGridClient.defaultHeaders).thenReturn({
        'Authentication': 'Bearer token',
      });
      when(() => apptiveGridClient.authenticator).thenReturn(authenticator);

      final httpClient = MockHttpClient();
      when(() => httpClient.delete(
              Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('body', 400));

      final userManagementClient = ApptiveGridUserManagementClient(
        group: group,
        clientId: 'app',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      expect(
          () => userManagementClient.deleteAccount(), throwsA(isA<Response>()));
    });

    test('Delete Account returns false if not authenticated', () async {
      const group = 'group';

      final authenticator = MockAuthenticator();
      when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});

      final apptiveGridClient = MockApptiveGridClient();
      when(() => apptiveGridClient.options)
          .thenReturn(const ApptiveGridOptions());
      when(() => apptiveGridClient.isAuthenticatedWithToken)
          .thenAnswer((_) async => false);
      when(() => apptiveGridClient.defaultHeaders).thenReturn({
        'Authentication': 'Bearer token',
      });
      when(() => apptiveGridClient.authenticator).thenReturn(authenticator);

      final httpClient = MockHttpClient();
      when(() => httpClient.delete(
              Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => Future.error(Exception('Error')));

      final userManagementClient = ApptiveGridUserManagementClient(
        group: group,
        clientId: 'app',
        apptiveGridClient: apptiveGridClient,
        client: httpClient,
      );

      expect(await userManagementClient.deleteAccount(), false);
      verifyNever(() => httpClient.delete(
          Uri.parse('https://app.apptivegrid.de/auth/$group/users/me'),
          headers: any(named: 'headers')));
    });
  });
}
