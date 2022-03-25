import 'dart:async';

import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:apptive_grid_user_management/src/request_reset_password_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  group('Login', () {
    testWidgets('Calls login with parameters', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const LoginContent(),
          ),
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

      verify(() => client.login(email: email, password: password)).called(1);
    });

    testWidgets('Callback invoked after login', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: LoginContent(
              onLogin: () {
                completer.complete(true);
              },
            ),
          ),
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

    testWidgets('Shows Error', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const LoginContent(),
          ),
        ),
      );

      when(
        () => client.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.error(Response('Error Message', 400)));

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

      expect(
        find.text('Error during login. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Error Message'), findsOneWidget);
    });
  });

  group('Forgot Password', () {
    group('Default Dialog', () {
      testWidgets('Success Route', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        const email = 'ResetEmail';

        final target = StubUserManagement(
          client: client,
          child: const LoginContent(),
        );

        when(
          () => client.requestResetPassword(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Response('body', 200));

        await tester.pumpWidget(target);
        await tester.tap(find.text('Forgot password?'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.descendant(
            of: find.byType(RequestResetPasswordContent),
            matching: find.byType(EmailFormField),
          ),
          email,
        );
        await tester.pump();

        await tester.tap(find.text('Reset'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(TextButton),
            matching: find.text('OK'),
          ),
          findsOneWidget,
        );
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(find.byType(RequestResetPasswordContent), findsNothing);
        verify(() => client.requestResetPassword(email: email)).called(1);
      });

      testWidgets('Cancel Dialog', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        final target = StubUserManagement(
          client: client,
          child: const LoginContent(),
        );
        await tester.pumpWidget(target);
        await tester.tap(find.text('Forgot password?'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(find.byType(RequestResetPasswordContent), findsNothing);
        verifyNever(
          () => client.requestResetPassword(email: any(named: 'email')),
        );
      });
    });

    group('Provided Callback', () {
      testWidgets('Callback Invoked with ResetPasswordContent', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        const email = 'ResetEmail';

        final callbackCompleter = Completer<
            MapEntry<GlobalKey<RequestResetPasswordContentState>, Widget>>();

        final target = StubUserManagement(
          client: client,
          child: LoginContent(
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
                  )
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
  });
}
