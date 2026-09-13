import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

final _scanButton = find.byKey(const Key('BarcodeScanButton'));

BarcodeScannerConfiguration _scanner(String value, {List<String>? log}) =>
    BarcodeScannerConfiguration(
      scan: (_) async {
        log?.add(value);
        return value;
      },
      buttonTooltip: 'Scan',
    );

FormFieldProperties _properties({required bool enableBarcodeScanner}) =>
    FormFieldProperties(
      fieldId: 'fieldId',
      enableBarcodeScanner: enableBarcodeScanner,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(id: 'id', title: '', components: [], fields: [], links: {}),
    );
    registerFallbackValue(Uri.parse('/api/users/user/spaces/space/grids/grid'));
  });

  group('Text field', () {
    const field = GridField(id: 'fieldId', name: 'name', type: DataType.text);

    Future<void> pumpText(
      WidgetTester tester, {
      required bool enableBarcodeScanner,
      BarcodeScannerConfiguration? configuration,
      bool enabled = true,
    }) async {
      await tester.pumpWidget(
        TestApp(
          options: ApptiveGridOptions(
            formWidgetConfigurations: [
              if (configuration != null) configuration,
            ],
          ),
          child: TextFormWidget(
            component: FormComponent<StringDataEntity>(
              property: 'Property',
              data: StringDataEntity(),
              field: field,
              enabled: enabled,
            ),
            fieldProperties:
                _properties(enableBarcodeScanner: enableBarcodeScanner),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('No button without a scanner from the app', (tester) async {
      // The field asks for a scanner, but nothing can serve it
      await pumpText(tester, enableBarcodeScanner: true);
      expect(_scanButton, findsNothing);
    });

    testWidgets('No button where the field did not ask for one',
        (tester) async {
      await pumpText(
        tester,
        enableBarcodeScanner: false,
        configuration: _scanner('anything'),
      );
      expect(_scanButton, findsNothing);
    });

    testWidgets('A scan fills the field', (tester) async {
      await pumpText(
        tester,
        enableBarcodeScanner: true,
        configuration: _scanner('4006381333931'),
      );
      expect(_scanButton, findsOneWidget);

      await tester.tap(_scanButton);
      await tester.pumpAndSettle();

      expect(find.text('4006381333931'), findsOneWidget);
    });

    testWidgets('A disabled field cannot be scanned into', (tester) async {
      await pumpText(
        tester,
        enableBarcodeScanner: true,
        configuration: _scanner('4006381333931'),
        enabled: false,
      );

      expect(tester.widget<IconButton>(_scanButton).onPressed, isNull);
    });
  });

  group('Cross reference picker', () {
    final gridUri = Uri.parse('/api/users/user/spaces/space/grids/grid');
    const crossRefField =
        GridField(id: 'fieldId', name: 'name', type: DataType.crossReference);
    const nameField = GridField(id: 'field', name: 'Name', type: DataType.text);

    final queryLink = ApptiveLink(
      uri: gridUri.replace(path: '${gridUri.path}/query'),
      method: 'get',
    );

    final grid = Grid(
      id: 'grid',
      name: 'Test',
      fields: [nameField],
      rows: [],
      links: {
        ApptiveLinkType.self: ApptiveLink(uri: gridUri, method: 'get'),
        ApptiveLinkType.query: queryLink,
      },
    );

    Map<String, dynamic> entity(String id, String name) => {
          '_id': id,
          'fields': [name],
          '_links': {
            'self': {'href': '/api/entities/$id', 'method': 'get'},
          },
        };

    late ApptiveGridClient client;

    setUp(() {
      client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) async => []);
      when(() => client.loadGrid(uri: any(named: 'uri'), loadEntities: false))
          .thenAnswer((_) async => grid);
      when(
        () => client.performApptiveLink<List<GridRow>>(
          link: queryLink,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        final query = invocation.namedArguments[const Symbol('queryParameters')]
            ['matching'] as String?;
        final parseResponse =
            invocation.namedArguments[const Symbol('parseResponse')]
                as Future<List<GridRow>?> Function(Response);
        final entities = query == null || query.isEmpty
            ? [entity('row1', 'First'), entity('row2', 'Second')]
            // A scanned code matches exactly one row
            : [entity('row2', 'Second')];
        return parseResponse(
          Response(jsonEncode({'entities': entities}), 200),
        );
      });
    });

    Future<void> pumpPicker(
      WidgetTester tester, {
      required bool enableBarcodeScanner,
      BarcodeScannerConfiguration? configuration,
    }) async {
      // ApptiveGrid.getOptions reads them off the client, so the mock has to
      // carry them rather than TestApp
      when(() => client.options).thenReturn(
        ApptiveGridOptions(
          formWidgetConfigurations: [
            if (configuration != null) configuration,
          ],
        ),
      );
      await tester.pumpWidget(
        TestApp(
          client: client,
          child: CrossReferenceFormWidget(
            component: FormComponent<CrossReferenceDataEntity>(
              property: 'Property',
              data: CrossReferenceDataEntity(gridUri: gridUri),
              field: crossRefField,
            ),
            fieldProperties:
                _properties(enableBarcodeScanner: enableBarcodeScanner),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();
    }

    testWidgets('No button without a scanner from the app', (tester) async {
      await pumpPicker(tester, enableBarcodeScanner: true);
      expect(_scanButton, findsNothing);
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('A scan selects the row it unambiguously points at',
        (tester) async {
      final scanned = <String>[];
      await pumpPicker(
        tester,
        enableBarcodeScanner: true,
        configuration: _scanner('Second', log: scanned),
      );
      expect(_scanButton, findsOneWidget);
      expect(find.text('First'), findsOneWidget);

      await tester.tap(_scanButton);
      await tester.pumpAndSettle();

      expect(scanned, equals(['Second']));
      // The overlay closed on the match, leaving the picked value behind
      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);
    });
  });
}
