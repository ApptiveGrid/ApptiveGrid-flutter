import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/translation/l10n/translation_de.dart' as de;
import 'package:apptive_grid_form/translation/l10n/translation_en.dart' as en;
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
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: ApptiveGridLocalization(
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
      ApptiveGridLocalization.of(context),
      isInstanceOf<de.ApptiveGridLocalizedTranslation>(),
    );
  });

  testWidgets('Default locale is en', (tester) async {
    late final BuildContext context;
    final target = ApptiveGridLocalization(
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
      ApptiveGridLocalization.of(context),
      isInstanceOf<en.ApptiveGridLocalizedTranslation>(),
    );
  });
}
