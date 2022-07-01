import 'dart:convert';

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
      FormData(id: 'id', components: [], fields: [], links: {}),
    );
    registerFallbackValue(ApptiveLink(uri: Uri(), method: 'method'));
  });

  late ApptiveGridClient client;

  final collaborationUri = Uri(path: 'collaborators');
  final field = GridField(
    id: 'fieldId',
    name: 'name',
    type: DataType.user,
    links: {
      ApptiveLinkType.collaborators:
          ApptiveLink(uri: collaborationUri, method: 'get'),
    },
  );
  final submitUri = Uri(path: 'submit');
  final submitLink = ApptiveLink(uri: submitUri, method: 'post');

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async {});
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
              data: UserDataEntity(
                DataUser(
                  displayValue: 'displayValue',
                  uri: Uri(path: '/users/id'),
                ),
              ),
              field: field,
            )
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
              data: UserDataEntity(),
              field: field,
            )
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
              data: UserDataEntity(
                DataUser(
                  displayValue: 'differentDisplayValue',
                  uri: Uri(path: '/users/id'),
                ),
              ),
              field: field,
            )
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final user =
          DataUser(displayValue: 'display Value', uri: Uri(path: '/users/id'));
      when(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        final parseResponse =
            invocation.namedArguments[const Symbol('parseResponse')]
                as Future<List<DataUser>?> Function(Response);

        return parseResponse(
          Response(
            jsonEncode([
              user.toJson(),
            ]),
            200,
          ),
        );
      });
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();
      await tester.tap(find.text(user.displayValue));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(capturedForm.components!.first.data.value, equals(user));
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
              data: UserDataEntity(),
              field: field,
            )
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final user =
          DataUser(displayValue: 'display Value', uri: Uri(path: '/users/id'));
      when(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        final parseResponse =
            invocation.namedArguments[const Symbol('parseResponse')]
                as Future<List<DataUser>?> Function(Response);

        return parseResponse(
          Response(
            jsonEncode([
              user.toJson(),
            ]),
            200,
          ),
        );
      });
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();
      await tester.tap(find.text(user.displayValue));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(capturedForm.components!.first.data.value, equals(user));
    });
  });

  group('Filter Collaborators', () {
    testWidgets('Filter Collaborators', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UserDataEntity(),
              field: field,
            )
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final user =
          DataUser(displayValue: 'Display', uri: Uri(path: '/users/id'));
      final user2 =
          DataUser(displayValue: 'Filter Out', uri: Uri(path: '/users/id'));
      when(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        final parseResponse =
            invocation.namedArguments[const Symbol('parseResponse')]
                as Future<List<DataUser>?> Function(Response);
        final query =
            (invocation.namedArguments[const Symbol('queryParameters')]
                as Map<String, String>)['matching'];
        if (query == null || query.isEmpty) {
          return parseResponse(
            Response(
              jsonEncode([
                user.toJson(),
                user2.toJson(),
              ]),
              200,
            ),
          );
        } else if (query == 'D') {
          return parseResponse(
            Response(
              jsonEncode([
                user.toJson(),
              ]),
              200,
            ),
          );
        } else {
          return parseResponse(
            Response(
              jsonEncode([]),
              200,
            ),
          );
        }
      });
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsNWidgets(2),
      );

      await tester.enterText(find.byType(TextField), 'D');
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), 'Da');
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsNothing,
      );

      expect(find.text('No Users found that match "Da"'), findsOneWidget);

      verify(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: {'matching': 'Da'},
          parseResponse: any(named: 'parseResponse'),
        ),
      ).called(1);
      verify(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: {'matching': 'D'},
          parseResponse: any(named: 'parseResponse'),
        ),
      ).called(1);
      verify(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: {},
          parseResponse: any(named: 'parseResponse'),
        ),
      ).called(2); // Once for initial load, once for focus of search field
    });

    testWidgets('Filtering throws Error, shows error', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UserDataEntity(),
              field: field,
            )
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );

      when(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        return Future.error('Error when Filtering');
      });
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();

      expect(find.text('Error when Filtering'), findsOneWidget);
    });

    testWidgets('No collaborators shows nothing', (tester) async {
      final formUri = Uri.parse('form');
      const fieldWithoutLink =
          GridField(id: 'id', name: 'name', type: DataType.user);
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UserDataEntity(),
              field: fieldWithoutLink,
            )
          ],
          fields: [fieldWithoutLink],
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

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsNothing,
      );

      verifyNever(
        () => client.performApptiveLink<List<DataUser>>(
          link: any(named: 'link'),
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      );
    });

    testWidgets('Clear search value', (tester) async {
      final formUri = Uri.parse('form');
      when(() => client.loadForm(uri: formUri)).thenAnswer(
        (_) async => FormData(
          id: 'id',
          title: 'title',
          components: [
            FormComponent(
              required: true,
              property: 'name',
              data: UserDataEntity(),
              field: field,
            )
          ],
          fields: [field],
          links: {
            ApptiveLinkType.submit: submitLink,
          },
        ),
      );
      final user =
          DataUser(displayValue: 'Display', uri: Uri(path: '/users/id'));
      final user2 =
          DataUser(displayValue: 'Filter Out', uri: Uri(path: '/users/id'));
      when(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: any(named: 'queryParameters'),
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer((invocation) async {
        final parseResponse =
            invocation.namedArguments[const Symbol('parseResponse')]
                as Future<List<DataUser>?> Function(Response);
        final query =
            (invocation.namedArguments[const Symbol('queryParameters')]
                as Map<String, String>)['matching'];
        if (query == null || query.isEmpty) {
          return parseResponse(
            Response(
              jsonEncode([
                user.toJson(),
                user2.toJson(),
              ]),
              200,
            ),
          );
        } else if (query == 'D') {
          return parseResponse(
            Response(
              jsonEncode([
                user.toJson(),
              ]),
              200,
            ),
          );
        } else {
          return parseResponse(
            Response(
              jsonEncode([]),
              200,
            ),
          );
        }
      });
      final target = TestApp(
        client: client,
        child: ApptiveGridForm(
          uri: formUri,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserFormWidget));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsNWidgets(2),
      );

      await tester.enterText(find.byType(TextField), 'D');
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byType(DataUserWidget),
        ),
        findsNWidgets(2),
      );

      verify(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: {'matching': 'D'},
          parseResponse: any(named: 'parseResponse'),
        ),
      ).called(1);
      verify(
        () => client.performApptiveLink<List<DataUser>>(
          link: field.links[ApptiveLinkType.collaborators]!,
          queryParameters: {},
          parseResponse: any(named: 'parseResponse'),
        ),
      ).called(
        3,
      ); // Once for initial load, once for focus of search field, once after cleared input
    });
  });
}
