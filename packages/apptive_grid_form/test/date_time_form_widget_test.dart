import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
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
  });

  const field = GridField(id: 'fieldId', name: 'name', type: DataType.dateTime);
  group('Localization', () {
    final date = DateTime(2021, 11, 5, 16, 32);

    testWidgets('en_US has American Date Format', (tester) async {
      const locale = Locale('en', 'US');

      final target = MaterialApp(
        locale: locale,
        supportedLocales: const [locale],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Material(
          child: ApptiveGridLocalization(
            child: DateTimeFormWidget(
              component: FormComponent<DateTimeDataEntity>(
                property: 'property',
                data: DateTimeDataEntity(date),
                field: field,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('11/5/2021'), findsOneWidget);
      expect(find.text('4:32 PM'), findsOneWidget);
    });

    testWidgets('de has German Date Format', (tester) async {
      const locale = Locale('de');

      final target = MaterialApp(
        locale: locale,
        supportedLocales: const [locale],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Material(
          child: ApptiveGridLocalization(
            child: DateTimeFormWidget(
              component: FormComponent<DateTimeDataEntity>(
                property: 'property',
                data: DateTimeDataEntity(date),
                field: field,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('5.11.2021'), findsOneWidget);
      expect(find.text('16:32'), findsOneWidget);
    });
  });

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
      final formData = FormData(
        id: 'formId',
        title: 'title',
        components: [
          FormComponent<DateTimeDataEntity>(
            property: 'Property',
            data: DateTimeDataEntity(DateTime.now()),
            field: field,
            required: true,
          ),
        ],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions())
          .thenAnswer((_) => Future.value([]));
      when(() => client.submitFormWithProgress(action, any())).thenAnswer(
        (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });

  testWidgets('Changing Date keeps Time', (tester) async {
    const locale = Locale('de');
    final date = DateTime(2021, 11, 5, 16, 32);
    final newDate = DateTime(2021, 11, 6, 16, 32);

    final target = MaterialApp(
      locale: locale,
      supportedLocales: const [locale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Material(
        child: ApptiveGridLocalization(
          child: DateTimeFormWidget(
            component: FormComponent<DateTimeDataEntity>(
              property: 'property',
              data: DateTimeDataEntity(date),
              field: field,
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    final dateFinder = find.text('5.11.2021');
    final newDateFinder = find.text('6.11.2021');
    final timeFinder = find.text('16:32');

    expect(dateFinder, findsOneWidget);
    expect(timeFinder, findsOneWidget);

    await tester
        .tap(find.ancestor(of: dateFinder, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('OK'),
    );
    await tester.pumpAndSettle();

    expect(dateFinder, findsNothing);
    expect(newDateFinder, findsOneWidget);
    expect(timeFinder, findsOneWidget);
    expect(
      (find.byType(DateTimeFormWidget).evaluate().first.widget
              as DateTimeFormWidget)
          .component
          .data
          .value,
      equals(newDate),
    );
  });

  testGoldens('Changing Time keeps Date', (tester) async {
    // Without loading the AppFonts the Time Select Dialog overflows
    await loadAppFonts();
    const locale = Locale('de');
    final date = DateTime(2021, 11, 5, 16, 32);
    final newDate = DateTime(2021, 11, 5, 23, 32);

    final target = MaterialApp(
      locale: locale,
      supportedLocales: const [locale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Material(
        child: ApptiveGridLocalization(
          child: DateTimeFormWidget(
            component: FormComponent<DateTimeDataEntity>(
              property: 'property',
              data: DateTimeDataEntity(date),
              field: field,
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    final dateFinder = find.text('5.11.2021');
    final timeFinder = find.text('16:32');
    final newTimeFinder = find.text('23:32');

    expect(dateFinder, findsOneWidget);
    expect(timeFinder, findsOneWidget);

    await tester
        .tap(find.ancestor(of: timeFinder, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    final hourTextFieldFinder = find
        .descendant(
          of: find.byType(TimePickerDialog),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is TextFormField &&
                widget.restorationId == 'hour_minute_text_form_field',
          ),
        )
        .first;
    await tester.enterText(hourTextFieldFinder, '11');
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('OK'),
    );
    await tester.pumpAndSettle();

    expect(dateFinder, findsOneWidget);
    expect(timeFinder, findsNothing);
    expect(newTimeFinder, findsOneWidget);
    expect(
      (find.byType(DateTimeFormWidget).evaluate().first.widget
              as DateTimeFormWidget)
          .component
          .data
          .value,
      equals(newDate),
    );
  });
}
