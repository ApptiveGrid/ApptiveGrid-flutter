import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  testWidgets('Multiline TextFormWidget Displays', (tester) async {
    const value = '''A
multi-line
string''';
    final target = TextFormWidget(
        component: StringFormComponent(
            property: 'Text',
            data: StringDataEntity(
              value,
            ),
            options: TextComponentOptions(
              multi: true,
            ),
            fieldId: 'Field'));

    await tester.pumpWidget(TestApp(
      child: target,
    ));
    await tester.pumpAndSettle();

    expect(find.text(value), findsOneWidget);
  });
}
