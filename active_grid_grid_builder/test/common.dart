import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

class MockActiveGridClient extends Mock implements ActiveGridClient {}

class TestApp extends StatelessWidget {
  const TestApp(
      {Key key,
      this.client,
      this.child,
      this.options = const ActiveGridOptions()})
      : super(key: key);

  final Widget child;

  final ActiveGridClient client;

  final ActiveGridOptions options;

  @override
  Widget build(BuildContext context) {
    return ActiveGrid.withClient(
      client: client,
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
