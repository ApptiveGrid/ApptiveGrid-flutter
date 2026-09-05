import 'dart:convert';

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

  final resourcesLink = ApptiveLink(
    uri: Uri.parse('/api/users/u/spaces/s/resources?types=grid,form'),
    method: 'get',
  );
  final field = GridField(
    id: 'fieldId',
    name: 'name',
    type: DataType.resource,
    links: {ApptiveLinkType.resources: resourcesLink},
  );
  final formUri = Uri.parse('form');
  final submitUri = Uri(path: 'submit');
  final submitLink = ApptiveLink(uri: submitUri, method: 'post');

  Map<String, dynamic> resourceJson({
    required String href,
    required String name,
    required String type,
    required String metaType,
  }) =>
      {
        '_links': {
          'self': {'href': href, 'method': 'get'},
        },
        'displayValue': name,
        'name': name,
        'type': type,
        'metaType': metaType,
      };

  final gridJson = resourceJson(
    href: '/api/users/u/spaces/s/grids/g1',
    name: 'Customers',
    type: 'persistent',
    metaType: 'grid',
  );
  final formJson = resourceJson(
    href: '/api/users/u/spaces/s/grids/g1/forms/f1',
    name: 'Contact',
    type: 'form',
    metaType: 'form',
  );
  final flowInstanceJson = resourceJson(
    href: '/api/users/u/spaces/s/flows/fl/instances/i1',
    name: 'Run 1',
    type: 'flowInstance',
    metaType: 'flowNode',
  );

  void mockResources(List<Map<String, dynamic>> items) {
    when(
      () => client.performApptiveLink<List<DataResource>>(
        link: resourcesLink,
        parseResponse: any(named: 'parseResponse'),
      ),
    ).thenAnswer((invocation) async {
      final parseResponse =
          invocation.namedArguments[const Symbol('parseResponse')]
              as Future<List<DataResource>?> Function(Response);
      return parseResponse(Response(jsonEncode({'items': items}), 200));
    });
  }

  void mockForm({
    required GridField formField,
    ResourceDataEntity? data,
    bool required = false,
    bool disabled = false,
  }) {
    when(() => client.loadForm(uri: formUri)).thenAnswer(
      (_) async => FormData(
        id: 'id',
        title: 'title',
        components: [
          FormComponent(
            property: 'name',
            required: required,
            enabled: !disabled,
            data: data ?? ResourceDataEntity(),
            field: formField,
          ),
        ],
        fields: [formField],
        // Like the backend does it: whether a field is read-only is carried
        // by its FormFieldProperties, which the form applies when rendering.
        fieldProperties: [
          if (disabled)
            FormFieldProperties(fieldId: formField.id, disabled: true),
        ],
        links: {ApptiveLinkType.submit: submitLink},
      ),
    );
  }

  setUp(() {
    client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((_) async => []);
    when(() => client.submitFormWithProgress(submitLink, any())).thenAnswer(
      (_) => Stream.value(SubmitCompleteProgressEvent(Response('', 200))),
    );
  });

  group('Selecting', () {
    testWidgets('Selected resource is submitted as href reference',
        (tester) async {
      mockForm(formField: field);
      mockResources([gridJson, formJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ResourceFormWidget));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Contact').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(
        capturedForm.components!.first.data.value,
        equals(DataResource.fromJson(formJson)),
      );
      // The backend resolves the reference through `href`; the rest of the
      // object rides along so cached forms stay lossless.
      expect(
        capturedForm.toRequestObject()['fieldId'],
        containsPair('href', '/api/users/u/spaces/s/grids/g1/forms/f1'),
      );
    });

    testWidgets('Resources are grouped by meta type', (tester) async {
      mockForm(formField: field);
      mockResources([gridJson, formJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ResourceFormWidget));
      await tester.pumpAndSettle();

      expect(find.text('Grids and Views'), findsOneWidget);
      expect(find.text('Forms'), findsOneWidget);
      expect(find.text('Customers'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);
    });

    testWidgets('Flow instances are not offered', (tester) async {
      mockForm(formField: field);
      mockResources([gridJson, flowInstanceJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ResourceFormWidget));
      await tester.pumpAndSettle();

      expect(find.text('Customers'), findsOneWidget);
      expect(find.text('Run 1'), findsNothing);
    });
  });

  group('Existing value', () {
    testWidgets('Value is matched against the loaded list by href',
        (tester) async {
      mockForm(
        formField: field,
        data: ResourceDataEntity(
          DataResource.fromJson({
            'href': '/api/users/u/spaces/s/grids/g1',
            'name': 'Old Name',
          }),
        ),
      );
      mockResources([gridJson, formJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Customers'), findsOneWidget);
      expect(find.text('Old Name'), findsNothing);
    });

    testWidgets('Value that is not in the list is kept and submitted',
        (tester) async {
      final archived = DataResource.fromJson(
        resourceJson(
          href: '/api/users/u/spaces/s/grids/old',
          name: 'Archived',
          type: 'persistent',
          metaType: 'grid',
        ),
      );
      mockForm(formField: field, data: ResourceDataEntity(archived));
      mockResources([gridJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Archived'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final capturedForm =
          verify(() => client.submitFormWithProgress(submitLink, captureAny()))
              .captured
              .first as FormData;
      expect(
        capturedForm.toRequestObject()['fieldId'],
        containsPair('href', '/api/users/u/spaces/s/grids/old'),
      );
    });
  });

  group('Validation', () {
    testWidgets('Required without value shows error and does not submit',
        (tester) async {
      mockForm(formField: field, required: true);
      mockResources([gridJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verifyNever(() => client.submitFormWithProgress(submitLink, any()));
      expect(
        find.text('name must not be empty', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('Disabled component cannot be changed', (tester) async {
      mockForm(formField: field, disabled: true);
      mockResources([gridJson]);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      final dropdown = tester.widget<DropdownButtonFormField<DataResource>>(
        find.byType(DropdownButtonFormField<DataResource>),
      );
      expect(dropdown.onChanged, isNull);
    });
  });

  group('Loading', () {
    testWidgets('Without a resources link the client is not called',
        (tester) async {
      const fieldWithoutLink = GridField(
        id: 'fieldId',
        name: 'name',
        type: DataType.resource,
      );
      mockForm(formField: fieldWithoutLink);

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      verifyNever(
        () => client.performApptiveLink<List<DataResource>>(
          link: any(named: 'link'),
          parseResponse: any(named: 'parseResponse'),
        ),
      );
      expect(
        find.byType(DropdownButtonFormField<DataResource>),
        findsOneWidget,
      );
    });

    testWidgets('Loading error is shown on the field', (tester) async {
      mockForm(formField: field);
      when(
        () => client.performApptiveLink<List<DataResource>>(
          link: resourcesLink,
          parseResponse: any(named: 'parseResponse'),
        ),
      ).thenAnswer(
        (_) => Future<List<DataResource>?>.error(Exception('boom')),
      );

      await tester.pumpWidget(
        TestApp(client: client, child: ApptiveGridForm(uri: formUri)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Exception: boom'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<DataResource>), findsNothing);
    });
  });
}
