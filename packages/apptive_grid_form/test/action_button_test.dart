// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Click calls back', (tester) async {
    final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');

    final completer = Completer<ApptiveLink>();

    await tester.pumpWidget(
      MaterialApp(
        home: ActionButton(
          action: action,
          onPressed: (link) {
            completer.complete(link);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ActionButton));

    final result = await completer.future;
    expect(result, equals(action));
    await completer.future;
    expect(completer.isCompleted, true);
  });
}
