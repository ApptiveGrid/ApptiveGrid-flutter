import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';
import 'package:apptive_grid_user_management/src/translation/l10n/translation_de.dart'
    as de;
import 'package:apptive_grid_user_management/src/translation/l10n/translation_en.dart'
    as en;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides Translations for ApptiveGridUserManagement Widgets
class ApptiveGridUserManagementLocalization extends StatelessWidget {
  /// Creates a wrapper so that the descendants can use localized Strings
  const ApptiveGridUserManagementLocalization({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The child that should be wrapped
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedApptiveGridUserManagementTranslation(
      child: Builder(
        builder: (_) => child,
      ),
    );
  }

  /// Returns an [ApptiveGridUserManagementTranslation] best matching the current App [Locale]
  ///
  /// If the Locale is not supported it defaults to an english translation
  static ApptiveGridUserManagementTranslation? of(BuildContext context) {
    final _InheritedApptiveGridUserManagementTranslation? inheritedTranslation =
        context.dependOnInheritedWidgetOfExactType<
            _InheritedApptiveGridUserManagementTranslation>();
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

  /// List of currently supported locales by ApptiveGridUserManagement
  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }
}

class _InheritedApptiveGridUserManagementTranslation extends InheritedWidget {
  _InheritedApptiveGridUserManagementTranslation({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    final defaultTranslations = <Locale, ApptiveGridUserManagementTranslation>{
      const Locale.fromSubtags(languageCode: 'en'):
          const en.ApptiveGridUserManagementLocalizedTranslation(),
      const Locale.fromSubtags(languageCode: 'de'):
          const de.ApptiveGridUserManagementLocalizedTranslation(),
    };
    _translations.addAll(defaultTranslations);
  }

  final Map<Locale, ApptiveGridUserManagementTranslation> _translations =
      <Locale, ApptiveGridUserManagementTranslation>{};

  ApptiveGridUserManagementTranslation translation(Locale? locale) {
    if (locale != null) {
      if (_translations.containsKey(locale)) {
        return _translations[locale]!;
      } else if (ApptiveGridUserManagementLocalization.isSupported(locale)) {
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
  bool updateShouldNotify(
    _InheritedApptiveGridUserManagementTranslation oldWidget,
  ) =>
      !mapEquals(_translations, oldWidget._translations);
}
