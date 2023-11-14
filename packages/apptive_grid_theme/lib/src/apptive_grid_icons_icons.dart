import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Icons used for ApptiveGrid.
/// This includes general Icons like [ApptiveGridIcons.more] but also Icons for different ViewTypes
abstract class ApptiveGridIcons {
  ApptiveGridIcons._();

  /// A More Icon
  static final IconData more = MdiIcons.dotsHorizontalCircle;

  /// Icon for Grids
  static final IconData grid = MdiIcons.table;

  /// Icon for Forms
  static final IconData form = MdiIcons.formTextbox;

  /// Icon for Kanban Boards
  static final IconData kanban = MdiIcons.trello;

  /// Icon for Calendar
  static final IconData calendar = MdiIcons.calendar;

  /// Icon for Map Views
  static final IconData map = MdiIcons.googleMaps;

  /// Icon for Gallery Views
  static final IconData gallery = MdiIcons.viewGrid;
}
