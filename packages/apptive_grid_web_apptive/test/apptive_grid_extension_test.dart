import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptive_grid_web_apptive/apptive_grid_web_apptive.dart';

void main() {
  testWidgets('Some Test', (tester) async {
    final webApptive =
        ApptiveGridWebApptive(builder: (context, event) => SizedBox());
    await tester.pumpWidget(webApptive);
  });
}
