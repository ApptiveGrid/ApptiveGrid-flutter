import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

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
      client: client ?? MockApptiveGridClient(),
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
}
