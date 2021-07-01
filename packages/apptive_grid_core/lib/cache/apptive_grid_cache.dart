import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_model.dart';

abstract class ApptiveGridCache {
  FutureOr<void> addPendingActionItem(ActionItem actionItem);
  FutureOr<List<ActionItem>> getPendingActionItems();
  FutureOr<void> removePendingActionItem(ActionItem actionItem);
}