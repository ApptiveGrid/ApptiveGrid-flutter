import 'dart:async';

import 'package:active_grid_form/active_grid_form.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';
import 'package:active_grid_core/active_grid_model.dart';
import 'package:http/http.dart' as http;

import 'common.dart';

void main() {
  group('Title', () {
    testWidgets('Title Displays', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
        ),
      );

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form'))).thenAnswer(
          (realInvocation) async => FormData('Form Title', [], [], {}));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsOneWidget);
    });

    testWidgets('Title do not displays', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
          hideTitle: true,
        ),
      );

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form'))).thenAnswer(
          (realInvocation) async => FormData('Form Title', [], [], {}));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsNothing);
    });
  });

  testWidgets('OnLoadedCallback gets called', (tester) async {
    final client = MockActiveGridClient();
    final form = FormData('Form Title', [], [], {});
    final completer = Completer<FormData>();
    final target = TestApp(
      client: client,
      child: ActiveGridForm(
        formUri:
        FormUri.fromRedirectUri(
          form: 'form',
        ),
        onFormLoaded: (data) {
          completer.complete(data);
        },
      ),
    );

    when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
        .thenAnswer((realInvocation) async => form);

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    final result = await completer.future;
    expect(result, form);
  });

  group('Loading', () {
    testWidgets('Initial shows Loading', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
        ),
      );
      final form = FormData('Form Title', [], [], {});
      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
          .thenAnswer((realInvocation) async => form);

      await tester.pumpWidget(target);

      expect(
          find.byType(
            CircularProgressIndicator,
          ),
          findsOneWidget);
    });
  });

  group('Success', () {
    testWidgets('Shows Success', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData('Form Title', [], [action], {});

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
          .thenAnswer((realInvocation) async => formData);
      when(() => client.performAction(action, formData))
          .thenAnswer((_) async => http.Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Send Additional Click reloads Form', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData('Form Title', [], [action], {});

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
          .thenAnswer((realInvocation) async => formData);
      when(() => client.performAction(action, formData))
          .thenAnswer((_) async => http.Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(TextButton), 100);
      await tester.tap(find.byType(TextButton, skipOffstage: false));
      await tester.pumpAndSettle();

      verify(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form'))).called(2);
    });
  });

  group('Error', () {
    group('Initial Call', () {
      testWidgets('Initial Error Shows', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formUri:
            FormUri.fromRedirectUri(
              form: 'form',
            ),
          ),
        );

        when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle(Duration(seconds: 30));

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Initial Error Reloads Form', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formUri:
            FormUri.fromRedirectUri(
              form: 'form',
            ),
          ),
        );
        when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        verify(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form'))).called(2);
      });
    });

    group('Action Error', () {
      testWidgets('Shows Error', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formUri:
            FormUri.fromRedirectUri(
              form: 'form',
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData('Form Title', [], [action], {});

        when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
            .thenAnswer((realInvocation) async => formData);
        when(() => client.performAction(action, formData))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Server Error shows Error', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formUri:
            FormUri.fromRedirectUri(
              form: 'form',
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData('Form Title', [], [action], {});

        when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
            .thenAnswer((realInvocation) async => formData);
        when(() => client.performAction(action, formData))
            .thenAnswer((_) async => http.Response('', 500));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Back to Form shows Form', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formUri:
            FormUri.fromRedirectUri(
              form: 'form',
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData('Form Title', [], [action], {});

        when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
            .thenAnswer((realInvocation) async => formData);
        when(() => client.performAction(action, formData))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        expect(find.text('Form Title'), findsOneWidget);
      });
    });
  });

  group('Skip Custom Builder', () {
    testWidgets('Shows Success', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
          onActionSuccess: (action) async {
            return false;
          },
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData('Form Title', [], [action], {});

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
          .thenAnswer((realInvocation) async => formData);
      when(() => client.performAction(action, formData))
          .thenAnswer((_) async => http.Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsNothing);
    });

    testWidgets('Shows Error', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formUri:
          FormUri.fromRedirectUri(
            form: 'form',
          ),
          onError: (error) async {
            return false;
          },
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData('Form Title', [], [action], {});

      when(() => client.loadForm(formUri: FormUri.fromRedirectUri(form: 'form')))
          .thenAnswer((realInvocation) async => formData);
      when(() => client.performAction(action, formData))
          .thenAnswer((_) => Future.error(''));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsNothing);
    });
  });
}
