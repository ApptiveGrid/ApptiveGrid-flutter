import 'package:apptive_grid_theme/src/apptive_grid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

/// The ApptiveGrid Theme
///
/// A theme for all colors and fonts used in ApptiveGrid apps
class ApptiveGridTheme {
  ApptiveGridTheme._({required this.brightness});

  /// Initializes the theme with a given [brightness]
  static ThemeData create({Brightness brightness = Brightness.light}) {
    final theme = ApptiveGridTheme._(brightness: brightness);
    return theme._theme;
  }

  /// Creates a light [ApptiveGridTheme]
  static ThemeData light() {
    return ApptiveGridTheme.create(brightness: Brightness.light);
  }

  /// Creates a dark [ApptiveGridTheme]
  static ThemeData dark() {
    return ApptiveGridTheme.create(brightness: Brightness.dark);
  }

  /// The brightness of the theme
  final Brightness brightness;

  /// Creates the theme
  ThemeData get _theme {
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
    final baseTheme = _withBrightness(
      light: ThemeData.light(useMaterial3: false),
      dark: ThemeData.dark(useMaterial3: false),
    );
    final textTheme = _textTheme(baseTheme.textTheme);

    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
    final baseButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(buttonShape),
    );

    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: ApptiveGridColors.apptiveGridBlue,
      secondary: ApptiveGridColors.apptiveGridBlue,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      background: windowBackground,
    );
    return baseTheme.copyWith(
      primaryColor: colorScheme.primary,
      indicatorColor: colorScheme.primary,
      colorScheme: colorScheme,
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionHandleColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.4),
      ),
      buttonTheme: baseTheme.buttonTheme.copyWith(
        buttonColor: colorScheme.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return ApptiveGridColors.lightGrey;
            } else {
              return colorScheme.onPrimary;
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
              return colorScheme.primary;
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
        labelColor: colorScheme.primary,
        unselectedLabelColor: _withBrightness(
          light: ApptiveGridColors.lightGrey,
          dark: Colors.white54,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: textTheme.titleMedium,
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
        actionsIconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        foregroundColor: _withBrightness(
          light: ApptiveGridColors.darkGrey,
          dark: Colors.white,
        ),
        systemOverlayStyle: _withBrightness(
          light: SystemUiOverlayStyle.dark,
          dark: SystemUiOverlayStyle.light,
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        selectedColor: colorScheme.primary,
        labelStyle:
            textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
        secondaryLabelStyle: textTheme.labelMedium!.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        secondarySelectedColor: colorScheme.primary,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        titleTextStyle: baseTheme.textTheme.titleMedium,
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
        fontWeight: FontWeight.w400,
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
