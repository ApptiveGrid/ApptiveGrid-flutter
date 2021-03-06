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
    super.key,
    this.customTranslations = const {},
    required this.child,
  });

  /// The child that should be wrapped
  final Widget child;

  /// Provide custom Translations. This can be used to either add additional Translations or override existing translations
  final Map<Locale, ApptiveGridUserManagementTranslation> customTranslations;

  @override
  Widget build(BuildContext context) {
    return _InheritedApptiveGridUserManagementTranslation(
      customTranslations: customTranslations,
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
    required Map<Locale, ApptiveGridUserManagementTranslation>
        customTranslations,
    required super.child,
  }) {
    final defaultTranslations = <Locale, ApptiveGridUserManagementTranslation>{
      const Locale.fromSubtags(languageCode: 'en'):
          const en.ApptiveGridUserManagementLocalizedTranslation(),
      const Locale.fromSubtags(languageCode: 'de'):
          const de.ApptiveGridUserManagementLocalizedTranslation(),
    };
    _translations.addAll(defaultTranslations);
    _translations.addAll(customTranslations);
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

  // coverage:ignore-start
  @override
  bool updateShouldNotify(
    _InheritedApptiveGridUserManagementTranslation oldWidget,
  ) =>
      !mapEquals(_translations, oldWidget._translations);
// coverage:ignore-end
}
