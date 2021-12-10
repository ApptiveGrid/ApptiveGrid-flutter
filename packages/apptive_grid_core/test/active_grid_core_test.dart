import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'mocks.dart';

void main() {
  group('ApptiveGrid Provides necessary Objects', () {
    testWidgets('ApptiveGridClient', (tester) async {
      late BuildContext context;
      final target = ApptiveGrid(
        child: Builder(
          builder: (buildContext) {
            context = buildContext;
            return Container();
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        ApptiveGrid.getClient(context, listen: false),
        isNot(null),
      );
    });
  });

  group('Options are reflected in client', () {
    group('Environment', () {
      testWidgets('Alpha', (tester) async {
        late BuildContext context;
        const options = ApptiveGridOptions(
          environment: ApptiveGridEnvironment.alpha,
        );
        final target = ApptiveGrid(
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

        final client = Provider.of<ApptiveGridClient>(context, listen: false);
        expect(ApptiveGridEnvironment.alpha, client.options.environment);
      });

      testWidgets('Beta', (tester) async {
        late BuildContext context;
        const options = ApptiveGridOptions(
          environment: ApptiveGridEnvironment.beta,
        );
        final target = ApptiveGrid(
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

        final client = Provider.of<ApptiveGridClient>(context, listen: false);
        expect(ApptiveGridEnvironment.beta, client.options.environment);
      });

      testWidgets('Production', (tester) async {
        late BuildContext context;
        const options = ApptiveGridOptions(
          environment: ApptiveGridEnvironment.production,
        );
        final target = ApptiveGrid(
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

        final client = ApptiveGrid.getClient(context, listen: false);
        expect(ApptiveGridEnvironment.production, client.options.environment);
      });

      testWidgets('Default is Prod', (tester) async {
        late BuildContext context;
        final target = ApptiveGrid(
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return Container();
            },
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        final client = Provider.of<ApptiveGridClient>(context, listen: false);
        expect(ApptiveGridEnvironment.production, client.options.environment);
      });

      testWidgets('Authentication', (tester) async {
        late BuildContext context;
        const authentication =
            ApptiveGridAuthenticationOptions(autoAuthenticate: true);
        final target = ApptiveGrid(
          options: const ApptiveGridOptions(
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

        final client = Provider.of<ApptiveGridClient>(context, listen: false);
        expect(client.options.authenticationOptions, authentication);
      });
    });
  });

  group('Mock Client', () {
    testWidgets('withClient Uses Provided Client', (tester) async {
      late BuildContext context;
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async {});
      final target = ApptiveGrid.withClient(
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
          Provider.of<ApptiveGridClient>(context, listen: false);
      expect(providedClient, client);
    });
  });
}
