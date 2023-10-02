import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart' hide FormField;
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
    registerFallbackValue(
      FormData(id: 'id', components: [], fields: [], links: {}),
    );
  });

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async => []);
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

  testWidgets('OnCreated gets called', (tester) async {
    final completer = Completer<Uri>();
    final target = TestApp(
      client: client,
      child: ApptiveGridForm(
        uri: Uri.parse('/api/a/form'),
        onCreated: (uri) => completer.complete(uri),
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

    final createdUri = Uri.parse('/api/a/created');

    when(
      () => client.loadForm(uri: Uri.parse('/api/a/form')),
    ).thenAnswer((realInvocation) async => formData);
    when(() => client.submitFormWithProgress(action, formData)).thenAnswer(
      (_) => Stream.value(
        SubmitCompleteProgressEvent(
          http.Response('Created ${createdUri.toString()}', 200),
        ),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final parsedUri = await completer.future;

    expect(parsedUri, equals(createdUri));
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Shows custom Success', (tester) async {
      const customTitle = 'customTitle';
      const customMessage = 'customMessage';
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
        properties: FormDataProperties(
          successTitle: customTitle,
          successMessage: customMessage,
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(customTitle, skipOffstage: false), findsOneWidget);
      expect(find.text(customMessage, skipOffstage: false), findsOneWidget);
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(TextButton), 100);
      await tester.tap(find.byType(TextButton, skipOffstage: false));
      await tester.pumpAndSettle();

      verify(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).called(2);
    });

    testWidgets('Reload flag', (tester) async {
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
        properties: FormDataProperties(
          reloadAfterSubmit: true,
          successTitle: 'Success test',
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Success test'), findsNothing);

      verify(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).called(2);
    });

    testWidgets('Shows custom submit additional button', (tester) async {
      const customLabel = 'customLabel';
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
        properties: FormDataProperties(
          afterSubmitAction: const AfterSubmitAction(
            type: AfterSubmitActionType.additionalAnswer,
            buttonTitle: customLabel,
          ),
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(TextButton), 100);
      expect(find.text(customLabel, skipOffstage: false), findsOneWidget);
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
        await tester.tap(find.byType(ElevatedButton));
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
        await tester.tap(find.byType(ElevatedButton));
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
        await tester.tap(find.byType(ElevatedButton));
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
        await tester.tap(find.byType(ElevatedButton));
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
        await tester.tap(find.byType(ElevatedButton));
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
        await tester.tap(find.byType(ElevatedButton));
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
      await tester.tap(find.byType(ElevatedButton));
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
      await tester.tap(find.byType(ElevatedButton));
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

      await tester.tap(find.byType(ElevatedButton));
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

      await tester.tap(find.byType(ElevatedButton));
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

    testWidgets('Cache, Callback specified and return true, Shows Saved Screen',
        (tester) async {
      final callbackCompleter = Completer<ApptiveLink>();
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
          onSavedToPending: (link, __) async {
            callbackCompleter.complete(link);
            return true;
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => httpClient.send(any())).called(1);

      expect(
        find.text(
          'The form was saved and will be sent at the next opportunity',
          skipOffstage: false,
        ),
        findsOneWidget,
      );

      expect(await callbackCompleter.future, cacheMap.first.link);
    });

    testWidgets(
        'Cache, Callback specified and return false, Does not show Saved Screen',
        (tester) async {
      final callbackCompleter = Completer<ApptiveLink>();
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
          onSavedToPending: (link, __) async {
            callbackCompleter.complete(link);
            return false;
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => httpClient.send(any())).called(1);

      expect(
        find.text(
          'The form was saved and will be sent at the next opportunity',
          skipOffstage: false,
        ),
        findsNothing,
      );

      expect(await callbackCompleter.future, cacheMap.first.link);
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
      when(() => client.sendPendingActions())
          .thenAnswer((invocation) async => []);
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

      await tester.tap(find.byType(ElevatedButton));
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
      await tester.tap(find.byType(ElevatedButton));
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
      await tester.tap(find.byType(ElevatedButton));
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
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      actionCompleter.complete(http.Response('', 200));
      await tester.pump();

      expect(find.byType(Lottie), findsOneWidget);
      expect(find.text('Thank You!', skipOffstage: false), findsOneWidget);
      expect(find.byType(TextButton, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Custom Button Label from backend', (tester) async {
      const label = 'Custom Label';
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
        properties: FormDataProperties(
          buttonTitle: label,
        ),
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
          of: find.byType(ElevatedButton),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Custom Button Label from flag', (tester) async {
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
          of: find.byType(ElevatedButton),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Hide button', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          hideButton: true,
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

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Custom button button', (tester) async {
      const buttonText = 'test';
      const loadingText = 'loading';
      final target = TestApp(
        client: client,
        child: const _CustomButtonFormWidget(
          customButtonText: buttonText,
          customButtonLoadingText: loadingText,
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

      expect(find.byType(ElevatedButton), findsNothing);
      expect(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.text(buttonText),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text(buttonText));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsNothing);
      expect(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.text(loadingText),
        ),
        findsOneWidget,
      );

      actionCompleter.complete(http.Response('', 200));

      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsNothing);
      expect(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.text(buttonText),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text(buttonText));
      await tester.pump();
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
            'name': {'type': 'string'},
          },
          'objectType': 'userReference',
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
          of: find.byType(EmptyFormWidget),
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

      when(client.sendPendingActions).thenAnswer((_) async => []);
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
          attachment: AddAttachmentAction(path: '', attachment: attachment),
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
      await tester.tap(find.byType(ElevatedButton));
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

  group('Component Builder', () {
    testWidgets('Build Custom Widget for Component', (tester) async {
      final completer = Completer<FormComponent>();
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
          componentBuilder: (_, component) {
            completer.complete(component);
            return const SizedBox();
          },
        ),
      );
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      const field = GridField(id: 'id', name: 'name', type: DataType.text);
      final formComponent = FormComponent(
        property: 'property',
        data: StringDataEntity(),
        field: field,
      );
      final formData = FormData(
        id: 'formId',
        name: 'Form Name',
        title: 'Form Title',
        components: [formComponent],
        links: {ApptiveLinkType.submit: action},
        fields: [field],
      );

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer((realInvocation) async => formData);

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      final customComponent = await completer.future;

      expect(customComponent, equals(formComponent));
      expect(find.byType(TextFormField), findsNothing);
    });
  });

  group('Field properties', () {
    const field = GridField(
      id: 'field',
      name: 'name',
      type: DataType.text,
      schema: {},
    );
    testWidgets('Hidden', (tester) async {
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
          components: [
            FormComponent(
              property: 'property',
              data: StringDataEntity(),
              field: field,
            ),
          ],
          fields: [field],
          fieldProperties: [
            FormFieldProperties(
              fieldId: field.id,
              hidden: true,
            ),
          ],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('property'), findsNothing);
    });
    testWidgets('Disabled', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      const defaultValue = 'default';

      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          components: [
            FormComponent(
              property: 'property',
              data: StringDataEntity(),
              field: field,
            ),
          ],
          fields: [field],
          fieldProperties: [
            FormFieldProperties(
              fieldId: field.id,
              defaultValue: StringDataEntity(defaultValue),
              disabled: true,
            ),
          ],
          links: {},
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text(defaultValue), findsOneWidget);
      expect(find.text(defaultValue).hitTestable(), findsNothing);
    });

    group('Default value', () {
      final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
      testWidgets('Show default value', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        const defaultValue = 'default';

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer(
          (realInvocation) async => FormData(
            id: 'formId',
            components: [
              FormComponent(
                property: 'property',
                data: StringDataEntity(),
                field: field,
              ),
            ],
            fields: [field],
            fieldProperties: [
              FormFieldProperties(
                fieldId: field.id,
                defaultValue: StringDataEntity(defaultValue),
              ),
            ],
            links: {},
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        expect(find.text(defaultValue), findsOneWidget);
      });
      testWidgets('Show default value', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        const defaultValue = 'default';

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer(
          (realInvocation) async => FormData(
            id: 'formId',
            components: [
              FormComponent(
                property: 'property',
                data: StringDataEntity(),
                field: field,
              ),
            ],
            fields: [field],
            fieldProperties: [
              FormFieldProperties(
                fieldId: field.id,
                defaultValue: StringDataEntity(defaultValue),
              ),
            ],
            links: {},
          ),
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        expect(find.text(defaultValue), findsOneWidget);
      });
      testWidgets('Default value submits', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        const defaultValue = 'default';

        final didComplete = Completer();

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer(
          (realInvocation) async => FormData(
            id: 'formId',
            components: [
              FormComponent(
                property: 'property',
                data: StringDataEntity(),
                field: field,
              ),
            ],
            fields: [field],
            fieldProperties: [
              FormFieldProperties(
                fieldId: field.id,
                defaultValue: StringDataEntity(defaultValue),
              ),
            ],
            links: {ApptiveLinkType.submit: action},
          ),
        );
        when(
          () => client.submitFormWithProgress(
            action,
            any(
              that: predicate<FormData>(
                (formData) =>
                    formData.components?.first.data.value == defaultValue,
              ),
            ),
          ),
        ).thenAnswer(
          (_) {
            didComplete.complete();
            return Stream.value(
              SubmitCompleteProgressEvent(http.Response('', 200)),
            );
          },
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await didComplete.future;
      });
      testWidgets('Disabled default value submits', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        const defaultValue = 'default';

        final didComplete = Completer();

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer(
          (realInvocation) async => FormData(
            id: 'formId',
            components: [
              FormComponent(
                property: 'property',
                data: StringDataEntity(),
                field: field,
              ),
            ],
            fields: [field],
            fieldProperties: [
              FormFieldProperties(
                fieldId: field.id,
                defaultValue: StringDataEntity(defaultValue),
                disabled: true,
              ),
            ],
            links: {ApptiveLinkType.submit: action},
          ),
        );
        when(
          () => client.submitFormWithProgress(
            action,
            any(
              that: predicate<FormData>(
                (formData) =>
                    formData.components?.first.data.value == defaultValue,
              ),
            ),
          ),
        ).thenAnswer(
          (_) {
            didComplete.complete();
            return Stream.value(
              SubmitCompleteProgressEvent(http.Response('', 200)),
            );
          },
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await didComplete.future;
      });
      testWidgets('Hidden default value submits', (tester) async {
        final target = TestApp(
          client: client,
          child: ApptiveGridForm(
            uri: Uri.parse('/api/a/form'),
          ),
        );

        const defaultValue = 'default';

        final didComplete = Completer();

        when(
          () => client.loadForm(uri: Uri.parse('/api/a/form')),
        ).thenAnswer(
          (realInvocation) async => FormData(
            id: 'formId',
            components: [
              FormComponent(
                property: 'property',
                data: StringDataEntity(),
                field: field,
              ),
            ],
            fields: [field],
            fieldProperties: [
              FormFieldProperties(
                fieldId: field.id,
                defaultValue: StringDataEntity(defaultValue),
                hidden: true,
              ),
            ],
            links: {ApptiveLinkType.submit: action},
          ),
        );
        when(
          () => client.submitFormWithProgress(
            action,
            any(
              that: predicate<FormData>(
                (formData) =>
                    formData.components?.first.data.value == defaultValue,
              ),
            ),
          ),
        ).thenAnswer(
          (_) {
            didComplete.complete();
            return Stream.value(
              SubmitCompleteProgressEvent(http.Response('', 200)),
            );
          },
        );

        await tester.pumpWidget(target);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await didComplete.future;
      });
    });
  });

  group('Paged forms', () {
    final fields = List.generate(
      3,
      (index) => GridField(
        id: 'field$index',
        name: 'name',
        type: DataType.text,
        schema: {},
      ),
    );
    final pages = List.generate(3, (index) => 'page$index');
    final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');

    setUp(() {
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          components: fields
              .map(
                (field) => FormComponent(
                  property: 'property',
                  data: StringDataEntity(),
                  field: field,
                  required: true,
                ),
              )
              .toList(),
          fields: fields,
          fieldProperties: fields
              .map(
                (field) => FormFieldProperties(
                  fieldId: field.id,
                  defaultValue: StringDataEntity(),
                  pageId: pages[fields.indexOf(field)],
                ),
              )
              .toList(),
          properties: FormDataProperties(pageIds: pages),
          links: {ApptiveLinkType.submit: action},
        ),
      );
    });

    testWidgets('Page navigation', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      final findNext = find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.text('Next'),
      );

      final findBack = find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.text('Back'),
      );

      expect(findNext, findsOneWidget);
      expect(findBack, findsNothing);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(findNext, findsOneWidget);
      expect(findBack, findsNothing);

      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'text1');

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(findNext, findsOneWidget);
      expect(findBack, findsOneWidget);
      expect(find.text('text1'), findsNothing);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(findNext, findsOneWidget);
      expect(findBack, findsOneWidget);
      expect(find.text('text1'), findsNothing);

      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'text2');

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(findNext, findsNothing);
      expect(findBack, findsOneWidget);
      expect(find.text('text1'), findsNothing);
      expect(find.text('text2'), findsNothing);

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(findNext, findsNothing);
      expect(findBack, findsOneWidget);
      expect(find.text('text1'), findsNothing);
      expect(find.text('text2'), findsNothing);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(findNext, findsOneWidget);
      expect(findBack, findsOneWidget);
      expect(find.text('text1'), findsNothing);
      expect(find.text('text2'), findsOneWidget);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(findNext, findsOneWidget);
      expect(findBack, findsNothing);
      expect(find.text('text1'), findsOneWidget);
      expect(find.text('text2'), findsNothing);
    });
    testWidgets('Submit sends all set data', (tester) async {
      when(
        () => client.submitFormWithProgress(
          action,
          any(
            that: predicate<FormData>((data) {
              for (var i = 0; i < pages.length; i++) {
                if (data.components![i].data.value != pages[i]) {
                  return false;
                }
              }
              return true;
            }),
          ),
        ),
      ).thenAnswer(
        (_) => Stream.value(
          SubmitCompleteProgressEvent(http.Response('', 200)),
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      for (var i = 0; i < pages.length; i++) {
        await tester.tap(find.byType(TextFormField));
        await tester.enterText(find.byType(TextFormField), pages[i]);

        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pumpAndSettle();
      }
      verify(
        () => client.submitFormWithProgress(
          action,
          any(
            that: predicate<FormData>((data) {
              for (var i = 0; i < pages.length; i++) {
                if (data.components![i].data.value != pages[i]) {
                  return false;
                }
              }
              return true;
            }),
          ),
        ),
      ).called(1);
    });
  });

  group('Text blocks', () {
    const field = GridField(
      id: 'field',
      name: 'name',
      type: DataType.text,
      schema: {},
    );
    final action = ApptiveLink(uri: Uri.parse('uri'), method: 'method');
    testWidgets('Show on single page', (tester) async {
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          components: [
            FormComponent(
              property: 'property',
              data: StringDataEntity(),
              field: field,
              required: true,
            ),
          ],
          fields: [field],
          fieldProperties: [
            FormFieldProperties(
              fieldId: field.id,
              defaultValue: StringDataEntity(),
              fieldIndex: 1,
              pageId: 'pageId',
            ),
          ],
          properties: FormDataProperties(
            pageIds: ['pageId'],
            blocks: [
              FormTextBlock(
                id: 'id0',
                pageId: 'pageId',
                fieldIndex: 0,
                text: 'block1',
                type: 'type',
                style: 'style',
              ),
              FormTextBlock(
                id: 'id1',
                pageId: 'pageId',
                fieldIndex: 2,
                text: 'block2',
                type: 'type',
                style: 'style',
              ),
            ],
          ),
          links: {ApptiveLinkType.submit: action},
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('block1'), findsOneWidget);
      expect(find.text('block2'), findsOneWidget);
    });
    testWidgets('Show on multi page', (tester) async {
      const field2 = GridField(
        id: 'field2',
        name: 'name',
        type: DataType.text,
        schema: {},
      );
      when(
        () => client.loadForm(uri: Uri.parse('/api/a/form')),
      ).thenAnswer(
        (realInvocation) async => FormData(
          id: 'formId',
          components: [
            FormComponent(
              property: 'property',
              data: StringDataEntity(),
              field: field,
            ),
            FormComponent(
              property: 'property',
              data: StringDataEntity(),
              field: field2,
            ),
          ],
          fields: [field, field2],
          fieldProperties: [
            FormFieldProperties(
              fieldId: field.id,
              defaultValue: StringDataEntity(),
              fieldIndex: 1,
              pageId: 'pageId0',
            ),
            FormFieldProperties(
              fieldId: field2.id,
              defaultValue: StringDataEntity(),
              fieldIndex: 1,
              pageId: 'pageId1',
            ),
          ],
          properties: FormDataProperties(
            pageIds: ['pageId0', 'pageId1'],
            blocks: [
              FormTextBlock(
                id: 'id0',
                pageId: 'pageId0',
                fieldIndex: 0,
                text: 'block1',
                type: 'type',
                style: 'style',
              ),
              FormTextBlock(
                id: 'id1',
                pageId: 'pageId0',
                fieldIndex: 2,
                text: 'block2',
                type: 'type',
                style: 'style',
              ),
              FormTextBlock(
                id: 'id2',
                pageId: 'pageId1',
                fieldIndex: 0,
                text: 'block3',
                type: 'type',
                style: 'style',
              ),
              FormTextBlock(
                id: 'id3',
                pageId: 'pageId1',
                fieldIndex: 2,
                text: 'block4',
                type: 'type',
                style: 'style',
              ),
            ],
          ),
          links: {ApptiveLinkType.submit: action},
        ),
      );

      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: Uri.parse('/api/a/form'),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('block1'), findsOneWidget);
      expect(find.text('block2'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('block3'), findsOneWidget);
      expect(find.text('block4'), findsOneWidget);
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

class _CustomButtonFormWidget extends StatefulWidget {
  const _CustomButtonFormWidget({
    required this.customButtonText,
    required this.customButtonLoadingText,
  });

  final String customButtonText;
  final String customButtonLoadingText;

  @override
  State<StatefulWidget> createState() => _CustomButtonFormWidgetState();
}

class _CustomButtonFormWidgetState extends State<_CustomButtonFormWidget> {
  final Uri _uri = Uri.parse('/api/a/form');

  final _formKey = GlobalKey<ApptiveGridFormState>();

  bool get _isSubmitting => _formKey.currentState?.submitting == true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () {
                  _formKey.currentState?.submitForm();
                  setState(() {});
                },
          child: Text(
            _isSubmitting
                ? widget.customButtonLoadingText
                : widget.customButtonText,
          ),
        ),
        Expanded(
          child: ApptiveGridForm(
            key: _formKey,
            uri: _uri,
            hideButton: true,
            onActionSuccess: (_, __) async {
              setState(() {});
              return false;
            },
          ),
        ),
      ],
    );
  }
}
