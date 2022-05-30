import 'package:apptive_grid_grid_builder/apptive_grid_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  final user = 'user';
  final space = 'space';
  final gridId = 'grid';

  late ApptiveGridClient client;

  setUpAll(() {
    registerFallbackValue(GridUri(user: 'user', space: 'space', grid: 'grid'));
    registerFallbackValue(
      [ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc)],
    );
  });

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
    when(
      () => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId),
      ),
    ).thenAnswer(
      (_) async => Grid(
        id: gridId,
        name: title,
        fields: [],
        rows: [],
        links: {},
      ),
    );

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
          id: gridId,
          name: 'Initial Title',
          fields: [],
          rows: [],
          links: {},
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
    when(
      () => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId),
      ),
    ).thenAnswer(
      (_) async => Grid(
        id: gridId,
        name: title,
        fields: [],
        rows: [],
        links: {},
      ),
    );

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

    when(
      () => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId),
      ),
    ).thenAnswer((_) => Future.error(''));

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
    when(
      () => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId),
      ),
    ).thenAnswer(
      (_) async => Grid(
        id: gridId,
        name: title,
        fields: [],
        rows: [],
        links: {},
      ),
    );

    await tester.pumpWidget(target);
    await tester.pump();

    await key.currentState!.reload();

    verify(
      () => client.loadGrid(
        gridUri: GridUri(user: user, space: space, grid: gridId),
      ),
    ).called(2);
  });

  group('GridUri', () {
    testWidgets('Changing GridUri reloads', (tester) async {
      final uri1 = GridUri.fromUri('/uri1');
      final uri2 = GridUri.fromUri('/uri2');
      final target = TestApp(
        client: client,
        child: _SortingAndFilterSwitcher(
          gridUri1: uri1,
          gridUri2: uri2,
        ),
      );

      final title = 'Title';
      when(
        () => client.loadGrid(
          gridUri: any(named: 'gridUri'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (_) async => Grid(
          id: 'grid',
          name: title,
          fields: [],
          rows: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.loadGrid(
          gridUri: uri1,
          filter: any(named: 'filter'),
        ),
      ).called(1);

      verify(
        () => client.loadGrid(
          gridUri: uri2,
          filter: any(named: 'filter'),
        ),
      ).called(1);
    });
  });

  group('Sorting', () {
    testWidgets('Sorting is applied', (tester) async {
      final sorting = [
        ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc)
      ];
      final target = TestApp(
        client: client,
        child: ApptiveGridGridBuilder(
          sorting: sorting,
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
      when(
        () => client.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId),
          sorting: sorting,
        ),
      ).thenAnswer(
        (_) async => Grid(
          id: 'grid',
          name: title,
          fields: [],
          rows: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);

      final capturedSorting = verify(
        () => client.loadGrid(
          gridUri: any(named: 'gridUri'),
          sorting: captureAny(named: 'sorting'),
        ),
      ).captured.first as List<ApptiveGridSorting>;
      expect(capturedSorting, equals(sorting));
    });

    testWidgets('Switching Sorting triggers reload', (tester) async {
      final sorting = [
        ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc)
      ];
      final target = TestApp(
        client: client,
        child: _SortingAndFilterSwitcher(
          gridUri1: GridUri(user: user, space: space, grid: gridId),
          sorting1: sorting,
          sorting2: [
            ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.desc)
          ],
        ),
      );

      final title = 'Title';
      when(
        () => client.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId),
          sorting: any(named: 'sorting'),
        ),
      ).thenAnswer(
        (_) async => Grid(
          id: 'grid',
          name: title,
          fields: [],
          rows: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.loadGrid(
          gridUri: any(named: 'gridUri'),
          sorting: any(named: 'sorting'),
        ),
      ).called(2);
    });
  });

  group('Filter', () {
    testWidgets('Filter is applied', (tester) async {
      final filter =
          EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
      final target = TestApp(
        client: client,
        child: ApptiveGridGridBuilder(
          filter: filter,
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
      when(
        () => client.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId),
          filter: filter,
        ),
      ).thenAnswer(
        (_) async => Grid(
          id: 'grid',
          name: title,
          fields: [],
          rows: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);

      final capturedSorting = verify(
        () => client.loadGrid(
          gridUri: any(named: 'gridUri'),
          filter: captureAny(named: 'filter'),
        ),
      ).captured.first as ApptiveGridFilter;
      expect(capturedSorting, equals(filter));
    });

    testWidgets('Switching Filters triggers reload', (tester) async {
      final filter1 =
          EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
      final filter2 =
          EqualsFilter(fieldId: 'fieldId1', value: StringDataEntity('value1'));
      final target = TestApp(
        client: client,
        child: _SortingAndFilterSwitcher(
          gridUri1: GridUri(user: user, space: space, grid: gridId),
          filter1: filter1,
          filter2: filter2,
        ),
      );

      final title = 'Title';
      when(
        () => client.loadGrid(
          gridUri: GridUri(user: user, space: space, grid: gridId),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (_) async => Grid(
          id: 'grid',
          name: title,
          fields: [],
          rows: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.loadGrid(
          gridUri: any(named: 'gridUri'),
          filter: any(named: 'filter'),
        ),
      ).called(2);
    });
  });
}

class _SortingAndFilterSwitcher extends StatefulWidget {
  const _SortingAndFilterSwitcher({
    this.sorting1,
    this.sorting2,
    this.filter1,
    this.filter2,
    required this.gridUri1,
    this.gridUri2,
  });

  final List<ApptiveGridSorting>? sorting1;
  final List<ApptiveGridSorting>? sorting2;

  final ApptiveGridFilter? filter1;
  final ApptiveGridFilter? filter2;

  final GridUri gridUri1;
  final GridUri? gridUri2;

  @override
  State<_SortingAndFilterSwitcher> createState() =>
      _SortingAndFilterSwitcherState();
}

class _SortingAndFilterSwitcherState extends State<_SortingAndFilterSwitcher> {
  late List<ApptiveGridSorting>? _sorting;
  late ApptiveGridFilter? _filter;
  late GridUri _gridUri;

  @override
  void initState() {
    super.initState();
    _sorting = widget.sorting1;
    _filter = widget.filter1;
    _gridUri = widget.gridUri1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _sorting = widget.sorting2;
              _filter = widget.filter2;
              if (widget.gridUri2 != null) {
                _gridUri = widget.gridUri2!;
              }
            });
          },
          child: Text('Switch Sorting'),
        ),
        ApptiveGridGridBuilder(
          sorting: _sorting,
          filter: _filter,
          gridUri: _gridUri,
          builder: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
