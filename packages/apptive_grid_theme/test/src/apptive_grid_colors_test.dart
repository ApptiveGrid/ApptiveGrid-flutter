import 'package:alchemist/alchemist.dart';
import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:flutter/cupertino.dart';

void main() {
  goldenTest(
    'ApptiveGridColors',
    fileName: 'apptive-grid-colors',
    builder: () {
      final colors = {
        'Grid': ApptiveGridColors.grid,
        'Forms': ApptiveGridColors.form,
        'Kanban': ApptiveGridColors.kanban,
        'Calendar': ApptiveGridColors.calendar,
        'Map': ApptiveGridColors.map,
      };
      return GoldenTestGroup(
        columns: 2,
        children: colors.entries
            .map(
              (color) => GoldenTestScenario(
                name: color.key,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: ColoredBox(
                    color: color.value,
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}
