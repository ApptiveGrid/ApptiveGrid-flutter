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
      light: ThemeData.light(),
      dark: ThemeData.dark(),
    );
    final textTheme = _textTheme(baseTheme.textTheme);

    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
    final baseButtonStyle = ButtonStyle(
      shape: WidgetStateProperty.all(buttonShape),
    );

    final colorScheme = ColorScheme.fromSeed(
      primary: ApptiveGridColors.apptiveGridBlue,
      secondary: ApptiveGridColors.apptiveGridBlue,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: windowBackground,
      seedColor: windowBackground,
      // `onSurface` is the colour of content drawn *on* `surface`, so it must
      // contrast with it. It used to be `windowBackground` — the same value as
      // `surface` — which left anything reading the token invisible: the time
      // picker's dial numbers and unselected field, and the date picker's day
      // grid, all rendered near-white on near-white.
      onSurface: _withBrightness(
        light: _lightOnSurface,
        dark: _darkOnSurface,
      ),
      // `fromSeed` derives the container roles from `seedColor`, which here is
      // the window background rather than the brand colour passed as
      // `primary`. Selected states therefore picked up a hue unrelated to
      // ApptiveGrid — a turquoise hour field in the time picker. Tie them back
      // to the brand blue.
      primaryContainer: _withBrightness(
        light: _lightPrimaryContainer,
        dark: _darkPrimaryContainer,
      ),
      onPrimaryContainer: _withBrightness(
        light: ApptiveGridColors.apptiveGridBlue,
        dark: _lightPrimaryContainer,
      ),
    );

    return baseTheme.copyWith(
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      canvasColor: windowBackground,
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionHandleColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.4),
      ),
      buttonTheme: baseTheme.buttonTheme.copyWith(
        buttonColor: colorScheme.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
        surfaceTintColor: windowBackground,
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        shape: const CircleBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return ApptiveGridColors.lightGrey;
            } else {
              return colorScheme.onPrimary;
            }
          }),
          backgroundColor: WidgetStateProperty.resolveWith(_resolveButtonColor),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return ApptiveGridColors.lightGrey;
            } else {
              return colorScheme.primary;
            }
          }),
          side: WidgetStateProperty.resolveWith((states) {
            final color = _resolveButtonColor(states);
            late final double width;
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              width = 3;
            } else {
              width = 1;
            }
            return BorderSide(color: color, width: width);
          }),
        ),
      ),
      hintColor: ApptiveGridColors.lightGrey.withValues(alpha: 0.8),
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        indicatorColor: colorScheme.primary,
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
        backgroundColor: windowBackground,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        trackColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
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

  Color _resolveButtonColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return ApptiveGridColors.lightGrey.withValues(
        alpha: _withBrightness(
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

/// Content colour on light surfaces. Near-black rather than pure black, to
/// match the tone the text theme already uses.
const _lightOnSurface = Color(0xFF212121);

/// Content colour on dark surfaces.
const _darkOnSurface = Color(0xFFF2F2F2);

/// Tinted surface for selected states on a light background, derived from
/// [ApptiveGridColors.apptiveGridBlue].
const _lightPrimaryContainer = Color(0xFFD6E3F7);

/// Tinted surface for selected states on a dark background.
const _darkPrimaryContainer = Color(0xFF0D3C75);
