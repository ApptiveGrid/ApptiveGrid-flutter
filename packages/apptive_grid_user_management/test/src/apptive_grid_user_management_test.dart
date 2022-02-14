import 'dart:async';

import 'package:apptive_grid_core/apptive_grid.dart';
import 'package:apptive_grid_user_management/src/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/confirm_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';

import '../infrastructure/mocks.dart';

void main() {
  group('Initial Deeplink', () {
    late UniLinksPlatform initialUniLinks;

    late Completer<String?> initialLink;
    late StreamController<String?> controller;

    late MockUniLinks uniLink;

    setUp(() {
      initialLink = Completer<String?>();
      controller = StreamController.broadcast();
      initialUniLinks = UniLinksPlatform.instance;
      uniLink = MockUniLinks();
      UniLinksPlatform.instance = uniLink;

      when(() => uniLink.linkStream)
          .thenAnswer((_) => controller.stream.asBroadcastStream());
      when(uniLink.getInitialLink).thenAnswer((_) async => initialLink.future);
    });

    tearDown(() {
      UniLinksPlatform.instance = initialUniLinks;
      controller.close();
      reset(uniLink);
    });

    testWidgets('Stream calls callback', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final callbackCompleter = Completer<Widget>();

      final uri =
          Uri.parse('https://app.apptivegrid.de/auth/group/confirm/userId');

      final apptiveGridUserManagement = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement.withClient(
            group: 'group',
            clientId: 'clientId',
            confirmAccountPrompt: (widget) {
              callbackCompleter.complete(widget);
            },
            onAccountConfirmed: (_) {},
            onChangeEnvironment: (_) async {},
            client: client,
          ),
        ),
      );

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pumpAndSettle();

      controller.add(uri.toString());
      final confirmWidget = await callbackCompleter.future;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: SingleChildScrollView(child: confirmWidget)),
        ),
      );
      await tester.pump();

      expect(find.byType(ConfirmAccount), findsOneWidget);
      expect(
        (find.byType(ConfirmAccount).evaluate().first.widget as ConfirmAccount)
            .confirmationUri,
        uri,
      );
    });

    testWidgets('Initial Link calls callback', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final callbackCompleter = Completer<Widget>();

      final uri =
          Uri.parse('https://app.apptivegrid.de/auth/group/confirm/userId');

      final apptiveGridUserManagement = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement.withClient(
            group: 'group',
            clientId: 'clientId',
            confirmAccountPrompt: (widget) {
              callbackCompleter.complete(widget);
            },
            onAccountConfirmed: (_) {},
            client: client,
          ),
        ),
      );

      when(uniLink.getInitialLink).thenAnswer((_) async => uri.toString());

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pumpAndSettle();

      final confirmWidget =
          await callbackCompleter.future.timeout(const Duration(seconds: 4));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: SingleChildScrollView(child: confirmWidget)),
        ),
      );
      await tester.pump();

      expect(find.byType(ConfirmAccount), findsOneWidget);
      expect(
        (find.byType(ConfirmAccount).evaluate().first.widget as ConfirmAccount)
            .confirmationUri,
        uri,
      );
    });

    testWidgets('Initial Link completes setup', (tester) async {
      final client = MockApptiveGridUserManagementClient();

      final callbackCompleter = Completer<Widget>();

      final uri = Uri.parse('https://not.a.valid/confirmationLink');

      late BuildContext context;

      final apptiveGridUserManagement = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement.withClient(
            group: 'group',
            clientId: 'clientId',
            confirmAccountPrompt: (widget) {
              callbackCompleter.complete(widget);
            },
            onAccountConfirmed: (_) {},
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

      when(uniLink.getInitialLink).thenAnswer((_) async => uri.toString());

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pumpAndSettle();

      expect(
        await ApptiveGridUserManagement.maybeOf(context)!.initialSetup(),
        false,
      );
    });
  });

  group('Client', () {
    testWidgets('Creates Client with ApptiveGridClient', (tester) async {
      final apptiveGridClient = MockApptiveGridClient();
      when(apptiveGridClient.sendPendingActions).thenAnswer((_) async {});

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
