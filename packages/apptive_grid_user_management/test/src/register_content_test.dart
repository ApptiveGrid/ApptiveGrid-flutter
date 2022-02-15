import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/register_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';

void main() {
  group('Register', () {
    testWidgets('Calls Register with parameters', (tester) async {
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

    group('Validate Inputs', () {
      testWidgets('Empty Values', (tester) async {
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
            child: ApptiveGridUserManagement.withClient(
              confirmAccountPrompt: (_) {},
              clientId: 'client',
              onChangeEnvironment: (_) async {},
              onAccountConfirmed: (_) {},
              group: '',
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
            child: ApptiveGridUserManagement.withClient(
              confirmAccountPrompt: (_) {},
              clientId: 'client',
              onChangeEnvironment: (_) async {},
              onAccountConfirmed: (_) {},
              group: '',
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
    });

    testWidgets('Shows Error', (tester) async {
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

      expect(find.text('Error during registration. Please try again.'), findsOneWidget);
      expect(find.text('Error Message'), findsOneWidget);
    });
  });
}

extension _FinderX on CommonFinders {
  Finder textFormFieldWithLabel(String label) {
    return ancestor(of: find.text(label), matching: find.byType(TextFormField));
  }
}
