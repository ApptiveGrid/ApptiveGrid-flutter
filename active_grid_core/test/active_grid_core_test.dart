import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('ActiveGrid Provides necessary Objects', () {
    testWidgets('ActiveGridClient', (tester) async {
      BuildContext context;
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

      expect(
          true, Provider.of<ActiveGridClient>(context, listen: false) != null);
    });
  });

  group('Options are reflected in client', () {
    group('Environment', () {
      testWidgets('Alpha', (tester) async {
        BuildContext context;
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
        expect(ActiveGridEnvironment.alpha, client.environment);
      });

      testWidgets('Beta', (tester) async {
        BuildContext context;
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
        expect(ActiveGridEnvironment.beta, client.environment);
      });

      testWidgets('Production', (tester) async {
        BuildContext context;
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

        final client = Provider.of<ActiveGridClient>(context, listen: false);
        expect(ActiveGridEnvironment.production, client.environment);
      });

      testWidgets('Default is Prod', (tester) async {
        BuildContext context;
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
        expect(ActiveGridEnvironment.production, client.environment);
      });
    });
  });
}
