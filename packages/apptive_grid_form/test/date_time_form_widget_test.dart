import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
