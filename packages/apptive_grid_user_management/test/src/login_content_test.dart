import 'dart:async';

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';

void main() {
  group('Login', () {
    testWidgets('Calls login with paramters', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement.withClient(
            confirmAccountPrompt: (_) {},
            clientId: 'client',
            onChangeEnvironment: (_) async {},
            onAccountConfirmed: (_) {},
            group: '',
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
          child: ApptiveGridUserManagement.withClient(
            confirmAccountPrompt: (_) {},
            clientId: 'client',
            onChangeEnvironment: (_) async {},
            onAccountConfirmed: (_) {},
            group: '',
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
  });
}
