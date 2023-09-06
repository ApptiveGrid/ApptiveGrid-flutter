import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const field = CurrencyGridField(id: 'fieldId', name: 'name', currency: 'EUR');
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
              data: CurrencyDataEntity(
                value: 10,
                currency: 'EUR',
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

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.submitFormWithProgress(
          submitLink,
          any(
            that: predicate<FormData>(
              (formData) => formData.components!.first.data.value == 10,
            ),
          ),
        ),
      ).called(1);
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
              data: CurrencyDataEntity(
                currency: 'EUR',
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

      await tester.tap(find.byType(ElevatedButton));
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
              data: CurrencyDataEntity(
                value: 10,
                currency: 'EUR',
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

      expect(find.text('€10.00'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '9');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.submitFormWithProgress(
          submitLink,
          any(
            that: predicate<FormData>(
              (formData) => formData.components!.first.data.value == 0.09,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('Clearing field submits empty value', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              property: 'name',
              required: false,
              data: CurrencyDataEntity(
                value: 10,
                currency: 'EUR',
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

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.submitFormWithProgress(
          submitLink,
          any(
            that: predicate<FormData>(
              (formData) => formData.components!.first.data.value == null,
            ),
          ),
        ),
      ).called(1);
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
              data: CurrencyDataEntity(
                currency: 'EUR',
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

      await tester.enterText(find.byType(TextFormField), '9');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => client.submitFormWithProgress(
          submitLink,
          any(
            that: predicate<FormData>(
              (formData) => formData.components!.first.data.value == 0.09,
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('Locale', () {
    testWidgets('Formats Value based on Locale', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: CurrencyDataEntity(
                value: 10,
                currency: 'EUR',
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
        locale: const Locale('de', 'DE'),
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('10,00 €'), findsOneWidget);
    });
  });
}
