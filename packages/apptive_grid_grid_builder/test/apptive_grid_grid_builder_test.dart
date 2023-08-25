import 'package:apptive_grid_grid_builder/apptive_grid_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  const user = 'user';
  const space = 'space';
  const gridId = 'grid';

  late ApptiveGridClient client;

  setUpAll(() {
    registerFallbackValue(
      Uri.parse('/api/users/user/spaces/space/grids/grid'),
    );
    registerFallbackValue(
      [const ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc)],
    );
  });

  setUp(() {
    client = MockApptiveGridClient();

    when(() => client.sendPendingActions()).thenAnswer((_) async => []);
  });

  testWidgets('Builder is called with data', (tester) async {
    final target = TestApp(
      client: client,
      child: ApptiveGridGridBuilder(
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );

    const title = 'Title';
    when(
      () => client.loadGrid(
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
            return const CircularProgressIndicator();
          }
        },
      ),
    );

    const title = 'Title';
    when(
      () => client.loadGrid(
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );

    when(
      () => client.loadGrid(
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );

    const title = 'Title';
    when(
      () => client.loadGrid(
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
        uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
      ),
    ).called(2);
  });

  group('GridUri', () {
    testWidgets('Changing GridUri reloads', (tester) async {
      final uri1 = Uri.parse('/uri1');
      final uri2 = Uri.parse('/uri2');
      final target = TestApp(
        client: client,
        child: _SortingAndFilterSwitcher(
          gridUri1: uri1,
          gridUri2: uri2,
        ),
      );

      const title = 'Title';
      when(
        () => client.loadGrid(
          uri: any(named: 'uri'),
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
          uri: uri1,
          filter: any(named: 'filter'),
        ),
      ).called(1);

      verify(
        () => client.loadGrid(
          uri: uri2,
          filter: any(named: 'filter'),
        ),
      ).called(1);
    });
  });

  group('Sorting', () {
    testWidgets('Sorting is applied', (tester) async {
      final sorting = [
        const ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc),
      ];
      final target = TestApp(
        client: client,
        child: ApptiveGridGridBuilder(
          sorting: sorting,
          uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      );

      const title = 'Title';
      when(
        () => client.loadGrid(
          uri: Uri.parse('/api/users/user/spaces/space/grids/gridId'),
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
          uri: any(named: 'uri'),
          sorting: captureAny(named: 'sorting'),
        ),
      ).captured.first as List<ApptiveGridSorting>;
      expect(capturedSorting, equals(sorting));
    });

    testWidgets('Switching Sorting triggers reload', (tester) async {
      final sorting = [
        const ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.asc),
      ];
      final target = TestApp(
        client: client,
        child: _SortingAndFilterSwitcher(
          gridUri1: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
          sorting1: sorting,
          sorting2: const [
            ApptiveGridSorting(fieldId: 'fieldId', order: SortOrder.desc),
          ],
        ),
      );

      const title = 'Title';
      when(
        () => client.loadGrid(
          uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
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
          uri: any(named: 'uri'),
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
          uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      );

      const title = 'Title';
      when(
        () => client.loadGrid(
          uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
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
          uri: any(named: 'uri'),
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
          gridUri1: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
          filter1: filter1,
          filter2: filter2,
        ),
      );

      const title = 'Title';
      when(
        () => client.loadGrid(
          uri: Uri.parse('/api/users/$user/spaces/$space/grids/$gridId'),
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
          uri: any(named: 'uri'),
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

  final Uri gridUri1;
  final Uri? gridUri2;

  @override
  State<_SortingAndFilterSwitcher> createState() =>
      _SortingAndFilterSwitcherState();
}

class _SortingAndFilterSwitcherState extends State<_SortingAndFilterSwitcher> {
  late List<ApptiveGridSorting>? _sorting;
  late ApptiveGridFilter? _filter;
  late Uri _gridUri;

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
          child: const Text('Switch Sorting'),
        ),
        ApptiveGridGridBuilder(
          sorting: _sorting,
          filter: _filter,
          uri: _gridUri,
          builder: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
