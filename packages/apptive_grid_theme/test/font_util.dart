import 'package:flutter/material.dart';

extension GoldenThemeX on ThemeData {
  ThemeData stripFontPackages() {
    final baseTextTheme = textTheme;

    final strippedTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge!.forGoldens,
      displayMedium: baseTextTheme.displayMedium!.forGoldens,
      displaySmall: baseTextTheme.displaySmall!.forGoldens,
      headlineLarge: baseTextTheme.headlineLarge!.forGoldens,
      headlineMedium: baseTextTheme.headlineMedium!.forGoldens,
      headlineSmall: baseTextTheme.headlineSmall!.forGoldens,
      bodyLarge: baseTextTheme.bodyLarge!.forGoldens,
      bodyMedium: baseTextTheme.bodyMedium!.forGoldens,
      bodySmall: baseTextTheme.bodySmall!.forGoldens,
      titleLarge: baseTextTheme.titleLarge!.forGoldens,
      titleMedium: baseTextTheme.titleMedium!.forGoldens,
      titleSmall: baseTextTheme.titleSmall!.forGoldens,
      labelLarge: baseTextTheme.labelLarge!.forGoldens,
      labelMedium: baseTextTheme.labelMedium!.forGoldens,
      labelSmall: baseTextTheme.labelSmall!.forGoldens,
    );

    return copyWith(
      textTheme: strippedTextTheme,
    );
  }
}

extension _GoldenTextStyle on TextStyle {
  TextStyle get forGoldens {
    final familySplit = fontFamily?.split('/');
    final rawFamily = familySplit?.last;

    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      package: null,
      fontFamily: rawFamily,
      fontFamilyFallback: const ['Roboto'],
    );
  }
}
