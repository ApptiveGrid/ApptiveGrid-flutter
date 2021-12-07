import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(title: 'title', components: [], schema: null),
    );
  });

  testWidgets('Options get a chip', (tester) async {
    final component = EnumCollectionFormComponent(
      property: 'Property',
      data: EnumCollectionDataEntity(
        value: {},
        options: {
          'A',
          'B',
        },
      ),
      fieldId: 'fieldId',
    );

    final target = TestApp(
      child: EnumCollectionFormWidget(component: component),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    for (final option in component.data.options) {
      expect(
        find.ancestor(
          of: find.text(option),
          matching: find.byType(ChoiceChip),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('Tapping on chips updates value', (tester) async {
    final component = EnumCollectionFormComponent(
      property: 'Property',
      data: EnumCollectionDataEntity(
        value: {},
        options: {
          'A',
          'B',
        },
      ),
      fieldId: 'fieldId',
    );

    final target = TestApp(
      child: EnumCollectionFormWidget(component: component),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    await tester.tap(find.text('A'));
    await tester.pump();

    expect(component.data.value, {'A'});

    await tester.tap(find.text('A'));
    await tester.pump();

    expect(component.data.value, <String>{});
  });

  testWidgets('Required Status Updates', (tester) async {
    final component = EnumCollectionFormComponent(
      property: 'Property',
      data: EnumCollectionDataEntity(
        value: {},
        options: {
          'A',
          'B',
        },
      ),
      fieldId: 'fieldId',
      required: true,
    );

    final action = FormAction('formAction', 'POST');
    final formData = FormData(
      title: 'title',
      components: [
        component,
      ],
      actions: [action],
      schema: null,
    );
    final client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) => Future.value());
    when(() => client.performAction(action, any()))
        .thenAnswer((_) async => Response('body', 200));
    when(() => client.createAttachmentUrl(any())).thenAnswer(
      (invocation) => Uri.parse('${invocation.positionalArguments.first}.com'),
    );

    final target = TestApp(
      client: client,
      child: ApptiveGridFormData(
        formData: formData,
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ActionButton));
    await tester.pump();

    expect(
      find.text('Property must not be empty', skipOffstage: true),
      findsOneWidget,
    );

    await tester.tap(find.text('A'));
    await tester.pump();
    await tester.tap(find.byType(ActionButton));
    await tester.pump();

    expect(
      find.text('Property must not be empty', skipOffstage: true),
      findsNothing,
    );

    final capturedData =
        verify(() => client.performAction(action, captureAny<FormData>()))
            .captured
            .first as FormData;
    expect(capturedData.components.first.data.value, {'A'});
  });
}
