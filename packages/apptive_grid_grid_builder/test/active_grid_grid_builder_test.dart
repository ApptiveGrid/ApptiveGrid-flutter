import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptive_grid_grid_builder/apptive_grid_grid_builder.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  final user = 'user';
  final space = 'space';
  final gridId = 'grid';

  late ApptiveGridClient client;

  setUp(() {
    client = MockApptiveGridClient();

    when(() => client.sendPendingActions()).thenAnswer((_) async {});
  });

  testWidgets('Builder is called with data', (tester) async {
    final target = TestApp(
      client: client,
      child: ApptiveGridGridBuilder(
        gridUri: GridUri(
          user: user,
          space: space,
          grid: gridId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(() => client.loadGrid(
            gridUri: GridUri(user: user, space: space, grid: gridId)))
        .thenAnswer((_) async => Grid(
              name: title,
              schema: null,
              fields: [],
              rows: [],
            ));

    await tester.pumpWidget(target);
    await tester.pump();

    expect(find.text(title), findsOneWidget);
  });

  testWidgets('Initial Data is displayed', (tester) async {
    final target = TestApp(
      client: client,
      child: ApptiveGridGridBuilder(
        gridUri: GridUri(
          user: user,
          space: space,
          grid: gridId,
        ),
        initialData: Grid(
          name: 'Initial Title',
          schema: null,
          fields: [],
          rows: [],
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(() => client.loadGrid(
            gridUri: GridUri(user: user, space: space, grid: gridId)))
        .thenAnswer((_) async => Grid(
              name: title,
              schema: null,
              fields: [],
              rows: [],
            ));

    await tester.pumpWidget(target);

    expect(find.text('Initial Title'), findsOneWidget);
    await tester.pump();

    expect(find.text(title), findsOneWidget);
  });

  testWidgets('Builder is called with error', (tester) async {
    final target = TestApp(
      client: client,
      child: ApptiveGridGridBuilder(
        gridUri: GridUri(
          user: user,
          space: space,
          grid: gridId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    when(() => client.loadGrid(
            gridUri: GridUri(user: user, space: space, grid: gridId)))
        .thenAnswer((_) => Future.error(''));

    await tester.pumpWidget(target);
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Reload calls client', (tester) async {
    final key = GlobalKey<ApptiveGridGridBuilderState>();
    final target = TestApp(
      client: client,
      child: ApptiveGridGridBuilder(
        key: key,
        gridUri: GridUri(
          user: user,
          space: space,
          grid: gridId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final title = 'Title';
    when(() => client.loadGrid(
            gridUri: GridUri(user: user, space: space, grid: gridId)))
        .thenAnswer((_) async => Grid(
              name: title,
              schema: null,
              fields: [],
              rows: [],
            ));

    await tester.pumpWidget(target);
    await tester.pump();

    await key.currentState!.reload();

    verify(() => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId))).called(2);
  });
}
