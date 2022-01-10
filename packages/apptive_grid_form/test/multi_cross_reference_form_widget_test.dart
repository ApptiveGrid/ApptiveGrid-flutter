import 'dart:async';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  group('FormWidget', () {
    late ApptiveGridClient client;
    late Widget target;
    late GlobalKey<FormState> formKey;

    final gridUri = GridUri(user: 'user', space: 'space', grid: 'grid');
    final field = GridField('field', 'Name', DataType.text);
    final grid = Grid(
      name: 'Test',
      schema: null,
      fields: [field],
      rows: [
        GridRow('row1', [GridEntry(field, StringDataEntity('First'))]),
        GridRow('row2', [GridEntry(field, StringDataEntity('Second'))]),
      ],
    );

    setUp(() {
      client = MockApptiveGridClient();
      formKey = GlobalKey();
      final data = MultiCrossReferenceDataEntity(gridUri: gridUri);
      final component = MultiCrossReferenceFormComponent(
        property: 'Property',
        data: data,
        fieldId: 'fieldId',
        required: true,
      );

      when(() => client.sendPendingActions()).thenAnswer((_) async {});
      when(() => client.loadGrid(gridUri: gridUri))
          .thenAnswer((_) async => grid);

      target = TestApp(
        client: client,
        child: Form(
          key: formKey,
          child: MultiCrossReferenceFormWidget(component: component),
        ),
      );
    });

    testWidgets('Filter Rows', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsNWidgets(1));
      expect(find.text('Second'), findsNWidgets(1));

      // Filter
      await tester.enterText(find.byType(TextField), 'Sec');
      await tester.pumpAndSettle();
      expect(
        find.text('First'),
        findsNothing,
      );
      expect(find.text('Second'), findsNWidgets(1));
    });

    testWidgets('Select Widget', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      await tester.tap(find.text('First').last);
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(MultiCrossReferenceFormWidget), matching: find.text('First')), findsOneWidget);
    });

    testWidgets('Select Multiple Widgets', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      await tester.tap(find.text('First').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Second').last);
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(MultiCrossReferenceFormWidget), matching: find.text('First, Second')), findsOneWidget);
    });

    testWidgets('De-Select Item Widgets', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      await tester.tap(find.text('First').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Second').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('First').last);
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(MultiCrossReferenceFormWidget), matching: find.text('Second')), findsOneWidget);
    });

    testWidgets('Loading Grid has Error, displays error', (tester) async {
      when(() => client.loadGrid(gridUri: gridUri))
          .thenAnswer((_) => Future.error('Error loading Grid'));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Error loading Grid'), findsOneWidget);

      // Does not open Popup
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsNothing);
    });

    testWidgets('Loading Grid shows Loading State', (tester) async {
      final completer = Completer<Grid>();
      when(() => client.loadGrid(gridUri: gridUri))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Loading Grid'), findsOneWidget);

      // Does not open Popup
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsNothing);

      completer.complete(grid);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('Required, shows Error', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      formKey.currentState?.validate();
      await tester.pumpAndSettle();

      expect(find.text('Property must not be empty'), findsOneWidget);
    });

    testWidgets('Empty null values', (tester) async {
      final gridWithNull = Grid(
        name: 'Test',
        schema: null,
        fields: [field],
        rows: [
          GridRow('row1', [GridEntry(field, StringDataEntity())]),
        ],
      );

      when(() => client.loadGrid(gridUri: gridUri))
          .thenAnswer((_) async => gridWithNull);

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      expect(find.text('null'), findsNothing);
      await tester.tap(find.byType(GridRowWidget));
      await tester.pumpAndSettle();

      expect(find.text('null'), findsNothing);
    });
  });
}
