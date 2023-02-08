import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Icons used for ApptiveGrid.
/// This includes general Icons like [ApptiveGridIcons.more] but also Icons for different ViewTypes
abstract class ApptiveGridIcons {
  ApptiveGridIcons._();

  /// A More Icon
  static const IconData more = MdiIcons.dotsHorizontalCircle;

  /// Icon for Grids
  static const IconData grid = MdiIcons.table;

  /// Icon for Forms
  static const IconData form = MdiIcons.formTextbox;

  /// Icon for Kanban Boards
  static const IconData kanban = MdiIcons.trello;

  /// Icon for Calendar
  static const IconData calendar = MdiIcons.calendar;

  /// Icon for Map Views
  static const IconData map = MdiIcons.googleMaps;
}
