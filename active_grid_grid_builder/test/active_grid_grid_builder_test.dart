import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:active_grid_grid_builder/active_grid_grid_builder.dart';
import 'package:mockito/mockito.dart';

import 'common.dart';

void main() {
  final user = 'user';
  final space = 'space';
  final gridId = 'grid';

  testWidgets('Builder is called with data', (tester) async {
    final client = MockActiveGridClient();
    final target = TestApp(
      client: client,
      child: ActiveGridGridBuilder(
        user: user,
        space: space,
        grid: gridId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(client.loadGrid(user: user, space: space, grid: gridId))
        .thenAnswer((_) async => Grid(title, null, [], []));

    await tester.pumpWidget(target);
    await tester.pump();

    expect(find.text(title), findsOneWidget);
  });

  testWidgets('Initial Data is displayed', (tester) async {
    final client = MockActiveGridClient();
    final target = TestApp(
      client: client,
      child: ActiveGridGridBuilder(
        user: user,
        space: space,
        grid: gridId,
        initialData: Grid('Initial Title', null, [], []),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(client.loadGrid(user: user, space: space, grid: gridId))
        .thenAnswer((_) async => Grid(title, null, [], []));

    await tester.pumpWidget(target);

    expect(find.text('Initial Title'), findsOneWidget);
    await tester.pump();

    expect(find.text(title), findsOneWidget);
  });

  testWidgets('Builder is called with error', (tester) async {
    final client = MockActiveGridClient();
    final target = TestApp(
      client: client,
      child: ActiveGridGridBuilder(
        user: user,
        space: space,
        grid: gridId,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    when(client.loadGrid(user: user, space: space, grid: gridId))
        .thenAnswer((_) => Future.error(''));

    await tester.pumpWidget(target);
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Reload calls client', (tester) async {
    final client = MockActiveGridClient();
    final key = GlobalKey<ActiveGridGridBuilderState>();
    final target = TestApp(
      client: client,
      child: ActiveGridGridBuilder(
        key: key,
        user: user,
        space: space,
        grid: gridId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(client.loadGrid(user: user, space: space, grid: gridId))
        .thenAnswer((_) async => Grid(title, null, [], []));

    await tester.pumpWidget(target);
    await tester.pump();

    await key.currentState.reload();

    verify(client.loadGrid(user: user, space: space, grid: gridId)).called(2);
  });
}
