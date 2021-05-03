import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mocks.dart';

void main() {

  test('Tests seem to be really quick. This should fail', () {
    expect(true, false);
  });

  group('ActiveGrid Provides necessary Objects', () {
    testWidgets('ActiveGridClient', (tester) async {
      late BuildContext context;
      final target = ActiveGrid(
        child: Builder(
          builder: (buildContext) {
            context = buildContext;
            return Container();
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(true,
          ActiveGrid.getClient(context, listen: false) is ActiveGridClient);
    });
  });

  group('Options are reflected in client', () {
    group('Environment', () {
      testWidgets('Alpha', (tester) async {
        late BuildContext context;
        final options = ActiveGridOptions(
          environment: ActiveGridEnvironment.alpha,
        );
        final target = ActiveGrid(
          options: options,
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = Provider.of<ActiveGridClient>(context, listen: false);
        expect(ActiveGridEnvironment.alpha, client.options.environment);
      });

      testWidgets('Beta', (tester) async {
        late BuildContext context;
        final options = ActiveGridOptions(
          environment: ActiveGridEnvironment.beta,
        );
        final target = ActiveGrid(
          options: options,
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = Provider.of<ActiveGridClient>(context, listen: false);
        expect(ActiveGridEnvironment.beta, client.options.environment);
      });

      testWidgets('Production', (tester) async {
        late BuildContext context;
        final options = ActiveGridOptions(
          environment: ActiveGridEnvironment.production,
        );
        final target = ActiveGrid(
          options: options,
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = ActiveGrid.getClient(context, listen: false);
        expect(ActiveGridEnvironment.production, client.options.environment);
      });

      testWidgets('Default is Prod', (tester) async {
        late BuildContext context;
        final target = ActiveGrid(
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = Provider.of<ActiveGridClient>(context, listen: false);
        expect(ActiveGridEnvironment.production, client.options.environment);
      });

      testWidgets('Authentication', (tester) async {
        late BuildContext context;
        final authentication =
            ActiveGridAuthenticationOptions(autoAuthenticate: true);
        final target = ActiveGrid(
          options: ActiveGridOptions(
            authenticationOptions: authentication,
          ),
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = Provider.of<ActiveGridClient>(context, listen: false);
        expect(client.options.authenticationOptions, authentication);
      });
    });
  });

  group('Mock Client', () {
    testWidgets('withClient Uses Provided Client', (tester) async {
      late BuildContext context;
      final client = MockActiveGridClient();
      final target = ActiveGrid.withClient(
        client: client,
        child: Builder(
          builder: (buildContext) {
            context = buildContext;
            return Container();
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final providedClient =
          Provider.of<ActiveGridClient>(context, listen: false);
      expect(providedClient, client);
    });
  });
}
