@TestOn('browser')

import 'package:apptive_grid_web_apptive/apptive_grid_web_apptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Some Test', (tester) async {
    final webApptive =
        ApptiveGridWebApptive(builder: (context, event) => const SizedBox());
    await tester.pumpWidget(webApptive);
  });
}
