import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Icons used for ApptiveGrid.
/// This includes general Icons like [ApptiveGridIcons.more] but also Icons for different ViewTypes
abstract class ApptiveGridIcons {
  ApptiveGridIcons._();

  /// A More Icon
  static IconData more = MdiIcons.dotsHorizontalCircle;

  /// Icon for Grids
  static IconData grid = MdiIcons.table;

  /// Icon for Forms
  static IconData form = MdiIcons.formTextbox;

  /// Icon for Kanban Boards
  static IconData kanban = MdiIcons.trello;

  /// Icon for Calendar
  static IconData calendar = MdiIcons.calendar;

  /// Icon for Map Views
  static IconData map = MdiIcons.googleMaps;
}
