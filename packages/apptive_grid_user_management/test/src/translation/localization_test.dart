import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/translation/l10n/translation_de.dart'
    as de;
import 'package:apptive_grid_user_management/src/translation/l10n/translation_en.dart'
    as en;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Uses Locale from App', (tester) async {
    late final BuildContext context;
    final target = MaterialApp(
      locale: const Locale('de'),
      supportedLocales: const [Locale('de')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: ApptiveGridUserManagementLocalization(
        child: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    expect(
      ApptiveGridUserManagementLocalization.of(context),
      isInstanceOf<de.ApptiveGridUserManagementLocalizedTranslation>(),
    );
  });

  testWidgets('Default locale is en', (tester) async {
    late final BuildContext context;
    final target = ApptiveGridUserManagementLocalization(
      child: Builder(
        builder: (buildContext) {
          context = buildContext;
          return const SizedBox();
        },
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    expect(
      ApptiveGridUserManagementLocalization.of(context),
      isInstanceOf<en.ApptiveGridUserManagementLocalizedTranslation>(),
    );
  });
}
