import 'dart:async';

import 'package:apptive_grid_user_management/src/apptive_grid_user_management_content.dart';
import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:apptive_grid_user_management/src/register_content.dart';
import 'package:apptive_grid_user_management/src/request_reset_password_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  group('Initial Content', () {
    testWidgets('Default is Register', (tester) async {
      const target = StubUserManagement(
        child: ApptiveGridUserManagementContent(),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.byType(RegisterContent), findsOneWidget);
    });

    testWidgets('Login', (tester) async {
      const target = StubUserManagement(
        child: ApptiveGridUserManagementContent(
          initialContentType: ContentType.login,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.byType(LoginContent), findsOneWidget);
    });

    testWidgets('Register', (tester) async {
      const target = StubUserManagement(
        child: ApptiveGridUserManagementContent(
          initialContentType: ContentType.register,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      expect(find.byType(RegisterContent), findsOneWidget);
    });
  });

  group('Switch Content', () {
    testWidgets('Register to Login', (tester) async {
      const target = StubUserManagement(
        child: ApptiveGridUserManagementContent(),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.byType(LoginContent), findsOneWidget);
    });

    testWidgets('Login to Register', (tester) async {
      const target = StubUserManagement(
        child: ApptiveGridUserManagementContent(
          initialContentType: ContentType.login,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.byType(RegisterContent), findsOneWidget);
    });
  });

  group('Login Callback', () {
    testWidgets('Login Callback invoked', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final target = StubUserManagement(
        client: client,
        child: ApptiveGridUserManagementContent(
          initialContentType: ContentType.login,
          onLogin: () {
            completer.complete(true);
          },
        ),
      );

      when(
        () => client.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Response('body', 200));

      await tester.pumpWidget(target);

      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';
      await tester.enterText(
        find.ancestor(
          of: find.text('Email Address'),
          matching: find.byType(TextFormField),
        ),
        email,
      );
      await tester.pump();
      await tester.enterText(
        find.ancestor(
          of: find.text('Password'),
          matching: find.byType(TextFormField),
        ),
        password,
      );
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(await completer.future, equals(true));
    });
  });

  group('Request Reset Password Callback', () {
    testWidgets('Callback Passed Through', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      const email = 'ResetEmail';

      final callbackCompleter = Completer<
          MapEntry<GlobalKey<RequestResetPasswordContentState>, Widget>>();

      final target = StubUserManagement(
        client: client,
        child: ApptiveGridUserManagementContent(
          initialContentType: ContentType.login,
          requestResetPassword: (content, key) {
            callbackCompleter.complete(MapEntry(key, content));
          },
        ),
      );

      when(
        () => client.requestResetPassword(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => Response('body', 200));

      await tester.pumpWidget(target);
      await tester.tap(find.text('Forgot password?'));

      final callbackResult = await callbackCompleter.future;
      await tester.pumpWidget(
        StubUserManagement(
          client: client,
          child: Scaffold(
            body: Column(
              children: [
                callbackResult.value,
                ElevatedButton(
                  onPressed: () {
                    callbackResult.key.currentState?.requestResetPassword();
                  },
                  child: const Text('Testing Callback'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(RequestResetPasswordContent), findsOneWidget);

      await tester.enterText(
        find.byType(EmailFormField),
        email,
      );
      await tester.pump();

      await tester.tap(find.text('Testing Callback'));
      await tester.pumpAndSettle();

      verify(() => client.requestResetPassword(email: email)).called(1);
    });
  });
}
