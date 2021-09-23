import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Click calls with Action', (tester) async {
    final action = FormAction('uri', 'method');

    final completer = Completer<FormAction>();

    await tester.pumpWidget(
      MaterialApp(
        home: ActionButton(
          action: action,
          onPressed: (clickAction) {
            completer.complete(clickAction);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ActionButton));

    final result = await completer.future;
    expect(result, action);
  });
}
