import 'dart:async';

import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';
import 'package:http/http.dart' as http;

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('Reset Password', () {
    testWidgets('Password is reset', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://reset.this');
      const newPassword = '!1Asdfgh';
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => http.Response('body', 200));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: newPassword,
        confirmation: newPassword,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(
        () => client.resetPassword(
          resetUri: resetUri,
          newPassword: newPassword,
        ),
      ).called(1);
    });

    testWidgets('Shows Error but no details if not response', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) => Future.error(Exception('Error Message')));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: '!1Asdfgh',
        confirmation: '!1Asdfgh',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(
        find.text('Password could not be set. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Error Message'), findsNothing);
    });

    testWidgets('Shows Response Body', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) => Future.error(http.Response('Error Message', 400)));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: '!1Asdfgh',
        confirmation: '!1Asdfgh',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(
        find.text('Password could not be set. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Error Message'), findsOneWidget);
    });
  });

  group('Callback', () {
    testWidgets('Callback with loggedIn Status', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (isLoggedIn) {
            completer.complete(isLoggedIn);
          },
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => http.Response('body', 200));
      when(() => client.loginAfterConfirmation()).thenAnswer((_) async => true);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: '!1Asdfgh',
        confirmation: '!1Asdfgh',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => client.loginAfterConfirmation()).called(1);
      expect(await completer.future, equals(true));
    });

    testWidgets('Callback with not logged in Status', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (isLoggedIn) {
            completer.complete(isLoggedIn);
          },
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => http.Response('body', 200));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: '!1Asdfgh',
        confirmation: '!1Asdfgh',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => client.loginAfterConfirmation()).called(1);
      expect(await completer.future, equals(false));
    });
  });

  group('Loading', () {
    testWidgets('Reset Shows Loading', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://reset.this');
      const newPassword = '!1Asdfgh';
      final responseCompleter = Completer<http.Response>();
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) => responseCompleter.future);
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: newPassword,
        confirmation: newPassword,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      responseCompleter.complete(http.Response('body', 200));
    });

    testWidgets('Confirm shows loading', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final loginAfterCompleter = Completer<bool>();
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (isLoggedIn) {
            completer.complete(isLoggedIn);
          },
          resetUri: resetUri,
        ),
      );

      when(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => http.Response('body', 200));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) => loginAfterCompleter.future);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.inputPasswordAndConfirmation(
        newPassword: '!1Asdfgh',
        confirmation: '!1Asdfgh',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      loginAfterCompleter.complete(true);
    });
  });

  group('Input Validation', () {
    testWidgets('NonMatching Password', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      await tester.pumpWidget(target);

      const password = 'Sup3rStrongPassword!';
      const confirmedPassword = 'sup3rStrongPassword!';
      await tester.inputPasswordAndConfirmation(
        newPassword: password,
        confirmation: confirmedPassword,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Passwords do not match', skipOffstage: false),
        findsOneWidget,
      );

      verifyNever(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      );
    });

    testWidgets('Password not fulfilling rules', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final resetUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ResetPassword(
          onReset: (_) {},
          resetUri: resetUri,
        ),
      );

      await tester.pumpWidget(target);

      const password = 'weakpassword';
      await tester.inputPasswordAndConfirmation(
        newPassword: password,
        confirmation: password,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        (find
                .descendant(
                  of: find.byType(PasswordFormField).first,
                  matching: find.byType(TextField),
                )
                .evaluate()
                .first
                .widget as TextField)
            .decoration
            ?.errorText,
        isNot(isNull),
      );

      verifyNever(
        () => client.resetPassword(
          resetUri: any(named: 'resetUri'),
          newPassword: any(named: 'newPassword'),
        ),
      );
    });
  });
}

extension TesterX on WidgetTester {
  Future<void> inputPasswordAndConfirmation({
    String? newPassword,
    String? confirmation,
  }) async {
    if (newPassword != null) {
      await enterText(find.byType(PasswordFormField).first, newPassword);
      await pump();
    }
    if (confirmation != null) {
      await enterText(find.byType(PasswordFormField).last, confirmation);
      await pump();
    }
  }
}
