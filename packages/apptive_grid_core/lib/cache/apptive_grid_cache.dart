import 'package:apptive_grid_core/apptive_grid_model.dart';

abstract class ApptiveGridCache {
  Future<void> saveForm(FormUri uri, FormData formData);
  Future<FormData?> getForm(FormUri uri);
  Future<void> removeForm(FormUri uri);

  Future<void> saveGrid(GridUri uri, Grid grid);
  Future<Grid?> getGrid(GridUri uri);
  Future<void> removeGrid(GridUri uri);

  Future<void> saveSpace(SpaceUri uri, Space space);
  Future<Space?> getSpace(SpaceUri uri);
  Future<void> removeSpace(SpaceUri uri);

  Future<void> saveActionItem(ActionItem actionItem);
  Future<List<ActionItem>> getActionItems();
  Future<void> removeActionItem(ActionItem actionItem);
}