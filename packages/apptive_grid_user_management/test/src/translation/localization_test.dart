import 'package:apptive_grid_user_management/src/login_content.dart';
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
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
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

  testWidgets('Switch Locale updates', (tester) async {
    late BuildContext context;
    final localeKey = GlobalKey<_ReloadLocalizationsState>();
    final target = MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('de')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Material(
        child: ApptiveGridUserManagementLocalization(
          child: _ReloadLocalizations(
            key: localeKey,
            child: Builder(
              builder: (buildContext) {
                context = buildContext;
                return const LoginContent();
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pump();

    expect(
      ApptiveGridUserManagementLocalization.of(context),
      isInstanceOf<en.ApptiveGridUserManagementLocalizedTranslation>(),
    );

    localeKey.currentState!.locale = const Locale('de');
    await tester.pump();

    expect(
      ApptiveGridUserManagementLocalization.of(context),
      isInstanceOf<de.ApptiveGridUserManagementLocalizedTranslation>(),
    );
  });
}

class _ReloadLocalizations extends StatefulWidget {
  const _ReloadLocalizations({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_ReloadLocalizations> createState() => _ReloadLocalizationsState();
}

class _ReloadLocalizationsState extends State<_ReloadLocalizations> {
  Locale? _locale;

  set locale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: _locale ?? Localizations.localeOf(context),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: widget.child,
    );
  }
}
