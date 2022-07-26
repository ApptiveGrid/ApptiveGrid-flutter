import 'package:flutter/material.dart';

/// Colors used by the [ApptiveGridTheme]
abstract class ApptiveGridColors {
  /// Empty private constructor to prevent IDE Autocomplete
  ApptiveGridColors._();

  /// This is the primary color of ApptiveGrid with the hex code: FF1565C0
  static const Color apptiveGridBlue = Color(0xff1565c0);

  /// This is the default light grey color with the hex code: FF898989
  static const Color lightGrey = Color(0xFF898989);

  /// This is the default dark grey color with the hex code: FF4B4846
  static const Color darkGrey = Color(0xFF4B4846);

  /// This is a color used to identify GridViews with the hex code: FF1664C0
  static const Color grid = Color(0xFF1664C0);

  /// This is a color used to identify FormViews with the hex code: FFE54B4B
  static const Color form = Color(0xFFE54B4B);

  /// This is a color used to identify Kanban Boards with the hex code: 189e27
  static const Color kanban = Color(0xff189e27);

  /// This is a color used to identify Calendar Views with the hex code: fc9f02
  static const Color calendar = Color(0xfffc9f02);
}
