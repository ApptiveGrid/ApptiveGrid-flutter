import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const title = 'title';
  const name = 'name';
  const description = 'description';
  const submitButtonTitle = 'submitButton';
  const additionalAnswerButtonTitle = 'additionalAnswerButton';
  const reloadAfterSubmit = true;
  const successTitle = 'successTitle';
  const successMessage = 'successMessage';
  final response = {
    'fields': [
      {
        "type": {
          "name": "date-time",
          "componentTypes": ["datePicker"],
        },
        "schema": {"type": "string", "format": "date-time"},
        "id": "4zc4l4c5coyi7qh6q1ozrg54u",
        "name": "Date Time",
        "key": null,
        "_links": <String, dynamic>{},
      },
      {
        "type": {
          "name": "boolean",
          "componentTypes": ["checkbox"],
        },
        "schema": {"type": "boolean"},
        "id": "4zc4l456pca5ursrt9rxefpsc",
        "name": "Checkmark",
        "key": null,
        "_links": <String, dynamic>{},
      },
      {
        "type": {
          "name": "date",
          "componentTypes": ["datePicker", "textfield"],
        },
        "schema": {"type": "string", "format": "date"},
        "id": "4zc4l49to77dhfagr844flaey",
        "name": "Date",
        "key": null,
        "_links": <String, dynamic>{},
      },
      {
        "type": {
          "name": "string",
          "componentTypes": ["textfield"],
        },
        "schema": {"type": "string"},
        "id": "4zc4l45nmww7ujq7y4axlbtjg",
        "name": "Text",
        "key": null,
        "_links": <String, dynamic>{},
      },
      {
        "type": {
          "name": "integer",
          "componentTypes": ["textfield"],
        },
        "schema": {"type": "integer"},
        "id": "4zc4l48ffin5v8pa2emyx9s15",
        "name": "Number",
        "key": null,
        "_links": <String, dynamic>{},
      },
    ],
    'components': [
      {
        'property': 'TextC',
        'value': null,
        'required': false,
        'options': {
          'multi': false,
          'placeholder': '',
          'description': 'Text Description',
          'label': null,
        },
        'fieldId': '4zc4l45nmww7ujq7y4axlbtjg',
        'type': 'textfield',
      },
      {
        'property': 'NumberC',
        'value': null,
        'required': false,
        'options': {
          'multi': false,
          'placeholder': '',
          'description': 'Number description',
          'label': 'Number Label',
        },
        'fieldId': '4zc4l48ffin5v8pa2emyx9s15',
        'type': 'textfield',
      },
      {
        'property': 'DateTimeC',
        'value': null,
        'required': false,
        'options': {
          'label': 'DateTime Label',
          'description': 'DateTime Description',
        },
        'fieldId': '4zc4l4c5coyi7qh6q1ozrg54u',
        'type': 'datePicker',
      },
      {
        'property': 'DateC',
        'value': null,
        'required': false,
        'options': {'label': 'Date Label', 'description': 'Date Description'},
        'fieldId': '4zc4l49to77dhfagr844flaey',
        'type': 'datePicker',
      },
      {
        'property': 'CheckmarkC',
        'value': null,
        'required': false,
        'options': {
          'label': 'Checkbox Label',
          'description': 'Checkbox Description',
        },
        'fieldId': '4zc4l456pca5ursrt9rxefpsc',
        'type': 'checkbox',
      }
    ],
    'name': name,
    'title': title,
    'description': description,
    'id': 'formId',
    'properties': {
      'buttonTitle': submitButtonTitle,
      'reloadAfterSubmit': reloadAfterSubmit,
      'successTitle': successTitle,
      'successMessage': successMessage,
      'afterSubmitAction': {
        'action': 'additionalAnswer',
        'trigger': 'button',
        'buttonTitle': additionalAnswerButtonTitle,
      },
    },
    '_links': {
      "submit": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "post",
      },
      "remove": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "delete",
      },
      "self": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "get",
      },
      "update": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "put",
      },
    },
  };

  group('Parsing', () {
    test('Successful', () {
      final formData = FormData.fromJson(response);

      expect(formData.name, equals(name));
      expect(formData.title, equals(title));
      expect(formData.description, equals(description));

      expect(formData.links[ApptiveLinkType.submit], isNotNull);

      expect(formData.components!.length, equals(5));

      expect(formData.components!.map((e) => e.data.runtimeType).toList(), [
        StringDataEntity,
        IntegerDataEntity,
        DateTimeDataEntity,
        DateDataEntity,
        BooleanDataEntity,
      ]);

      expect(
        formData.properties,
        FormDataProperties(
          successTitle: successTitle,
          successMessage: successMessage,
          buttonTitle: submitButtonTitle,
          reloadAfterSubmit: reloadAfterSubmit,
          afterSubmitAction: const AfterSubmitAction(
            type: AfterSubmitActionType.additionalAnswer,
            trigger: AfterSubmitActionTrigger.button,
            buttonTitle: additionalAnswerButtonTitle,
          ),
        ),
      );
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
      final schema = response['schema'];
      final component = FormComponent<IntegerDataEntity>(
        field: GridField(
          id: 'Integer',
          name: 'Property',
          type: DataType.integer,
          schema: schema,
        ),
        options: const FormComponentOptions(),
        property: 'NumberC',
        data: IntegerDataEntity(),
      );

      final formData = FormData(
        id: 'formId',
        name: name,
        title: title,
        description: description,
        components: [component],
        links: {ApptiveLinkType.submit: action},
        fields: [component.field],
        properties: FormDataProperties(
          buttonTitle: submitButtonTitle,
          reloadAfterSubmit: reloadAfterSubmit,
          successTitle: successTitle,
          successMessage: successMessage,
        ),
      );

      expect(FormData.fromJson(formData.toJson()), equals(formData));
    });

    test('AttachmentActions get Restored', () {
      final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
      final schema = {
        'type': 'object',
        'properties': {
          '4zc4l48ffin5v8pa2emyx9s15': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'smallThumbnail': {'type': 'string'},
                'url': {'type': 'string'},
                'largeThumbnail': {'type': 'string'},
                'name': {'type': 'string'},
                'type': {'type': 'string'},
              },
              'required': ['url', 'type'],
              'objectType': 'attachment',
            },
          },
        },
        'required': [],
      };
      final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
      final component = FormComponent<AttachmentDataEntity>(
        field: GridField(
          id: '4zc4l48ffin5v8pa2emyx9s15',
          name: 'Property',
          type: DataType.attachment,
          schema: schema,
        ),
        options: const FormComponentOptions(),
        property: 'NumberC',
        data: AttachmentDataEntity([attachment]),
      );

      final formData = FormData(
        id: 'formId',
        name: 'name',
        title: title,
        components: [component],
        links: {ApptiveLinkType.submit: action},
        fields: [component.field],
      );

      final attachmentAction =
          RenameAttachmentAction(newName: 'newName', attachment: attachment);

      formData.attachmentActions[attachment] = attachmentAction;

      expect(
        FormData.fromJson(formData.toJson()).attachmentActions,
        equals({attachment: attachmentAction}),
      );
    });
  });

  group('Validation', () {
    test('toRequestObject contains Null Values', () {
      final formData = FormData.fromJson(response);

      expect(
        formData
            .toRequestObject()
            .cast<dynamic, String?>()
            .values
            .where((element) => element == null || element.isEmpty),
        isNot([]),
      );
    });

    test('toRequestObject returns Empty Map for non component', () {
      final formWithoutComponents = FormData.fromJson(
        FormData.fromJson(response).toJson()..['components'] = null,
      );

      expect(
        formWithoutComponents.toRequestObject().cast<dynamic, String?>(),
        equals({}),
      );
    });
  });

  group('Equality', () {
    final action = ApptiveLink(uri: Uri.parse('/uri'), method: 'POST');
    final schema = response['schema'];
    final component = FormComponent<IntegerDataEntity>(
      field: GridField(
        id: '4zc4l48ffin5v8pa2emyx9s15',
        name: 'Property',
        type: DataType.integer,
        schema: schema,
      ),
      data: IntegerDataEntity(),
      options: const FormComponentOptions(),
      property: 'NumberC',
    );

    final a = FormData(
      id: 'formId',
      name: 'name',
      title: title,
      components: [component],
      links: {ApptiveLinkType.submit: action},
      fields: [component.field],
      properties: FormDataProperties(
        successTitle: 'success',
      ),
    );
    final b = FormData(
      id: 'formId',
      name: 'name',
      title: title,
      components: [component],
      links: {ApptiveLinkType.submit: action},
      fields: [component.field],
      properties: FormDataProperties(
        successTitle: 'success',
      ),
    );
    final c = FormData.fromJson(response);

    test('a == b', () {
      expect(a, equals(b));
    });

    test('a != c', () {
      expect(a, isNot(c));
    });
  });

  group('Without Submit Link', () {
    final responseWithoutSubmitLink = {
      'fields': [
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"],
          },
          "schema": {"type": "string"},
          "id": "b8qscjhfw5mukbred3tae8bd2",
          "name": "Text",
          "key": null,
          "_links": <String, dynamic>{},
        },
      ],
      'components': [
        {
          'property': 'name',
          'value': '123',
          'required': false,
          'options': {
            'multi': false,
            'placeholder': null,
            'description': null,
            'label': null,
          },
          'fieldId': 'b8qscjhfw5mukbred3tae8bd2',
          'type': 'textfield',
        }
      ],
      'name': 'Name',
      'title': 'New title',
      'id': 'formId',
      '_links': {
        "remove": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "delete",
        },
        "self": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "get",
        },
        "update": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "put",
        },
      },
    };
    test('Form Without Actions parses correctly', () {
      final formData = FormData.fromJson(responseWithoutSubmitLink);

      expect(formData.links[ApptiveLinkType.submit], isNull);
    });
  });

  group('Cross Reference', () {
    test('Form with Cross Reference without Value parses', () {
      final responseWithCrossReference = {
        'fields': [
          {
            "type": {
              "name": "reference",
              "componentTypes": ["entitySelect"],
            },
            "schema": {
              "type": "object",
              "properties": {
                "displayValue": {"type": "string"},
                "uri": {"type": "string"},
              },
              "required": ["uri"],
              "objectType": "entityreference",
              "gridUri":
                  "/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06",
            },
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "name": "Cross Ref",
            "key": null,
            "_links": <String, dynamic>{},
          }
        ],
        'components': [
          {
            'property': 'name',
            'value': null,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect',
          }
        ],
        'name': 'Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post",
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete",
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get",
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put",
          },
        },
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, equals('New title'));
      expect(
        formData.components![0].data.runtimeType,
        equals(CrossReferenceDataEntity),
      );
      expect(formData.components![0].data.value, equals(null));
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).entityUri,
        null,
      );
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).gridUri,
        Uri.parse(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        ),
      );
    });

    test('Form with Cross Reference with prefilled Value parses', () {
      final responseWithCrossReference = {
        'fields': [
          {
            "type": {
              "name": "reference",
              "componentTypes": ["entitySelect"],
            },
            "schema": {
              "type": "object",
              "properties": {
                "displayValue": {"type": "string"},
                "uri": {"type": "string"},
              },
              "required": ["uri"],
              "objectType": "entityreference",
              "gridUri":
                  "/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06",
            },
            "id": "3ftoqhqbct15h5o730uknpvp5",
            "name": "Cross Ref",
            "key": null,
            "_links": <String, dynamic>{},
          }
        ],
        'components': [
          {
            'property': 'name',
            'value': {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d',
            },
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect',
          }
        ],
        'name': 'Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post",
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete",
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get",
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put",
          },
        },
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, equals('New title'));
      expect(
        formData.components![0].data.runtimeType,
        equals(CrossReferenceDataEntity),
      );
      expect(formData.components![0].data.value, equals('Yeah!'));
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).entityUri,
        Uri.parse(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d',
        ),
      );
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).gridUri,
        Uri.parse(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        ),
      );
    });
  });
  group('FormDataProperties', () {
    test('Equality', () {
      final a = FormDataProperties(
        successTitle: 'successTitle',
        successMessage: 'successMessage',
        buttonTitle: 'buttonTitle',
        reloadAfterSubmit: true,
      );
      final b = FormDataProperties(
        successTitle: 'successTitle',
        successMessage: 'successMessage',
        buttonTitle: 'buttonTitle',
        reloadAfterSubmit: true,
      );
      final c = FormDataProperties(
        successTitle: 'successTitle',
        successMessage: 'successMessage',
        buttonTitle: 'buttonTitle2',
        reloadAfterSubmit: true,
      );
      expect(a, equals(b));
      expect(a, isNot(c));
    });

    test('Hashcode', () {
      final properties = FormDataProperties(
        successTitle: 'successTitle',
        successMessage: 'successMessage',
        buttonTitle: 'buttonTitle',
        reloadAfterSubmit: true,
      );

      expect(
        properties.hashCode,
        Object.hash(
          'successTitle',
          'successMessage',
          'buttonTitle',
          true,
          null,
        ),
      );
    });

    test('toString()', () {
      final properties = FormDataProperties(
        successTitle: 'successTitle',
        successMessage: 'successMessage',
        buttonTitle: 'buttonTitle',
        reloadAfterSubmit: true,
      );

      expect(
        properties.toString(),
        equals(
          'FormDataProperties(successTitle: successTitle, successMessage: successMessage, buttonTitle: buttonTitle, reloadAfterSubmit: true, afterSubmitAction: null)',
        ),
      );
    });

    group('AfterSubmitAction', () {
      test('Equality', () {
        const a = AfterSubmitAction(
          type: AfterSubmitActionType.additionalAnswer,
          trigger: AfterSubmitActionTrigger.button,
          buttonTitle: additionalAnswerButtonTitle,
        );
        const b = AfterSubmitAction(
          type: AfterSubmitActionType.additionalAnswer,
          trigger: AfterSubmitActionTrigger.button,
          buttonTitle: additionalAnswerButtonTitle,
        );
        const c = AfterSubmitAction(
          type: AfterSubmitActionType.additionalAnswer,
          trigger: AfterSubmitActionTrigger.auto,
          buttonTitle: additionalAnswerButtonTitle,
        );
        expect(a, equals(b));
        expect(a, isNot(c));
      });

      test('Hashcode', () {
        const action = AfterSubmitAction(
          type: AfterSubmitActionType.additionalAnswer,
          trigger: AfterSubmitActionTrigger.button,
          buttonTitle: additionalAnswerButtonTitle,
        );

        expect(
          action.hashCode,
          Object.hash(
            AfterSubmitActionType.additionalAnswer,
            additionalAnswerButtonTitle,
            AfterSubmitActionTrigger.button,
            null,
            null,
          ),
        );
      });

      test('toString()', () {
        const action = AfterSubmitAction(
          type: AfterSubmitActionType.additionalAnswer,
          trigger: AfterSubmitActionTrigger.button,
          buttonTitle: additionalAnswerButtonTitle,
        );

        expect(
          action.toString(),
          equals(
            'AfterSubmitAction(type: AfterSubmitActionType.additionalAnswer, buttonTitle: $additionalAnswerButtonTitle, trigger: AfterSubmitActionTrigger.button, delay: null, targetUrl: null)',
          ),
        );
      });
    });
  });
}
