import 'package:apptive_grid_form/src/translation/apptive_grid_translation.dart';
import 'package:apptive_grid_form/src/translation/l10n/translation_de.dart' as de;
import 'package:apptive_grid_form/src/translation/l10n/translation_en.dart' as en;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides Translations for ApptiveGridForm Widgets
class ApptiveGridLocalization extends StatelessWidget {
  /// Creates a wrapper around a Form so that the descendants can use localized Strings
  const ApptiveGridLocalization({
    super.key,
    required this.child,
  });

  /// The child that should be wrapped
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedApptiveGridTranslation(
      child: Builder(
        builder: (_) => child,
      ),
    );
  }

  /// Returns an [ApptiveGridTranslation] best matching the current App [Locale]
  ///
  /// If the Locale is not supported it defaults to an english translation
  static ApptiveGridTranslation? of(BuildContext context) {
    final _InheritedApptiveGridTranslation? inheritedTranslation = context
        .dependOnInheritedWidgetOfExactType<_InheritedApptiveGridTranslation>();
    return inheritedTranslation
        ?.translation(Localizations.maybeLocaleOf(context));
  }

  /// Checks if given [locale] is supported by its languageCode
  static bool isSupported(Locale locale) => _isSupported(locale);

  static bool _isSupported(Locale locale) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  /// List of currently supported locales by ApptiveGridForm
  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }
}

class _InheritedApptiveGridTranslation extends InheritedWidget {
  _InheritedApptiveGridTranslation({
    required super.child,
  }) {
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
      !mapEquals(_translations, oldWidget._translations);
}
