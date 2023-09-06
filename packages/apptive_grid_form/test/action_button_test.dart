import 'dart:async';

import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Click calls back', (tester) async {
    final completer = Completer();

    await tester.pumpWidget(
      MaterialApp(
        home: ActionButton(
          onPressed: () {
            completer.complete();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ActionButton));

    await completer.future;
    expect(completer.isCompleted, true);
  });
}
