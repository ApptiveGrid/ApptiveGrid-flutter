import 'dart:async';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(
        id: 'id',
        links: {},
        title: 'title',
        components: [],
        fields: [],
      ),
    );
    registerFallbackValue(
      Uri.parse('/api/users/user/spaces/space/grids/grid'),
    );
  });

  group('FormWidget', () {
    late ApptiveGridClient client;
    late Widget target;
    late GlobalKey<FormState> formKey;

    final gridUri = Uri.parse('/api/users/user/spaces/space/grids/grid');
    final field = GridField(id: 'field', name: 'Name', type: DataType.text);
    final grid = Grid(
      id: 'grid',
      name: 'Test',
      fields: [field],
      rows: [
        GridRow(
          id: 'row1',
          entries: [GridEntry(field, StringDataEntity('First'))],
          links: {},
        ),
        GridRow(
          id: 'row2',
          entries: [GridEntry(field, StringDataEntity('Second'))],
          links: {},
        ),
      ],
      links: {
        ApptiveLinkType.self: ApptiveLink(uri: gridUri, method: 'get'),
        ApptiveLinkType.entities: ApptiveLink(
          uri: gridUri.replace(path: '${gridUri.path}/entities'),
          method: 'get',
        ),
      },
    );

    setUp(() {
      client = MockApptiveGridClient();
      formKey = GlobalKey();
      final data = MultiCrossReferenceDataEntity(gridUri: gridUri);
      final component = FormComponent<MultiCrossReferenceDataEntity>(
        property: 'Property',
        data: data,
        field: field,
        required: true,
      );

      when(() => client.sendPendingActions()).thenAnswer((_) async {});
      when(() => client.loadGrid(uri: gridUri)).thenAnswer((_) async => grid);

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

      expect(
        find.descendant(
          of: find.byType(MultiCrossReferenceFormWidget),
          matching: find.text('First'),
        ),
        findsOneWidget,
      );
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

      expect(
        find.descendant(
          of: find.byType(MultiCrossReferenceFormWidget),
          matching: find.text('First, Second'),
        ),
        findsOneWidget,
      );
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

      expect(
        find.descendant(
          of: find.byType(MultiCrossReferenceFormWidget),
          matching: find.text('Second'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Loading Grid has Error, displays error', (tester) async {
      when(() => client.loadGrid(uri: gridUri))
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
      when(() => client.loadGrid(uri: gridUri))
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
        id: 'grid',
        name: 'Test',
        fields: [field],
        rows: [
          GridRow(
            id: 'row1',
            entries: [GridEntry(field, StringDataEntity())],
            links: {},
          ),
        ],
        links: {
          ApptiveLinkType.self: ApptiveLink(uri: gridUri, method: 'get'),
          ApptiveLinkType.entities: ApptiveLink(
            uri: gridUri.replace(path: '${gridUri.path}/entities'),
            method: 'get',
          ),
        },
      );

      when(() => client.loadGrid(uri: gridUri))
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

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      final field = GridField(
        id: 'fieldId',
        name: 'name',
        type: DataType.multiCrossReference,
      );
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<MultiCrossReferenceDataEntity>(
            property: 'Property',
            data: MultiCrossReferenceDataEntity(
              gridUri: Uri.parse('/api/a/user/spaces/space/grids/grid'),
              references: [
                CrossReferenceDataEntity(
                  value: 'CrossRef',
                  gridUri: Uri.parse('/api/a/user/spaces/space/grids/grid'),
                  entityUri: Uri.parse(
                    '/api/a/user/spaces/space/grids/grid/entities/entity',
                  ),
                ),
              ],
            ),
            field: field,
            required: true,
          )
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.loadGrid(uri: any(named: 'uri'))).thenAnswer(
        (invocation) async => Grid(
          id: 'grid',
          name: 'name',
          fields: [],
          rows: [],
          links: {},
        ),
      );
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.submitForm(action, any()))
          .thenAnswer((_) async => Response('body', 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });
}
