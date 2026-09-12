import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  const textField = GridField(
    id: 'textFieldId',
    name: 'name',
    type: DataType.text,
  );
  const checkBoxField = GridField(
    id: 'checkBoxFieldId',
    name: 'name',
    type: DataType.checkbox,
  );

  FormData formData({
    bool required = false,
    String? placeholder,
    bool withCheckBox = false,
  }) =>
      FormData(
        id: 'formId',
        title: 'Title',
        components: [
          FormComponent<StringDataEntity>(
            property: 'Text Property',
            data: StringDataEntity(),
            options: FormComponentOptions(
              label: 'Name',
              placeholder: placeholder,
            ),
            field: textField,
            required: required,
          ),
          if (withCheckBox)
            FormComponent<BooleanDataEntity>(
              property: 'CheckBox Property',
              data: BooleanDataEntity(false),
              options: const FormComponentOptions(label: 'Accept'),
              field: checkBoxField,
            ),
        ],
        fields: [textField, if (withCheckBox) checkBoxField],
        links: {},
      );

  InputDecoration? decorationOf(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField).first).decoration;

  group('Default', () {
    testWidgets('Label is part of the decoration', (tester) async {
      await tester.pumpWidget(
        TestApp(child: ApptiveGridFormData(formData: formData())),
      );
      await tester.pumpAndSettle();

      expect(decorationOf(tester)?.labelText, equals('Name'));
      // Only the floating label, no additional Text above the field
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('Required adds a star', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(formData: formData(required: true)),
        ),
      );
      await tester.pumpAndSettle();

      expect(decorationOf(tester)?.labelText, equals('Name *'));
    });
  });

  group('Label above', () {
    testWidgets('Label moves out of the decoration', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(
            formData: formData(),
            labelPosition: ApptiveGridLabelPosition.above,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(decorationOf(tester)?.labelText, isNull);
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('Required adds a star', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(
            formData: formData(required: true),
            labelPosition: ApptiveGridLabelPosition.above,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name *'), findsOneWidget);
    });

    testWidgets('Placeholder stays visible in the empty field', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(
            formData: formData(placeholder: 'e.g. Jane Doe'),
            labelPosition: ApptiveGridLabelPosition.above,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(decorationOf(tester)?.hintText, equals('e.g. Jane Doe'));
      expect(find.text('e.g. Jane Doe'), findsOneWidget);
    });

    testWidgets('CheckBox keeps its single inline label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(
            formData: formData(withCheckBox: true),
            labelPosition: ApptiveGridLabelPosition.above,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accept'), findsOneWidget);
    });

    testWidgets('Custom labelStyle is applied', (tester) async {
      const style = TextStyle(fontSize: 11, color: Colors.pink);
      await tester.pumpWidget(
        TestApp(
          child: ApptiveGridFormData(
            formData: formData(),
            labelPosition: ApptiveGridLabelPosition.above,
            labelStyle: style,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.text('Name')).style, equals(style));
    });

    testWidgets('Without labelStyle it falls back to the InputDecorationTheme',
        (tester) async {
      const themeStyle = TextStyle(fontSize: 23, color: Colors.teal);
      await tester.pumpWidget(
        TestApp(
          child: Theme(
            data: ThemeData(
              inputDecorationTheme:
                  const InputDecorationTheme(labelStyle: themeStyle),
            ),
            child: ApptiveGridFormData(
              formData: formData(),
              labelPosition: ApptiveGridLabelPosition.above,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.text('Name')).style, equals(themeStyle));
    });
  });

  group('Address sub fields', () {
    const addressField = GridField(
      id: 'addressFieldId',
      name: 'name',
      type: DataType.address,
    );

    // Key suffix of every sub field the AddressFormWidget renders below its
    // own label, mapped to the label it carries
    const subFields = {
      'line1': 'Address Line 1',
      'line2': 'Address Line 2',
      'postCode': 'Post Code',
      'city': 'City',
      'state': 'State',
      'country': 'Country',
    };

    Widget addressTarget(ApptiveGridLabelPosition position) {
      final geolocationClient = MockHttpClient();
      when(() => geolocationClient.get(any()))
          .thenAnswer((_) async => Response('{"predictions": []}', 200));
      return TestApp(
        options: ApptiveGridOptions(
          formWidgetConfigurations: [
            GeolocationFormWidgetConfiguration(
              placesApiKey: 'placesApiKey',
              httpClient: geolocationClient,
            ),
          ],
        ),
        child: ApptiveGridFormData(
          labelPosition: position,
          formData: FormData(
            id: 'formId',
            title: 'Title',
            components: [
              FormComponent<AddressDataEntity>(
                property: 'Address Property',
                data: AddressDataEntity(),
                options: const FormComponentOptions(label: 'Adresse'),
                field: addressField,
              ),
            ],
            fields: [addressField],
            links: {},
          ),
        ),
      );
    }

    InputDecoration? subFieldDecoration(WidgetTester tester, String key) =>
        tester
            .widget<TextField>(find.byKey(Key('AddressFormWidget.$key')))
            .decoration;

    testWidgets('Default keeps them in their decoration', (tester) async {
      await tester.pumpWidget(addressTarget(ApptiveGridLabelPosition.floating));
      await tester.pumpAndSettle();

      subFields.forEach((key, label) {
        expect(
          subFieldDecoration(tester, key)?.labelText,
          equals(label),
          reason: '$label belongs into the decoration of $key',
        );
      });
    });

    testWidgets('Label above moves them out of their decoration',
        (tester) async {
      await tester.pumpWidget(addressTarget(ApptiveGridLabelPosition.above));
      await tester.pumpAndSettle();

      subFields.forEach((key, label) {
        expect(
          subFieldDecoration(tester, key)?.labelText,
          isNull,
          reason: '$label should have left the decoration of $key',
        );
        // Shown exactly once, as a Text above the field
        expect(find.text(label), findsOneWidget);
      });
      // The component's own label is still shown next to the sub labels
      expect(find.text('Adresse'), findsOneWidget);
    });
  });
}
