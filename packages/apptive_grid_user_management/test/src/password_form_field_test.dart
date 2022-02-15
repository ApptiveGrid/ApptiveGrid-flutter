import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../infrastructure/test_app.dart';

void main() {
  testWidgets('Toggle Password Obscuring', (tester) async {
    await tester
        .pumpWidget(const StubUserManagement(child: PasswordFormField()));
    await tester.pumpAndSettle();

    expect(
        (tester.widget(find.descendant(
                of: find.byType(PasswordFormField),
                matching: find.byType(TextField))) as TextField)
            .obscureText,
        true);
    await tester.tap(find.byIcon(Icons.visibility, skipOffstage: false).first);
    await tester.pump();

    expect(
        (tester.widget(find.descendant(
                of: find.byType(PasswordFormField),
                matching: find.byType(TextField))) as TextField)
            .obscureText,
        false);

    await tester
        .tap(find.byIcon(Icons.visibility_off, skipOffstage: false).first);
    await tester.pump();

    expect(
        (tester.widget(find.descendant(
                of: find.byType(PasswordFormField),
                matching: find.byType(TextField))) as TextField)
            .obscureText,
        true);
  });
}
