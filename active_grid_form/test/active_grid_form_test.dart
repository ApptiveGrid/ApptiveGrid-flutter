import 'package:active_grid_form/active_grid_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:active_grid_core/active_grid_model.dart' as model;

import 'common.dart';

void main() {

  group('Title', () {
    testWidgets('Title Displays', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formId: 'form',
        ),
      );

      when(client.loadForm(formId: 'form')).thenAnswer((realInvocation) async => model.FormData('Form Title', [], [], {}));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsOneWidget);
    });
  });

}
