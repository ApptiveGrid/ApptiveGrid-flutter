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
        redirectSchema: 'customRedirect',
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

      final response = Response('{"key":"value"}', 200);
      when(
        () => httpClient.get(
          any(
            that: predicate<Uri>(
              (uri) => uri.pathSegments.contains('login'),
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
}
