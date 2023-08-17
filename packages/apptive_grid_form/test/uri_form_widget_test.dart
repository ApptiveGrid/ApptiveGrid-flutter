import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      FormData(id: 'id', components: [], fields: [], links: {}),
    );
    registerFallbackValue(ApptiveLink(uri: Uri(), method: 'method'));
  });

  late ApptiveGridClient client;

  const field = GridField(id: 'fieldId', name: 'name', type: DataType.uri);
  final submitUri = Uri(path: 'submit');
  final submitLink = ApptiveLink(uri: submitUri, method: 'post');

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async => []);
    when(() => client.submitFormWithProgress(submitLink, any())).thenAnswer(
      (invocation) =>
          Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
    );
  });

  group('Submit Logic', () {
    testWidgets('Has Value, submits form', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              property: 'name',
              required: true,
              data: UriDataEntity(
                Uri.parse('https://apptivegrid.de'),
              ),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      verify(() => client.submitFormWithProgress(submitLink, any())).called(1);
    });

    testWidgets('No Value but required, shows error', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UriDataEntity(),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      verifyNever(() => client.submitFormWithProgress(submitLink, any()));
      expect(
        find.text('name must not be empty', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('Updates Value submits new value', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UriDataEntity(
                Uri.parse('https://something.else'),
              ),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        'https://apptivegrid.de',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(
        capturedForm.components!.first.data.value,
        equals(Uri.parse('https://apptivegrid.de')),
      );
    });

    testWidgets('Sets Value can submit', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UriDataEntity(),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        'https://apptivegrid.de',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(
        capturedForm.components!.first.data.value,
        equals(Uri.parse('https://apptivegrid.de')),
      );
    });

    testWidgets('Sets https as scheme if none typed', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UriDataEntity(),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'apptivegrid.de');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(
        capturedForm.components!.first.data.value,
        predicate<Uri>(
          (uri) => uri.scheme == 'https' && uri.host == 'apptivegrid.de',
        ),
      );
    });

    testWidgets('Empty text gets converted to null', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              property: 'name',
              data: UriDataEntity(
                Uri.parse('https://apptivegrid.de'),
              ),
              field: field,
            ),
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        '',
      ); // Flutter Test replaces text
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(capturedForm.components!.first.data.value, isNull);
    });
  });
}
