import 'package:apptive_grid_form/translation/apptive_grid_translation.dart';
import 'package:flutter/material.dart';

import 'package:apptive_grid_form/translation/l10n/translation_de.dart' as de;
import 'package:apptive_grid_form/translation/l10n/translation_en.dart' as en;

class ApptiveGridLocalization extends StatelessWidget {
  const ApptiveGridLocalization({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedApptiveGridTranslation(
      child: Builder(
        builder: (_) => child,
      ),
    );
  }

  static ApptiveGridTranslation? of(BuildContext context) {
    final _InheritedApptiveGridTranslation? inheritedTranslation = context
        .dependOnInheritedWidgetOfExactType<_InheritedApptiveGridTranslation>();
    return inheritedTranslation
        ?.translation(Localizations.maybeLocaleOf(context));
  }

  /// Checks if given [locale] is supported by its langaugeCode
  static bool isSupported(Locale locale) => _isSupported(locale);

  static bool _isSupported(Locale locale) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  /// List of currently supported locales by Wiredash
  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }
}

class _InheritedApptiveGridTranslation extends InheritedWidget {
  _InheritedApptiveGridTranslation({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    final defaultTranslations = <Locale, ApptiveGridTranslation>{
      const Locale.fromSubtags(languageCode: 'en'):
          const en.ApptiveGridLocalizedTranslation(),
      const Locale.fromSubtags(languageCode: 'de'):
          const de.ApptiveGridLocalizedTranslation(),
    };
    _translations.addAll(defaultTranslations);
  }

  final Map<Locale, ApptiveGridTranslation> _translations =
      <Locale, ApptiveGridTranslation>{};

  ApptiveGridTranslation translation(Locale? locale) {
    if (locale != null) {
      if (_translations.containsKey(locale)) {
        return _translations[locale]!;
      } else if (ApptiveGridLocalization.isSupported(locale)) {
        final translation = _translations[
            Locale.fromSubtags(languageCode: locale.languageCode)];
        if (translation != null) {
          return translation;
        }
      }
    }
    return _translations[const Locale.fromSubtags(languageCode: 'en')]!;
  }

  @override
  bool updateShouldNotify(_InheritedApptiveGridTranslation oldWidget) =>
      _translations != oldWidget._translations;
}
