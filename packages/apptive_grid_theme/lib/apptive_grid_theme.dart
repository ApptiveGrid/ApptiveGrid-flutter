library apptive_grid_theme;

import 'package:apptive_grid_theme/apptive_grid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

export 'package:apptive_grid_theme/apptive_grid_colors.dart';
export 'package:apptive_grid_theme/apptive_grid_icons_icons.dart';

/// The ApptiveGrid Theme
///
/// A theme for all colors and fonts used in ApptiveGrid apps
class ApptiveGridTheme {
  /// Initializes the theme with a give brightness
  ApptiveGridTheme({required this.brightness});

  /// The brightness of the theme
  final Brightness brightness;

  /// Creates the theme
  ThemeData theme() {
    late final Color darkWindowBackground;
    if (UniversalPlatform.isIOS) {
      darkWindowBackground = Colors.black;
    } else {
      darkWindowBackground = const Color(0xFF282625);
    }
    final windowBackground = _withBrightness(
      light: const Color(0xFFF7F7F7),
      dark: darkWindowBackground,
    );
    final baseTheme =
        _withBrightness(light: ThemeData.light(), dark: ThemeData.dark());
    final textTheme = _textTheme(baseTheme.textTheme);

    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
    final baseButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(buttonShape),
    );

    return baseTheme.copyWith(
      primaryColor: ApptiveGridColors.apptiveGridBlue,
      indicatorColor: ApptiveGridColors.apptiveGridBlue,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: ApptiveGridColors.apptiveGridBlue,
        secondary: ApptiveGridColors.apptiveGridBlue,
      ),
      toggleableActiveColor: ApptiveGridColors.apptiveGridBlue,
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionHandleColor: ApptiveGridColors.apptiveGridBlue,
        selectionColor: ApptiveGridColors.apptiveGridBlue.withOpacity(0.4),
      ),
      buttonTheme: baseTheme.buttonTheme.copyWith(
        buttonColor: ApptiveGridColors.apptiveGridBlue,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return ApptiveGridColors.lightGrey;
            } else {
              return Colors.white;
            }
          }),
          backgroundColor:
              MaterialStateProperty.resolveWith(_resolveButtonColor),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return ApptiveGridColors.lightGrey;
            } else {
              return ApptiveGridColors.apptiveGridBlue;
            }
          }),
          side: MaterialStateProperty.resolveWith((states) {
            final color = _resolveButtonColor(states);
            late final double width;
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              width = 3;
            } else {
              width = 1;
            }
            return BorderSide(color: color, width: width);
          }),
        ),
      ),
      hintColor: ApptiveGridColors.lightGrey.withOpacity(0.8),
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        labelColor: ApptiveGridColors.apptiveGridBlue,
        unselectedLabelColor: _withBrightness(
          light: ApptiveGridColors.lightGrey,
          dark: Colors.white54,
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ApptiveGridColors.apptiveGridBlue,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ApptiveGridColors.apptiveGridBlue,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: baseTheme.errorColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: baseTheme.errorColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      scaffoldBackgroundColor: windowBackground,
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
          color: _withBrightness(
            light: ApptiveGridColors.darkGrey,
            dark: Colors.white,
          ),
        ),
        systemOverlayStyle: _withBrightness(
          light: SystemUiOverlayStyle.dark,
          dark: SystemUiOverlayStyle.light,
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        selectedColor: ApptiveGridColors.apptiveGridBlue,
        secondaryLabelStyle: baseTheme.chipTheme.secondaryLabelStyle
            ?.copyWith(color: Colors.white),
        secondarySelectedColor: ApptiveGridColors.apptiveGridBlue,
      ),
    );
  }

  TextTheme _textTheme(TextTheme baseTheme) {
    const fontPackage = 'apptive_grid_theme';
    const theme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        package: fontPackage,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        package: fontPackage,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        package: fontPackage,
      ),
      headlineLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        package: fontPackage,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        package: fontPackage,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        package: fontPackage,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        package: fontPackage,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        package: fontPackage,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        package: fontPackage,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        package: fontPackage,
        letterSpacing: 1.4,
      ),
    );
    return theme.apply(
      bodyColor: _withBrightness(
        light: ApptiveGridColors.lightGrey,
        dark: Colors.white54,
      ),
      displayColor: _withBrightness(
        light: ApptiveGridColors.darkGrey,
        dark: Colors.white,
      ),
      fontFamily: 'DMSans',
    );
  }

  Color _resolveButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return ApptiveGridColors.lightGrey.withOpacity(
        _withBrightness(
          light: 0.3,
          dark: 0.3,
        ),
      );
    }
    return ApptiveGridColors.apptiveGridBlue;
  }

  T _withBrightness<T>({required T light, required T dark}) {
    if (brightness == Brightness.dark) {
      return dark;
    } else {
      return light;
    }
  }
}
