import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FormData(title: 'title', components: [], schema: {}));
  });

  group('Localization', () {
    final date = DateTime(2021, 11, 5, 16, 32);

    testWidgets('en_US has American Date Format', (tester) async {
      const locale = Locale('en', 'US');

      final target = MaterialApp(
        locale: locale,
        supportedLocales: const [locale],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: Material(
          child: ApptiveGridLocalization(
            child: DateTimeFormWidget(
              component: DateTimeFormComponent(
                property: 'property',
                data: DateTimeDataEntity(date),
                fieldId: 'fieldId',
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
          GlobalWidgetsLocalizations.delegate
        ],
        home: Material(
          child: ApptiveGridLocalization(
            child: DateTimeFormWidget(
              component: DateTimeFormComponent(
                property: 'property',
                data: DateTimeDataEntity(date),
                fieldId: 'fieldId',
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
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          DateTimeFormComponent(
            property: 'Property',
            data: DateTimeDataEntity(DateTime.now()),
            fieldId: 'fieldId',
            required: true,
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
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
