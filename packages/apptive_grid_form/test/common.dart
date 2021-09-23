import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/cache/apptive_grid_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockHttpClient extends Mock implements http.Client {}

class MockApptiveGridCache extends Mock implements ApptiveGridCache {}

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    this.client,
    this.child,
    this.options = const ApptiveGridOptions(),
  }) : super(key: key);

  final Widget? child;

  final ApptiveGridClient? client;

  final ApptiveGridOptions options;

  @override
  Widget build(BuildContext context) {
    return ApptiveGrid.withClient(
      client: client ?? _fallbackClient,
      options: options,
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            return Material(child: child);
          },
        ),
      ),
    );
  }

  ApptiveGridClient get _fallbackClient {
    final client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((invocation) async {});

    return client;
  }
}
