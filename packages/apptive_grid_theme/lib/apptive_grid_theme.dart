library apptive_grid_theme;

import 'dart:io';

import 'package:flutter/material.dart';

import 'apptive_grid_colors.dart';

/// The Apptive Grid Theme
///
/// A theme for all colors and fonts used in Apptive Grid apps
class ApptiveGridTheme {
  static const Color _lightWindowBackground = Color(0xFFF7F7F7);

  Color get _darkWindowBackground {
    if (Platform.isIOS) {
      return Colors.black;
    } else {
      return const Color(0xFF282625);
    }
  }

  /// Creates the theme
  ThemeData theme({Brightness brightness = Brightness.light}) {
    final baseTheme =
        brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
    final textTheme = _textTheme(baseTheme.textTheme, brightness);

    return baseTheme.copyWith(
        primaryColor: ApptiveGridColors.apptiveGridBlue,
        colorScheme: baseTheme.colorScheme.copyWith(
            primary: ApptiveGridColors.apptiveGridBlue,
            secondary: ApptiveGridColors.apptiveGridBlue),
        toggleableActiveColor: ApptiveGridColors.apptiveGridBlue,
        textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
            selectionHandleColor: ApptiveGridColors.apptiveGridBlue,
            selectionColor: ApptiveGridColors.apptiveGridBlue.withOpacity(0.4)),
        buttonTheme: baseTheme.buttonTheme.copyWith(
          buttonColor: ApptiveGridColors.apptiveGridBlue,
          textTheme: ButtonTextTheme.primary,
        ),
        hintColor: ApptiveGridColors.lightGrey.withOpacity(0.8),
        inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
          filled: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ApptiveGridColors.apptiveGridBlue,
              ),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ApptiveGridColors.apptiveGridBlue,
              ),
              borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: baseTheme.errorColor,
              ),
              borderRadius: BorderRadius.circular(8)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: baseTheme.errorColor,
              ),
              borderRadius: BorderRadius.circular(8)),
        ),
        dialogTheme: baseTheme.dialogTheme.copyWith(
          titleTextStyle: textTheme.headline6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        scaffoldBackgroundColor: brightness == Brightness.dark
            ? _darkWindowBackground
            : _lightWindowBackground,
        textTheme: textTheme,
        cardTheme: baseTheme.cardTheme.copyWith(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          color: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          actionsIconTheme: const IconThemeData(
            color: ApptiveGridColors.apptiveGridBlue,
          ),
          iconTheme: IconThemeData(
              color: brightness == Brightness.dark
                  ? Colors.white
                  : ApptiveGridColors.darkGrey),
          brightness: brightness,
          textTheme: textTheme,
        ));
  }

  TextTheme _textTheme(TextTheme baseTheme, Brightness brightness) {
    final newTheme = baseTheme.copyWith(
        bodyText1: const TextStyle(
          fontSize: 14,
        ),
        headline3: const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.bold,
        ),
        headline5: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headline6: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ));
    return newTheme.apply(
      bodyColor: brightness == Brightness.dark
          ? Colors.white54
          : ApptiveGridColors.lightGrey,
      displayColor: brightness == Brightness.dark
          ? Colors.white
          : ApptiveGridColors.darkGrey,
      fontFamily: 'DMSans',
    );
  }
}
