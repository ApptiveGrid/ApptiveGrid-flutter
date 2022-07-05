import 'dart:async';
import 'dart:convert';

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

  setUpAll(() {
    registerFallbackValue(Uri.parse('/api/a/components'));
    registerFallbackValue(http.Request('POST', Uri()));
    registerFallbackValue(
      ActionItem(
        link: ApptiveLink(uri: Uri(), method: ''),
        data: FormData(
          id: 'formId',
          title: '',
          components: [],
          fields: [],
          links: {},
        ),
      ),
    );
  });

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async {});
  });

  group('Title', () {
    testWidgets('Title Displays', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          fields: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsOneWidget);
    });

    testWidgets('Title does not display', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          hideTitle: true,
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          fields: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Title'), findsNothing);
    });
  });

  group('Description', () {
    testWidgets('Description Displays', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          name: 'Form Name',
          description: 'Form Description',
          components: [],
          fields: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Description'), findsOneWidget);
    });

    testWidgets('Description does not display', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          hideDescription: true,
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          name: 'Form Name',
          description: 'Form Description',
          components: [],
          fields: [],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('Form Description'), findsNothing);
    });
  });

  testWidgets('OnLoadedCallback gets called', (tester) async {
    final form = FormData(
      id: 'formId',
      name: 'Form Name',
      title: 'Form Title',
      components: [],
      fields: [],
      links: {},
    );
    final completer = Completer<FormData>();
    final target = TestApp(
      client: client,
      child: ApptiveGridForm(
        uri: Uri.parse('/api/a/form'),
        onFormLoaded: (data) {
          completer.complete(data);
        },
      ),
    );

    when(() => client.loadForm(uri: Uri.parse('/api/a/form')))
        .thenAnswer((realInvocation) async => form);

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    final result = await completer.future;
    expect(result, equals(form));
  });

  group('Loading', () {
    testWidgets('Initial shows Loading', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final form = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        fields: [],
        links: {},
      );
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => form);

      await tester.pumpWidget(target);

      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Reload with reset resets', (tester) async {
      final key = GlobalKey<ApptiveGridFormState>();
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          key: key,
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final form = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        fields: [],
        links: {},
      );
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) =>
            Future.delayed(const Duration(seconds: 2), () => form),
      );

      await tester.pumpWidget(target);

      final loadingFinder = find.byType(
        CircularProgressIndicator,
      );
      expect(
        loadingFinder,
        findsOneWidget,
      );

      await tester.pumpAndSettle();
      expect(loadingFinder, findsNothing);

      key.currentState?.loadForm(resetData: true);

      await tester.pump();
      expect(loadingFinder, findsOneWidget);
      await tester.pumpAndSettle();
      expect(loadingFinder, findsNothing);
    });
  });

  group('Success', () {
    testWidgets('Shows Success', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => Stream.value(
          SubmitCompleteProgressEvent(http.Response('', 200)),
        ),
      );

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
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => Stream.value(
          SubmitCompleteProgressEvent(http.Response('', 200)),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(TextButton), 100);
      await tester.tap(find.byType(TextButton, skipOffstage: false));
      await tester.pumpAndSettle();

      verify(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).called(2);
    });
  });

  group('Error', () {
    group('Initial Call', () {
      testWidgets('Initial Error Shows', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((_) => Future.error(''));

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
            uri: Uri.parse('/api/a/form'),
          ),
        );
        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((_) => Future.error(''));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        verify(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).called(2);
      });
    });

    group('Action Error', () {
      testWidgets('Shows Error', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData))
            .thenAnswer((_) => Stream.value(const ErrorProgressEvent('')));

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
            uri: Uri.parse('/api/a/form'),
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData))
            .thenAnswer((_) => Stream.value(const ErrorProgressEvent('')));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(Lottie), findsOneWidget);
        expect(find.text('Oops! - Error', skipOffstage: false), findsOneWidget);
        expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
      });

      testWidgets('Back to Form shows Form', (tester) async {
        final formUri = Uri.parse('/api/a/form');
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: formUri,
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: formUri),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData))
            .thenAnswer((_) => Stream.value(const ErrorProgressEvent('')));

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        expect(find.text('Form Title'), findsOneWidget);
        // Don't reload here
        verify(() => client.loadForm(uri: formUri)).called(1);
      });

      testWidgets('Cache Response. Additional Answer shows Form',
          (tester) async {
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
        when(() => client.options)
            .thenAnswer((invocation) => ApptiveGridOptions(cache: cache));
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
          (_) => Stream.value(
            SubmitCompleteProgressEvent(http.Response('', 500)),
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byType(TextButton), 100);
        await tester.tap(find.byType(TextButton, skipOffstage: false));
        await tester.pumpAndSettle();

        expect(find.text('Form Title'), findsOneWidget);
        verify(() => client.loadForm(uri: any(named: 'uri'))).called(2);
      });
    });

    group('Error Message', () {
      testWidgets('Error shows to String Error', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
          (_) => Stream.value(ErrorProgressEvent(Exception('Testing Errors'))),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();
        expect(
          find.text('Exception: Testing Errors', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('Response shows Status Code and Body', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );
        final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
        final formData = FormData(
          id: 'formId',
          name: 'Form Name',
          title: 'Form Title',
          components: [],
          links: {ApptiveLinkType.submit: action},
          fields: [],
        );

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer((realInvocation) async => formData);
        when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
          (_) => Stream.value(
            ErrorProgressEvent(http.Response('Testing Errors', 400)),
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ActionButton));
        await tester.pumpAndSettle();
        expect(
          find.text('400: Testing Errors', skipOffstage: false),
          findsOneWidget,
        );
      });
    });
  });

  group('Skip Custom Builder', () {
    testWidgets('Shows Success', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          onActionSuccess: (action, data) async {
            return false;
          },
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => Stream.value(
          SubmitCompleteProgressEvent(http.Response('', 200)),
        ),
      );

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
          uri: Uri.parse('/api/a/form'),
          onError: (error) async {
            return false;
          },
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData))
          .thenAnswer((_) => Stream.value(const ErrorProgressEvent('')));

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsNothing);
    });
  });

  group('Cache', () {
    late http.Client httpClient;

    final action = ApptiveLink(uri: Uri.parse('actionUri'), method: 'POST');
    final data = FormData(
      id: 'formId',
      name: 'Form Name',
      title: 'Title',
      components: [],
      links: {ApptiveLinkType.submit: action},
      fields: [],
    );

    final formUri = Uri.parse('/api/a/form');
    const env = ApptiveGridEnvironment.production;

    setUpAll(() {
      registerFallbackValue(http.Request('POST', Uri()));
      registerFallbackValue(
        ActionItem(link: action, data: data),
      );
    });

    setUp(() {
      httpClient = MockHttpClient();

      when(
        () => httpClient.get(
          Uri.parse(env.url + formUri.toString()),
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
      final client = ApptiveGridClient(httpClient: httpClient);

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

      final client = ApptiveGridClient(
        httpClient: httpClient,
        options: ApptiveGridOptions(
          cache: cache,
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

      verify(() => httpClient.send(any())).called(1);

      expect(
        find.text(
          'The form was saved and will be sent at the next opportunity',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Cache, Error in Attachment, Shows Saved Screen',
        (tester) async {
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

      final client = MockApptiveGridClient();
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (invocation) => Future.value(data),
      );
      when(() => client.sendPendingActions()).thenAnswer((invocation) async {});
      when(() => client.submitFormWithProgress(action, data)).thenAnswer(
        (invocation) => Stream.value(
          AttachmentCompleteProgressEvent(http.Response('', 400)),
        ),
      );
      when(() => client.options).thenReturn(ApptiveGridOptions(cache: cache));

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

      expect(
        find.text(
          'The form was saved and will be sent at the next opportunity',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });
  });

  group('Current Data', () {
    testWidgets('Current Data returns data', (tester) async {
      final key = GlobalKey<ApptiveGridFormDataState>();
      final form = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        fields: [],
        links: {},
      );
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          key: key,
          uri: Uri.parse('/api/a/form'),
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => form);

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        (tester.state(find.byType(ApptiveGridForm)) as ApptiveGridFormState)
            .currentData,
        equals(form),
      );
    });

    testWidgets(
        'Action Success '
        'Current Data returns null', (tester) async {
      final key = GlobalKey<ApptiveGridFormDataState>();
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          key: key,
          uri: Uri.parse('/api/a/form'),
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => Stream.value(
          SubmitCompleteProgressEvent(http.Response('', 200)),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        (tester.state(find.byType(ApptiveGridForm)) as ApptiveGridFormState)
            .currentData,
        equals(null),
      );
    });

    testWidgets(
        'Action Error '
        'Current Data data', (tester) async {
      final key = GlobalKey<ApptiveGridFormDataState>();
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );
      final target = TestApp(
        client: client,
        options: const ApptiveGridOptions(
          cache: null,
        ),
        child: ApptiveGridForm(
          key: key,
          uri: Uri.parse('/api/a/form'),
        ),
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => Stream.value(ErrorProgressEvent(http.Response('', 400))),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      expect(
        (tester.state(find.byType(ApptiveGridForm)) as ApptiveGridFormState)
            .currentData,
        equals(formData),
      );
    });
  });

  group('Action', () {
    testWidgets('Click on Button shows Loading Indicator', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      final actionCompleter = Completer<http.Response>();
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData))
          .thenAnswer((_) {
        return actionCompleter.future
            .asStream()
            .map((event) => SubmitCompleteProgressEvent(event));
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pump();

      expect(find.byType(ActionButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      actionCompleter.complete(http.Response('', 200));
      await tester.pump();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Custom Button Label', (tester) async {
      const label = 'Custom Label';
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          buttonLabel: label,
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      final actionCompleter = Completer<http.Response>();
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData))
          .thenAnswer((_) {
        return actionCompleter.future
            .asStream()
            .map((event) => SubmitCompleteProgressEvent(event));
      });

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ActionButton),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    });
  });

  group('User Reference', () {
    testWidgets('UserReference Form Widget is build without padding',
        (tester) async {
      const field = GridField(
        id: 'field3',
        name: 'name',
        type: DataType.createdBy,
        schema: {
          'type': 'object',
          'properties': {
            'displayValue': {'type': 'string'},
            'id': {'type': 'string'},
            'type': {'type': 'string'},
            'name': {'type': 'string'}
          },
          'objectType': 'userReference'
        },
      );
      final formData = FormData(
        id: 'formId',
        title: 'Form Data',
        components: [
          FormComponent<CreatedByDataEntity>(
            property: 'Created By',
            data: CreatedByDataEntity(),
            field: field,
          ),
        ],
        links: {},
        fields: [field],
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        find.ancestor(
          of: find.byType(CreatedByFormWidget),
          matching: find.byType(Padding),
        ),
        findsNothing,
      );
    });
  });

  group('Reload', () {
    testWidgets('Changing Form Uri triggers reload', (tester) async {
      final firstForm = Uri.parse('/form1');
      final secondForm = Uri.parse('/form2');

      final globalKey = GlobalKey<_ChangingFormWidgetState>();
      final client = MockApptiveGridClient();

      when(client.sendPendingActions).thenAnswer((_) async {});
      when(() => client.loadForm(uri: any(named: 'uri'))).thenAnswer(
        (_) async => FormData(
          id: 'formId',
          title: 'title',
          components: [],
          fields: [],
          links: {},
        ),
      );

      final target = TestApp(
        client: client,
        child: _ChangingFormWidget(
          key: globalKey,
          form1: firstForm,
          form2: secondForm,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();

      globalKey.currentState?._changeForm();
      await tester.pump();

      verify(() => client.loadForm(uri: firstForm)).called(1);
      verify(() => client.loadForm(uri: secondForm)).called(1);
    });
  });

  group('FormUri', () {
    final uri = Uri.parse('uri');
    // ignore: deprecated_member_use
    final formUri = FormUri.fromUri('formUri');

    test('No FormUri returns Uri as FormUri', () async {
      final apptiveGridForm = ApptiveGridForm(
        uri: uri,
      );

      // ignore: deprecated_member_use_from_same_package
      expect(apptiveGridForm.formUri.uri, equals(uri));
      expect(apptiveGridForm.uri, equals(uri));
    });

    test('No Uri returns FormUri', () async {
      final apptiveGridForm = ApptiveGridForm(
        // ignore: deprecated_member_use_from_same_package
        formUri: formUri,
      );

      // ignore: deprecated_member_use_from_same_package
      expect(apptiveGridForm.formUri.uri, equals(formUri.uri));
      expect(apptiveGridForm.uri, equals(formUri.uri));
    });

    test('Uri prioritized over formUri', () async {
      final apptiveGridForm = ApptiveGridForm(
        uri: uri,
        // ignore: deprecated_member_use_from_same_package
        formUri: formUri,
      );

      // ignore: deprecated_member_use_from_same_package
      expect(apptiveGridForm.formUri.uri, equals(uri));
      expect(apptiveGridForm.uri, equals(uri));
    });
  });

  group('Progress', () {
    testWidgets('Shows Progress', (tester) async {
      final controller = StreamController<SubmitFormProgressEvent>();

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );
      final attachment = Attachment(
        name: 'name',
        url: Uri(path: '/attachment'),
        type: 'image/png',
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [],
        attachmentActions: {
          attachment: AddAttachmentAction(path: '', attachment: attachment)
        },
        links: {ApptiveLinkType.submit: action},
        fields: [],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);
      when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
        (_) => controller.stream,
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ActionButton));
      await tester.pump();

      expect(find.text('Processing Attachments [0/1]'), findsOneWidget);

      controller.add(ProcessedAttachmentProgressEvent(attachment));
      await tester.pump();
      expect(find.text('Processing Attachments [1/1]'), findsOneWidget);
      controller.add(UploadFormProgressEvent(formData));
      await tester.pump();
      expect(find.text('Submitting Form'), findsOneWidget);
      controller.add(SubmitCompleteProgressEvent(http.Response('', 200)));
      await tester.pump();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });
  });
}

class _ChangingFormWidget extends StatefulWidget {
  const _ChangingFormWidget({
    super.key,
    required this.form1,
    required this.form2,
  });

  final Uri form1;
  final Uri form2;

  @override
  State<_ChangingFormWidget> createState() => _ChangingFormWidgetState();
}

class _ChangingFormWidgetState extends State<_ChangingFormWidget> {
  late Uri _displayingUri;

  @override
  void initState() {
    super.initState();
    _displayingUri = widget.form1;
  }

  void _changeForm() {
    setState(() {
      _displayingUri =
          _displayingUri == widget.form1 ? widget.form2 : widget.form1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGridForm(uri: _displayingUri);
  }
}
