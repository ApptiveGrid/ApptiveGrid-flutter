import 'dart:async';

import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/request_reset_password_content.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  late ApptiveGridUserManagementClient client;
  late Widget target;

  setUp(() {
    client = MockApptiveGridUserManagementClient();
    final key = GlobalKey<RequestResetPasswordContentState>();
    target = StubUserManagement(
      client: client,
      child: ListView(
        children: [
          RequestResetPasswordContent(key: key),
          ElevatedButton(
            onPressed: () {
              key.currentState?.requestResetPassword();
            },
            child: const Text('Request Reset'),
          ),
        ],
      ),
    );
  });

  group('Input Validation', () {
    testWidgets('Empty Email shows Error', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email may not be empty'), findsOneWidget);
    });

    testWidgets('Non Empty Email performs call with input', (tester) async {
      const input = 'input';
      when(() => client.requestResetPassword(email: input))
          .thenAnswer((_) async => http.Response('', 200));
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EmailFormField), input);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email may not be empty'), findsNothing);
      verify(() => client.requestResetPassword(email: input)).called(1);
    });
  });

  group('Loading', () {
    testWidgets('Show loading', (tester) async {
      const input = 'input';
      final completer = Completer<http.Response>();
      when(() => client.requestResetPassword(email: input))
          .thenAnswer((_) => completer.future);
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EmailFormField), input);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(http.Response('', 200));
      await tester.pumpAndSettle();
    });
  });

  group('Success', () {
    testWidgets('Show success message with input', (tester) async {
      const input = 'input';
      when(() => client.requestResetPassword(email: input))
          .thenAnswer((_) async => http.Response('', 200));
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EmailFormField), input);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('We have send a link to reset your password to $input.'),
        findsOneWidget,
      );
    });
  });

  group('Error', () {
    testWidgets('Error is shown', (tester) async {
      const input = 'input';
      when(() => client.requestResetPassword(email: input))
          .thenAnswer((_) => Future.error(Exception('Error')));
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EmailFormField), input);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('An error occurred. Please try again.'), findsOneWidget);
    });

    testWidgets('Error is Response shows body', (tester) async {
      const input = 'input';
      when(() => client.requestResetPassword(email: input))
          .thenAnswer((_) => Future.error(http.Response('Response Body', 400)));
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EmailFormField), input);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('An error occurred. Please try again.'), findsOneWidget);
      expect(find.text('Response Body'), findsOneWidget);
    });
  });
}
