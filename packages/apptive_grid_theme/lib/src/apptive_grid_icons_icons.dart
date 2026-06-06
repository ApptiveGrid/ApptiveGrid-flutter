import 'package:flutter/widgets.dart';

/// Icons used for ApptiveGrid.
/// This includes general Icons like [ApptiveGridIcons.more] but also Icons for different ViewTypes
abstract class ApptiveGridIcons {
  ApptiveGridIcons._();

  static const _fontFamily = 'Material Design Icons';
  static const _fontPackage = 'apptive_grid_theme';

  /// A More Icon
  static const IconData more = IconData(
    0xf07c3,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Grids
  static const IconData grid = IconData(
    0xf04eb,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Forms
  static const IconData form = IconData(
    0xf060e,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Kanban Boards
  static const IconData kanban = IconData(
    0xf0532,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Calendar
  static const IconData calendar = IconData(
    0xf00ed,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Map Views
  static const IconData map = IconData(
    0xf05f5,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );

  /// Icon for Gallery Views
  static const IconData gallery = IconData(
    0xf0570,
    fontFamily: _fontFamily,
    fontPackage: _fontPackage,
  );
}
