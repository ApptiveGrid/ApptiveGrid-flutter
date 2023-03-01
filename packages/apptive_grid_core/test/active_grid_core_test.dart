import 'dart:async';

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
        isNot(isNull),
      );
    });

    testWidgets('ApptiveGridClient', (tester) async {
      late BuildContext context;
      const options = ApptiveGridOptions();
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

      expect(
        ApptiveGrid.getOptions(context),
        equals(options),
      );
    });
  });

  group('Options', () {
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
        expect(
          ApptiveGridEnvironment.alpha,
          equals(client.options.environment),
        );
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
        expect(ApptiveGridEnvironment.beta, equals(client.options.environment));
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
        expect(
          ApptiveGridEnvironment.production,
          equals(client.options.environment),
        );
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
        expect(
          ApptiveGridEnvironment.production,
          equals(client.options.environment),
        );
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
        expect(client.options.authenticationOptions, equals(authentication));
      });
    });

    testWidgets('Update Options', (tester) async {
      late BuildContext context;
      final key = GlobalKey<_UpdateOptionsWidgetState>();
      final target = _UpdateOptionsWidget(
        key: key,
        initalEnvironment: ApptiveGridEnvironment.alpha,
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
        ApptiveGrid.getOptions(context).environment,
        equals(ApptiveGridEnvironment.alpha),
      );

      key.currentState!.environment = ApptiveGridEnvironment.beta;
      await tester.pumpAndSettle();
      expect(
        ApptiveGrid.getOptions(context).environment,
        equals(ApptiveGridEnvironment.beta),
      );
    });
  });

  group('Mock Client', () {
    testWidgets('withClient Uses Provided Client', (tester) async {
      late BuildContext context;
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async => []);
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
      expect(providedClient, equals(client));
    });
  });

  group('FormWidgetConfigurations', () {
    testWidgets('Options contain FormWidgetConfigs', (tester) async {
      const config = _StubFormWidgetConfiguration();

      const options = ApptiveGridOptions(
        formWidgetConfigurations: [config],
      );
      late final BuildContext context;
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

      expect(
        ApptiveGrid.getOptions(context)
            .formWidgetConfigurations
            .firstWhere((element) => element is _StubFormWidgetConfiguration),
        equals(config),
      );
    });
  });

  group('Cached Actions', () {
    testWidgets('Default Cache sends pending Actions', (tester) async {
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async => []);
      final cache = ActionCache();
      final options = ApptiveGridOptions(
        cache: cache,
      );
      when(() => client.options).thenReturn(options);
      final target = ApptiveGrid.withClient(
        client: client,
        options: options,
        child: Container(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      verify(() => client.sendPendingActions()).called(1);
    });

    testWidgets('Cache sends pending Actions', (tester) async {
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async => []);
      final cache = ActionCache(true);
      final options = ApptiveGridOptions(
        cache: cache,
      );
      when(() => client.options).thenReturn(options);
      final target = ApptiveGrid.withClient(
        client: client,
        options: options,
        child: Container(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      verify(() => client.sendPendingActions()).called(1);
    });

    testWidgets('Cache without AutoSend does not send Actions', (tester) async {
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async => []);
      final cache = ActionCache(false);
      final options = ApptiveGridOptions(
        cache: cache,
      );
      when(() => client.options).thenReturn(options);
      final target = ApptiveGrid.withClient(
        client: client,
        options: options,
        child: Container(),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      verifyNever(() => client.sendPendingActions());
    });
  });
}

class ActionCache extends ApptiveGridCache {
  ActionCache([this.send]);

  final bool? send;

  @override
  bool get shouldAutomaticallySendPendingActions =>
      send ?? super.shouldAutomaticallySendPendingActions;

  @override
  FutureOr<void> addPendingActionItem(ActionItem actionItem) {}

  @override
  FutureOr<List<ActionItem>> getPendingActionItems() => [];

  @override
  FutureOr<void> removePendingActionItem(ActionItem actionItem) {}
}

class _StubFormWidgetConfiguration extends FormWidgetConfiguration {
  const _StubFormWidgetConfiguration() : super();
}

class _UpdateOptionsWidget extends StatefulWidget {
  const _UpdateOptionsWidget({
    super.key,
    required this.initalEnvironment,
    required this.child,
  });

  final ApptiveGridEnvironment initalEnvironment;
  final Widget child;

  @override
  State<_UpdateOptionsWidget> createState() => _UpdateOptionsWidgetState();
}

class _UpdateOptionsWidgetState extends State<_UpdateOptionsWidget> {
  late ApptiveGridEnvironment _environment;

  @override
  void initState() {
    super.initState();
    _environment = widget.initalEnvironment;
  }

  set environment(ApptiveGridEnvironment environment) {
    setState(() {
      _environment = environment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGrid(
      options: ApptiveGridOptions(environment: _environment),
      child: widget.child,
    );
  }
}
