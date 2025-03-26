import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_user_management/src/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/confirm_account.dart';
import 'package:apptive_grid_user_management/src/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_links/app_links.dart';

import '../infrastructure/mocks.dart';

void main() {
  group('Deeplinks', () {
    late AppLinks mockAppLinks;
    late StreamController<Uri> controller;

    setUpAll(() {
      controller = StreamController.broadcast();
      mockAppLinks = MockAppLinks();

      when(() => mockAppLinks.uriLinkStream)
          .thenAnswer((_) => controller.stream);
      when(mockAppLinks.getInitialLink).thenAnswer((_) async => null);
    });

    tearDownAll(() {
      controller.close();
      reset(mockAppLinks);
    });

    group(
      'ResetPassword Deeplink',
      () {
        testWidgets('Stream calls callback', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri = Uri.parse(
            'https://app.apptivegrid.de/auth/group/resetPassword/userId/resetToken',
          );

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (_) {},
                onAccountConfirmed: (_) {},
                onChangeEnvironment: (_) async {},
                resetPasswordPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pump();

          controller.add(uri);

          final confirmWidget = await callbackCompleter.future;

          await tester.pumpWidget(
            MaterialApp(
              home:
                  Material(child: SingleChildScrollView(child: confirmWidget)),
            ),
          );

          await tester.pump();

          expect(find.byType(ResetPassword), findsOneWidget);
          expect(
            (find.byType(ResetPassword).evaluate().first.widget
                    as ResetPassword)
                .resetUri,
            equals(uri),
          );
        });

        testWidgets('Initial Link calls callback', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri = Uri.parse(
            'https://app.apptivegrid.de/auth/group/resetPassword/userId/resetToken',
          );

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (_) {},
                onAccountConfirmed: (_) {},
                resetPasswordPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          final confirmWidget = await callbackCompleter.future
              .timeout(const Duration(seconds: 4));

          await tester.pumpWidget(
            MaterialApp(
              home:
                  Material(child: SingleChildScrollView(child: confirmWidget)),
            ),
          );
          await tester.pump();

          expect(find.byType(ResetPassword), findsOneWidget);
          expect(
            (find.byType(ResetPassword).evaluate().first.widget
                    as ResetPassword)
                .resetUri,
            equals(uri),
          );
        });

        testWidgets('Unknown environment uses production', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<ApptiveGridEnvironment>();

          final uri = Uri.parse(
            'https://somethingweird.apptivegrid.de/auth/group/resetPassword/userId/resetToken',
          );

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (_) {},
                onAccountConfirmed: (_) {},
                onChangeEnvironment: (environment) async {
                  callbackCompleter.complete(environment);
                },
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          final environment = await callbackCompleter.future
              .timeout(const Duration(seconds: 4));

          expect(environment, equals(ApptiveGridEnvironment.production));
        });

        testWidgets('Initial Link completes setup', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri = Uri.parse('https://not.a.valid/confirmationLink');

          late BuildContext context;

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onAccountConfirmed: (_) {},
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
                child: Builder(
                  builder: (buildContext) {
                    context = buildContext;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          expect(
            (await ApptiveGridUserManagement.maybeOf(context)!.initialSetup())
                .first,
            false,
          );
          expect(
            (await ApptiveGridUserManagement.maybeOf(context)!.initialSetup())
                .last,
            false,
          );
        });
      },
      skip: true,
    );

    group(
      'Confirmation Deeplink',
      () {
        testWidgets('Stream calls callback', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri =
              Uri.parse('https://app.apptivegrid.de/auth/group/confirm/userId');

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onAccountConfirmed: (_) {},
                onChangeEnvironment: (_) async {},
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          controller.add(uri);
          final confirmWidget = await callbackCompleter.future;

          await tester.pumpWidget(
            MaterialApp(
              home:
                  Material(child: SingleChildScrollView(child: confirmWidget)),
            ),
          );
          await tester.pump();

          expect(find.byType(ConfirmAccount), findsOneWidget);
          expect(
            (find.byType(ConfirmAccount).evaluate().first.widget
                    as ConfirmAccount)
                .confirmationUri,
            equals(uri),
          );
        });

        testWidgets('Initial Link calls callback', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri =
              Uri.parse('https://app.apptivegrid.de/auth/group/confirm/userId');

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onAccountConfirmed: (_) {},
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          final confirmWidget = await callbackCompleter.future
              .timeout(const Duration(seconds: 4));

          await tester.pumpWidget(
            MaterialApp(
              home:
                  Material(child: SingleChildScrollView(child: confirmWidget)),
            ),
          );
          await tester.pump();

          expect(find.byType(ConfirmAccount), findsOneWidget);
          expect(
            (find.byType(ConfirmAccount).evaluate().first.widget
                    as ConfirmAccount)
                .confirmationUri,
            equals(uri),
          );
        });

        testWidgets('Unknown environment uses production', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<ApptiveGridEnvironment>();

          final uri = Uri.parse(
            'https://somethingweird.apptivegrid.de/auth/group/confirm/userId',
          );

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (_) {},
                onAccountConfirmed: (_) {},
                onChangeEnvironment: (environment) async {
                  callbackCompleter.complete(environment);
                },
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          final environment = await callbackCompleter.future
              .timeout(const Duration(seconds: 4));

          expect(environment, equals(ApptiveGridEnvironment.production));
        });

        testWidgets('Initial Link completes setup', (tester) async {
          final client = MockApptiveGridUserManagementClient();

          final callbackCompleter = Completer<Widget>();

          final uri = Uri.parse('https://not.a.valid/confirmationLink');

          late BuildContext context;

          final apptiveGridUserManagement = MaterialApp(
            home: Material(
              child: ApptiveGridUserManagement(
                group: 'group',
                clientId: 'clientId',
                confirmAccountPrompt: (widget) {
                  callbackCompleter.complete(widget);
                },
                onAccountConfirmed: (_) {},
                resetPasswordPrompt: (_) {},
                onPasswordReset: (_) async {},
                client: client,
                child: Builder(
                  builder: (buildContext) {
                    context = buildContext;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          when(mockAppLinks.getInitialLink).thenAnswer((_) async => uri);

          await tester.pumpWidget(apptiveGridUserManagement);
          await tester.pumpAndSettle();

          expect(
            (await ApptiveGridUserManagement.maybeOf(context)!.initialSetup())
                .first,
            false,
          );
        });
      },
      skip: true,
    );
  });

  group('Client', () {
    testWidgets('Creates Client with ApptiveGridClient', (tester) async {
      final apptiveGridClient = MockApptiveGridClient();
      when(apptiveGridClient.sendPendingActions).thenAnswer((_) async => []);

      final callbackCompleter = Completer<Widget>();

      late BuildContext context;

      final apptiveGridUserManagement = MaterialApp(
        home: ApptiveGrid.withClient(
          client: apptiveGridClient,
          child: Builder(
            builder: (_) {
              return Material(
                child: ApptiveGridUserManagement(
                  group: 'group',
                  clientId: 'clientId',
                  confirmAccountPrompt: (widget) {
                    callbackCompleter.complete(widget);
                  },
                  onAccountConfirmed: (_) {},
                  resetPasswordPrompt: (_) {},
                  onPasswordReset: (_) async {},
                  child: Builder(
                    builder: (buildContext) {
                      context = buildContext;
                      return const SizedBox();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pumpAndSettle();

      expect(
        ApptiveGridUserManagement.maybeOf(context)!.client!.apptiveGridClient,
        equals(apptiveGridClient),
      );
    });
  });
}
