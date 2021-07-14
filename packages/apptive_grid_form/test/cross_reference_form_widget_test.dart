import 'dart:async';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:apptive_grid_form/widgets/form_widget/grid_row_dropdown/grid_row_dropdown_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final grid = Grid('Test', null, [
      field
    ], [
      GridRow('row1', [GridEntry(field, StringDataEntity('First'))]),
      GridRow('row2', [GridEntry(field, StringDataEntity('Second'))]),
    ]);

    setUp(() {
      client = MockApptiveGridClient();
      formKey = GlobalKey();
      final data = CrossReferenceDataEntity(gridUri: gridUri);
      final component = CrossReferenceFormComponent(
          property: 'Property', data: data, fieldId: 'fieldId', required: true);

      when(() => client.sendPendingActions()).thenAnswer((_) async {});
      when(() => client.loadGrid(gridUri: gridUri))
          .thenAnswer((_) async => grid);

      target = TestApp(
        client: client,
        child: Form(
            key: formKey,
            child: CrossReferenceFormWidget(component: component)),
      );
    });

    testWidgets('Filter Rows', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      // Dropdown creates multiple instances. Thus expecting one entry more than actually expected
      expect(find.text('First'), findsNWidgets(2));
      expect(find.text('Second'), findsNWidgets(2));

      // Filter
      await tester.enterText(find.byType(TextField), 'Sec');
      await tester.pumpAndSettle();
      expect(find.text('First'),
          findsOneWidget); // See above why one more than expected
      expect(find.text('Second'), findsNWidgets(2));
    });

    testWidgets('Select Widget', (tester) async {
      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      await tester.tap(find.text('First').last);
      await tester.pumpAndSettle();

      expect(find.text('First'), findsOneWidget);
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

      expect(find.text('Loading Grid...'), findsOneWidget);

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

      expect(find.text('Property is required'), findsOneWidget);
    });
  });

  group('GridRowDropdownDataItem', () {
    test('Equality', () {
      final entityUri = EntityUri(
          user: 'user', space: 'space', grid: 'grid', entity: 'entity');
      final value = 'value';
      final a =
          GridRowDropdownDataItem(entityUri: entityUri, displayValue: value);
      final b = GridRowDropdownDataItem(
          entityUri: EntityUri.fromUri(entityUri.uriString),
          displayValue: value);
      final c = GridRowDropdownDataItem(
        entityUri: entityUri,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });
}
