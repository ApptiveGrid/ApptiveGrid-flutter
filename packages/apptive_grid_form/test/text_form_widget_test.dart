import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FormData(title: 'title', components: [], schema: {}));
  });

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
        options: const TextComponentOptions(
          multi: true,
        ),
        fieldId: 'Field',
      ),
    );

    await tester.pumpWidget(
      TestApp(
        child: target,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(value), findsOneWidget);
  });

  testWidgets('Multiline TextFormWidget Displays in FormData Widget',
      (tester) async {
    const value = '''A
multi-line
string''';
    final formData = FormData(
      title: 'Title',
      components: [
        StringFormComponent(
          property: 'Text',
          data: StringDataEntity(
            value,
          ),
          options: const TextComponentOptions(
            multi: true,
          ),
          fieldId: 'Field',
        ),
      ],
      schema: null,
    );

    final target = ApptiveGridFormData(
      formData: formData,
    );

    await tester.pumpWidget(
      TestApp(
        child: target,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(value), findsOneWidget);
  });

  group('Validation', () {
    testWidgets('is required but filled sends', (tester) async {
      final action = FormAction('formAction', 'POST');
      final formData = FormData(
        title: 'title',
        components: [
          StringFormComponent(
            property: 'Property',
            data: StringDataEntity('Value'),
            fieldId: 'fieldId',
            required: true,
          )
        ],
        actions: [action],
        schema: null,
      );
      final client = MockApptiveGridClient();
      when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
      when(() => client.performAction(action, any()))
          .thenAnswer((_) async => Response('body', 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });
}
