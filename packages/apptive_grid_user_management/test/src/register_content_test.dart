import 'dart:async';

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/register_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  group('Register', () {
    testWidgets('Calls Register with parameters', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const SingleChildScrollView(child: RegisterContent()),
          ),
        ),
      );

      when(
        () => client.register(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.group).thenReturn('Test Group');

      await tester.pumpWidget(target);

      const firstName = 'Amelie';
      const lastName = 'Testing';
      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('First Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('First Name'),
        firstName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Last Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Last Name'),
        lastName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Email Address'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Email Address'),
        email,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.textFormFieldWithLabel('Password'), password);
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Confirm Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Confirm Password'),
        password,
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(
        () => client.register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        ),
      ).called(1);
    });

    testWidgets('Keyboard actions', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      const firstName = 'Amelie';
      const lastName = 'Testing';
      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';

      when(
        () => client.register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.group).thenReturn('Test Group');

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const SingleChildScrollView(child: RegisterContent()),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('First Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textFormFieldWithLabel('First Name'));
      await tester.pumpAndSettle();

      tester.testTextInput.enterText(firstName);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText(lastName);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText(email);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText(password);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText(password);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(
        () => client.register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        ),
      ).called(1);
    });

    group('Validate Inputs', () {
      testWidgets('Empty Values', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: const SingleChildScrollView(child: RegisterContent()),
            ),
          ),
        );
        await tester.pumpWidget(target);
        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text('First Name may not be empty', skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.text('Last Name may not be empty', skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.text('Email may not be empty', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('Invalid Email Address', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: const SingleChildScrollView(child: RegisterContent()),
            ),
          ),
        );
        await tester.pumpWidget(target);

        const invalidEmail = 'almost@nmail';
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Email Address'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Email Address'),
          invalidEmail,
        );
        await tester.pump();

        await tester.pumpWidget(target);
        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text('Not a valid email address', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('NonMatching Password', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: const SingleChildScrollView(child: RegisterContent()),
            ),
          ),
        );

        await tester.pumpWidget(target);

        const password = 'Sup3rStrongPassword!';
        const confirmedPassword = 'sup3rStrongPassword!';
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Password'),
          password,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Confirm Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Confirm Password'),
          confirmedPassword,
        );
        await tester.pump();

        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text('Passwords do not match', skipOffstage: false),
          findsOneWidget,
        );
      });

      group('PasswordRequirements', () {
        testWidgets('Enforced Rule checks against all options', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final target = MaterialApp(
            home: Material(
              child: StubUserManagement(
                passwordRequirement: PasswordRequirement.enforced,
                client: client,
                child: const SingleChildScrollView(child: RegisterContent()),
              ),
            ),
          );

          await tester.pumpWidget(target);

          const password = 'MissingSp3cialCharacter';
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Password'),
            password,
          );
          await tester.pump();
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Confirm Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Confirm Password'),
            password,
          );
          await tester.pump();

          await tester.scrollUntilVisible(
            find.byType(ElevatedButton),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

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
        });

        testWidgets('Enforced Rule verifies if all rules met', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final target = MaterialApp(
            home: Material(
              child: StubUserManagement(
                passwordRequirement: PasswordRequirement.enforced,
                client: client,
                child: const SingleChildScrollView(child: RegisterContent()),
              ),
            ),
          );

          await tester.pumpWidget(target);

          const password = 'W!thSp3cialCharacter';
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Password'),
            password,
          );
          await tester.pump();
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Confirm Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Confirm Password'),
            password,
          );
          await tester.pump();

          await tester.scrollUntilVisible(
            find.byType(ElevatedButton),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

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
            isNull,
          );
        });

        testWidgets('SafetyHint Rule checks against length', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final target = MaterialApp(
            home: Material(
              child: StubUserManagement(
                passwordRequirement: PasswordRequirement.safetyHint,
                client: client,
                child: const SingleChildScrollView(child: RegisterContent()),
              ),
            ),
          );

          await tester.pumpWidget(target);

          const password = '2Short';
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Password'),
            password,
          );
          await tester.pump();
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Confirm Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Confirm Password'),
            password,
          );
          await tester.pump();

          await tester.scrollUntilVisible(
            find.byType(ElevatedButton),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

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
        });

        testWidgets('SafetyHint Rule only needs length', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final target = MaterialApp(
            home: Material(
              child: StubUserManagement(
                passwordRequirement: PasswordRequirement.safetyHint,
                client: client,
                child: const SingleChildScrollView(child: RegisterContent()),
              ),
            ),
          );

          await tester.pumpWidget(target);

          const password = 'longenough';
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Password'),
            password,
          );
          await tester.pump();
          await tester.scrollUntilVisible(
            find.textFormFieldWithLabel('Confirm Password'),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.enterText(
            find.textFormFieldWithLabel('Confirm Password'),
            password,
          );
          await tester.pump();

          await tester.scrollUntilVisible(
            find.byType(ElevatedButton),
            50,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

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
            isNull,
          );
        });
      });
    });

    group('Register User', () {
      testWidgets('New User', (tester) async {
        final client = MockApptiveGridUserManagementClient();

        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: const SingleChildScrollView(child: RegisterContent()),
            ),
          ),
        );

        when(
          () => client.register(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Response('body', 201));
        when(() => client.group).thenReturn('Test Group');

        await tester.pumpWidget(target);

        const firstName = 'Amelie';
        const lastName = 'Testing';
        const email = 'email@2denker.de';
        const password = 'Sup3rStrongPassword!';
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('First Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('First Name'),
          firstName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Last Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Last Name'),
          lastName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Email Address'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Email Address'),
          email,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Password'),
          password,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Confirm Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Confirm Password'),
          password,
        );
        await tester.pump();

        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(
          find.text(
            'All Set!\nCheck your Email for a link to verify your account.',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('Shows Error', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const SingleChildScrollView(child: RegisterContent()),
          ),
        ),
      );

      when(
        () => client.register(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.error(Response('Error Message', 400)));

      await tester.pumpWidget(target);

      const firstName = 'Amelie';
      const lastName = 'Testing';
      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('First Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('First Name'),
        firstName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Last Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Last Name'),
        lastName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Email Address'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Email Address'),
        email,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.textFormFieldWithLabel('Password'), password);
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Confirm Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Confirm Password'),
        password,
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(
        find.text('Error during registration. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets('Existing User', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      const group = 'Test Group';

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const SingleChildScrollView(child: RegisterContent()),
          ),
        ),
      );

      when(
        () => client.register(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.group).thenReturn(group);

      await tester.pumpWidget(target);

      const firstName = 'Amelie';
      const lastName = 'Testing';
      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('First Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('First Name'),
        firstName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Last Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Last Name'),
        lastName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Email Address'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Email Address'),
        email,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.textFormFieldWithLabel('Password'), password);
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Confirm Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Confirm Password'),
        password,
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(
        find.text(
          'There already exists an account for $email.\nWe have send you a link to confirm that you want to activate the account for "$group".\nYour password has not been changed.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Go back', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      const group = 'Test Group';

      final target = MaterialApp(
        home: Material(
          child: StubUserManagement(
            client: client,
            child: const SingleChildScrollView(child: RegisterContent()),
          ),
        ),
      );

      when(
        () => client.register(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Response('body', 200));
      when(() => client.group).thenReturn(group);

      await tester.pumpWidget(target);

      const firstName = 'Amelie';
      const lastName = 'Testing';
      const email = 'email@2denker.de';
      const password = 'Sup3rStrongPassword!';
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('First Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('First Name'),
        firstName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Last Name'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Last Name'),
        lastName,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Email Address'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Email Address'),
        email,
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.textFormFieldWithLabel('Password'), password);
      await tester.pump();
      await tester.scrollUntilVisible(
        find.textFormFieldWithLabel('Confirm Password'),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(
        find.textFormFieldWithLabel('Confirm Password'),
        password,
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        50,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      await tester.tap(find.text('Back'));
      await tester.pump();

      expect(
        find.ancestor(
          of: find.text('Register'),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.runtimeType == TextFormField &&
              (widget as TextFormField).controller!.text.isNotEmpty,
        ),
        findsNothing,
      );
    });

    group('Try to login a already registered user', () {
      testWidgets('Login Success calls login once and calls callback',
          (tester) async {
        final client = MockApptiveGridUserManagementClient();

        const group = 'Test Group';

        final loginCompleter = Completer<bool>();
        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: SingleChildScrollView(
                child: RegisterContent(
                  onLogin: () => loginCompleter.complete(true),
                ),
              ),
            ),
          ),
        );

        when(
          () => client.register(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Future.error(Response('body', 409)));
        when(() => client.group).thenReturn(group);
        when(
          () => client.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Response('body', 200));

        await tester.pumpWidget(target);

        const firstName = 'Amelie';
        const lastName = 'Testing';
        const email = 'email@2denker.de';
        const password = 'Sup3rStrongPassword!';
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('First Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('First Name'),
          firstName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Last Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Last Name'),
          lastName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Email Address'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Email Address'),
          email,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Password'),
          password,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Confirm Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Confirm Password'),
          password,
        );
        await tester.pump();

        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.pump();
        await tester.pump();

        verify(() => client.login(email: email, password: password)).called(1);
        expect(await loginCompleter.future, equals(true));
      });

      testWidgets(
          'Login failed. Only calls login once. Calls register twice for error',
          (tester) async {
        final client = MockApptiveGridUserManagementClient();

        const group = 'Test Group';

        final target = MaterialApp(
          home: Material(
            child: StubUserManagement(
              client: client,
              child: SingleChildScrollView(
                child: RegisterContent(
                  onLogin: () {},
                ),
              ),
            ),
          ),
        );

        when(
          () => client.register(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => Future.error(Response('Register Error', 409)),
        );
        when(() => client.group).thenReturn(group);
        when(
          () => client.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Future.error(Response('body', 400)));

        await tester.pumpWidget(target);

        const firstName = 'Amelie';
        const lastName = 'Testing';
        const email = 'email@2denker.de';
        const password = 'Sup3rStrongPassword!';
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('First Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('First Name'),
          firstName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Last Name'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Last Name'),
          lastName,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Email Address'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Email Address'),
          email,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Password'),
          password,
        );
        await tester.pump();
        await tester.scrollUntilVisible(
          find.textFormFieldWithLabel('Confirm Password'),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.textFormFieldWithLabel('Confirm Password'),
          password,
        );
        await tester.pump();

        await tester.scrollUntilVisible(
          find.byType(ElevatedButton),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        verify(() => client.login(email: email, password: password)).called(1);
        verify(
          () => client.register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
          ),
        ).called(2);
        expect(find.text('Register Error'), findsOneWidget);
      });
    });
  });
}

extension _FinderX on CommonFinders {
  Finder textFormFieldWithLabel(String label) {
    return ancestor(of: find.text(label), matching: find.byType(TextFormField));
  }
}
