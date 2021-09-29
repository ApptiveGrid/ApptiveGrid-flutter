import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  late ApptiveGridClient client;

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async {});
  });

  group('Title', () {
    testWidgets('Title Displays', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
        ),
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
          .thenAnswer(
        (realInvocation) async => FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [],
          schema: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsOneWidget);
    });

    testWidgets('Title do not displays', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
          hideTitle: true,
        ),
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
          .thenAnswer(
        (realInvocation) async => FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [],
          schema: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsNothing);
    });
  });

  testWidgets('OnLoadedCallback gets called', (tester) async {
    final form = FormData(
      name: 'Form Name',
      title: 'Form Title',
      components: [],
      actions: [],
      schema: {},
    );
    final completer = Completer<FormData>();
    final target = TestApp(
      client: client,
      child: ApptiveGridForm(
        formUri: RedirectFormUri(
          components: ['form'],
        ),
        onFormLoaded: (data) {
          completer.complete(data);
        },
      ),
    );

    when(() => client.loadForm(formUri: RedirectFormUri(components: ['form'])))
        .thenAnswer((realInvocation) async => form);

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    final result = await completer.future;
    expect(result, form);
  });

  group('Loading', () {
    testWidgets('Initial shows Loading', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
        ),
      );
      final form = FormData(
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        actions: [],
        schema: {},
      );
      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
          .thenAnswer((realInvocation) async => form);

      await tester.pumpWidget(target);

      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    });
  });

  group('Success', () {
    testWidgets('Shows Success', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData(
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        actions: [action],
        schema: {},
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData(
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        actions: [action],
        schema: {},
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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

      verify(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
          .called(2);
    });
  });

  group('Error', () {
    group('Initial Call', () {
      testWidgets('Initial Error Shows', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );

        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle(const Duration(seconds: 30));

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Initial Error Reloads Form', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );
        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
            .thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        verify(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
            .called(2);
      });
    });

    group('Action Error', () {
      testWidgets('Shows Error', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [action],
          schema: {},
        );

        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [action],
          schema: {},
        );

        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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

      testWidgets('Back to Form shows Form', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [action],
          schema: {},
        );

        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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

      testWidgets('Cache Response. Additional Answer shows Form',
          (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            formUri: RedirectFormUri(
              components: ['form'],
            ),
          ),
        );
        final action = FormAction('uri', 'method');
        final formData = FormData(
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          actions: [action],
          schema: {},
        );

        when(() =>
                client.loadForm(formUri: RedirectFormUri(components: ['form'])))
            .thenAnswer((realInvocation) async => formData);
        when(() => client.performAction(action, formData))
            .thenAnswer((_) async => http.Response('', 500));

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
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
          onActionSuccess: (action) async {
            return false;
          },
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData(
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        actions: [action],
        schema: {},
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: RedirectFormUri(
            components: ['form'],
          ),
          onError: (error) async {
            return false;
          },
        ),
      );
      final action = FormAction('uri', 'method');
      final formData = FormData(
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        actions: [action],
        schema: {},
      );

      when(() =>
              client.loadForm(formUri: RedirectFormUri(components: ['form'])))
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

  group('Cache', () {
    late http.Client httpClient;

    final action = FormAction('actionUri', 'POST');
    final data = FormData(
      name: 'Form Name',
      title: 'Title',
      components: [],
      actions: [action],
      schema: {},
    );

    final formUri = RedirectFormUri(components: ['form']);
    const env = ApptiveGridEnvironment.production;

    setUpAll(() {
      registerFallbackValue(http.Request('POST', Uri()));
      registerFallbackValue(ActionItem(action: action, data: data));
    });

    setUp(() {
      httpClient = MockHttpClient();

      when(
        () => httpClient.get(
          Uri.parse(env.url + formUri.uriString),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode(data.toJson()), 200),
      );
      when(() => httpClient.send(any())).thenAnswer(
        (invocation) async => http.StreamedResponse(Stream.value([]), 400),
      );
    });

    testWidgets('No Cache, Error, Shows Error Screen', (tester) async {
      final client = ApptiveGridClient.fromClient(httpClient);

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Cache, Error, Shows Saved Screen', (tester) async {
      final cacheMap = <ActionItem>{};
      final cache = MockApptiveGridCache();
      when(() => cache.addPendingActionItem(any())).thenAnswer(
        (invocation) => cacheMap.add(invocation.positionalArguments[0]),
      );
      when(() => cache.removePendingActionItem(any())).thenAnswer(
        (invocation) => cacheMap.remove(invocation.positionalArguments[0]),
      );
      when(() => cache.getPendingActionItems())
          .thenAnswer((invocation) => cacheMap.toList());

      final client = ApptiveGridClient.fromClient(
        httpClient,
        options: ApptiveGridOptions(
          cache: cache,
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          formUri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      verify(() => httpClient.send(any())).called(1);

      expect(
        find.text(
          'The Form was saved and will be send at the next opportunity',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });
  });
}
