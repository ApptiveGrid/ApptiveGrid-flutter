import 'dart:async';

import 'package:active_grid_core/active_grid_model.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Click calls with Action', (tester) async {
    final action = FormAction('uri', 'method');

    final completer = Completer<FormAction>();

    await tester.pumpWidget(MaterialApp(
      home: ActionButton(
          action: action,
          onPressed: (clickAction) {
            completer.complete(clickAction);
          }),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ActionButton));

    final result = await completer.future;
    expect(result, action);
  });
}
