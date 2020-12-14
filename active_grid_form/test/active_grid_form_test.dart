import 'package:active_grid_form/active_grid_form.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:active_grid_core/active_grid_model.dart' as model;
import 'package:http/http.dart' as http;

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

      when(client.loadForm(formId: 'form')).thenAnswer(
          (realInvocation) async => model.FormData('Form Title', [], [], {}));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsOneWidget);
    });

    testWidgets('Title do not displays', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formId: 'form',
          hideTitle: true,
        ),
      );

      when(client.loadForm(formId: 'form')).thenAnswer(
          (realInvocation) async => model.FormData('Form Title', [], [], {}));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsNothing);
    });
  });

  group('Loading', () {
    testWidgets('Initial shows Loading', (tester) async {
      final target = TestApp(
        child: ActiveGridForm(
          formId: 'form',
        ),
      );

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
          formId: 'form',
        ),
      );
      final action = model.FormAction('uri', 'method');
      final formData = model.FormData('Form Title', [], [action], {});

      when(client.loadForm(formId: 'form'))
          .thenAnswer((realInvocation) async => formData);
      when(client.performAction(action, formData))
          .thenAnswer((_) async => http.Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(FlatButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Send Additional Click reloads Form', (tester) async {
      final client = MockActiveGridClient();
      final target = TestApp(
        client: client,
        child: ActiveGridForm(
          formId: 'form',
        ),
      );
      final action = model.FormAction('uri', 'method');
      final formData = model.FormData('Form Title', [], [action], {});

      when(client.loadForm(formId: 'form'))
          .thenAnswer((realInvocation) async => formData);
      when(client.performAction(action, formData))
          .thenAnswer((_) async => http.Response('', 200));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(FlatButton), 100);
      await tester.tap(find.byType(FlatButton, skipOffstage: false));
      await tester.pumpAndSettle();

      verify(client.loadForm(formId: 'form')).called(2);
    });
  });

  group('Error', () {
    group('Initial Call', () {
      testWidgets('Initial Error Shows', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formId: 'form',
          ),
        );

        when(client.loadForm(formId: 'form'))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle(Duration(seconds: 30));

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(FlatButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Initial Error Reloads Form', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formId: 'form',
          ),
        );
        when(client.loadForm(formId: 'form'))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(FlatButton), 100);
        await tester.tap(find.byType(FlatButton, skipOffstage: false));
        await tester.pumpAndSettle();

        verify(client.loadForm(formId: 'form')).called(2);
      });
    });

    group('Action Error', () {
      testWidgets('Shows Error', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formId: 'form',
          ),
        );
        final action = model.FormAction('uri', 'method');
        final formData = model.FormData('Form Title', [], [action], {});

        when(client.loadForm(formId: 'form'))
            .thenAnswer((realInvocation) async => formData);
        when(client.performAction(action, formData))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(FlatButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Server Error shows Error', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formId: 'form',
          ),
        );
        final action = model.FormAction('uri', 'method');
        final formData = model.FormData('Form Title', [], [action], {});

        when(client.loadForm(formId: 'form'))
            .thenAnswer((realInvocation) async => formData);
        when(client.performAction(action, formData))
            .thenAnswer((_) async => http.Response('', 500));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(FlatButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Back to Form shows Form', (tester) async {
        final client = MockActiveGridClient();
        final target = TestApp(
          client: client,
          child: ActiveGridForm(
            formId: 'form',
          ),
        );
        final action = model.FormAction('uri', 'method');
        final formData = model.FormData('Form Title', [], [action], {});

        when(client.loadForm(formId: 'form'))
            .thenAnswer((realInvocation) async => formData);
        when(client.performAction(action, formData))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(FlatButton), 100);
        await tester.tap(find.byType(FlatButton, skipOffstage: false));
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
          formId: 'form',
          onActionSuccess: (action) async {
            return false;
          },
        ),
      );
      final action = model.FormAction('uri', 'method');
      final formData = model.FormData('Form Title', [], [action], {});

      when(client.loadForm(formId: 'form'))
          .thenAnswer((realInvocation) async => formData);
      when(client.performAction(action, formData))
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
          formId: 'form',
          onError: (error) async {
            return false;
          },
        ),
      );
      final action = model.FormAction('uri', 'method');
      final formData = model.FormData('Form Title', [], [action], {});

      when(client.loadForm(formId: 'form'))
          .thenAnswer((realInvocation) async => formData);
      when(client.performAction(action, formData))
          .thenAnswer((_) => Future.error(''));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsNothing);
    });
  });
}
