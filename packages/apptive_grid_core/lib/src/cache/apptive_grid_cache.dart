import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Cache for saving Actions to a cache to enable sending them later
abstract class ApptiveGridCache {
  /// Add [actionItem] to the cache
  FutureOr<void> addPendingActionItem(ActionItem actionItem);

  /// Return a List of all Items added to the cache
  FutureOr<List<ActionItem>> getPendingActionItems();

  /// Should remove [actionItem] from the cache.
  FutureOr<void> removePendingActionItem(ActionItem actionItem);
}
