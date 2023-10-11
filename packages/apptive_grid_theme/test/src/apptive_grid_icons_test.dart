import 'package:alchemist/alchemist.dart';
import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  goldenTest(
    'ApptiveGridIcons',
    fileName: 'apptive-grid-icons',
    builder: () {
      final icons = {
        'Grid': ApptiveGridIcons.grid,
        'Forms': ApptiveGridIcons.form,
        'Kanban': ApptiveGridIcons.kanban,
        'Calendar': ApptiveGridIcons.calendar,
        'Map': ApptiveGridIcons.map,
        'Gallery': ApptiveGridIcons.gallery,
      };
      return GoldenTestGroup(
        columns: 2,
        children: icons.entries
            .map(
              (icon) => GoldenTestScenario(
                name: icon.key,
                child: Icon(
                  icon.value,
                  size: 200,
                ),
              ),
            )
            .toList(),
      );
    },
  );
}
