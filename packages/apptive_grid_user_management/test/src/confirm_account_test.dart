import 'dart:async';

import 'package:apptive_grid_user_management/src/confirm_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('Confirm Account', () {
    testWidgets('Account is confirmed', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final confirmationUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ConfirmAccount(
          confirmAccount: (_) {},
          confirmationUri: confirmationUri,
        ),
      );

      when(
        () => client.confirmAccount(
          confirmationUri: any(named: 'confirmationUri'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => client.confirmAccount(confirmationUri: confirmationUri))
          .called(1);
    });

    testWidgets('Shows Error', (tester) async {
      final client = MockApptiveGridUserManagementClient();
      final confirmationUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ConfirmAccount(
          confirmAccount: (_) {},
          confirmationUri: confirmationUri,
        ),
      );

      when(
            () => client.confirmAccount(
          confirmationUri: any(named: 'confirmationUri'),
        ),
      ).thenAnswer((_) => Future.error(Response('Error Message', 400)));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Error during confirmation. Please try again.'), findsOneWidget);
      expect(find.text('Error Message'), findsOneWidget);
    });
  });

  group('Callback', () {
    testWidgets('Callback with loggedIn Status', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final confirmationUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ConfirmAccount(
          confirmAccount: (isLoggedIn) {
            completer.complete(isLoggedIn);
          },
          confirmationUri: confirmationUri,
        ),
      );

      when(
        () => client.confirmAccount(
          confirmationUri: any(named: 'confirmationUri'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.loginAfterConfirmation()).thenAnswer((_) async => true);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => client.loginAfterConfirmation()).called(1);
      expect(await completer.future, equals(true));
    });

    testWidgets('Callback with not logged in Status', (tester) async {
      final completer = Completer<bool>();
      final client = MockApptiveGridUserManagementClient();
      final confirmationUri = Uri.parse('https://confirm.this');
      final target = StubUserManagement(
        client: client,
        child: ConfirmAccount(
          confirmAccount: (isLoggedIn) {
            completer.complete(isLoggedIn);
          },
          confirmationUri: confirmationUri,
        ),
      );

      when(
        () => client.confirmAccount(
          confirmationUri: any(named: 'confirmationUri'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.loginAfterConfirmation())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(target);
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => client.loginAfterConfirmation()).called(1);
      expect(await completer.future, equals(false));
    });
  });
}
