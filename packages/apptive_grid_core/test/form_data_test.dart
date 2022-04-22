import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const title = 'title';
  const name = 'name';
  final response = {
    'schema': {
      'type': 'object',
      'properties': {
        '4zc4l4c5coyi7qh6q1ozrg54u': {'type': 'string', 'format': 'date-time'},
        '4zc4l456pca5ursrt9rxefpsc': {'type': 'boolean'},
        '4zc4l49to77dhfagr844flaey': {'type': 'string', 'format': 'date'},
        '4zc4l45nmww7ujq7y4axlbtjg': {'type': 'string'},
        '4zc4l48ffin5v8pa2emyx9s15': {'type': 'integer'}
      },
      'required': []
    },
    'actions': [
      {'uri': '/api/a/95fzpo7jg09dthz394nkdf21g', 'method': 'POST'}
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
          'label': null
        },
        'fieldId': '4zc4l45nmww7ujq7y4axlbtjg',
        'type': 'textfield'
      },
      {
        'property': 'NumberC',
        'value': null,
        'required': false,
        'options': {
          'multi': false,
          'placeholder': '',
          'description': 'Number description',
          'label': 'Number Label'
        },
        'fieldId': '4zc4l48ffin5v8pa2emyx9s15',
        'type': 'textfield'
      },
      {
        'property': 'DateTimeC',
        'value': null,
        'required': false,
        'options': {
          'label': 'DateTime Label',
          'description': 'DateTime Description'
        },
        'fieldId': '4zc4l4c5coyi7qh6q1ozrg54u',
        'type': 'datePicker'
      },
      {
        'property': 'DateC',
        'value': null,
        'required': false,
        'options': {'label': 'Date Label', 'description': 'Date Description'},
        'fieldId': '4zc4l49to77dhfagr844flaey',
        'type': 'datePicker'
      },
      {
        'property': 'CheckmarkC',
        'value': null,
        'required': false,
        'options': {
          'label': 'Checkbox Label',
          'description': 'Checkbox Description'
        },
        'fieldId': '4zc4l456pca5ursrt9rxefpsc',
        'type': 'checkbox'
      }
    ],
    'name': name,
    'title': title,
    'id': 'formId',
    '_links': {
      "submit": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "post"
      },
      "remove": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "delete"
      },
      "self": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "get"
      },
      "update": {
        "href":
            "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
        "method": "put"
      }
    },
  };

  group('Parsing', () {
    test('Successful', () {
      final formData = FormData.fromJson(response);

      expect(formData.name, equals(name));
      expect(formData.title, equals(title));

      expect(formData.actions!.length, equals(1));

      expect(formData.components!.length, equals(5));

      expect(formData.components!.map((e) => e.runtimeType).toList(), [
        StringFormComponent,
        IntegerFormComponent,
        DateTimeFormComponent,
        DateFormComponent,
        BooleanFormComponent,
      ]);
    });
  });

  group('Serializing', () {
    test('toJson -> fromJson -> equals', () {
      final action = FormAction('/uri', 'POST');
      final schema = response['schema'];
      final component = IntegerFormComponent(
        fieldId: '4zc4l48ffin5v8pa2emyx9s15',
        options: const TextComponentOptions(),
        property: 'NumberC',
        data: IntegerDataEntity(),
      );

      final formData = FormData(
        id: 'formId',
        name: 'name',
        title: title,
        components: [component],
        actions: [action],
        links: {},
        schema: schema,
      );

      expect(FormData.fromJson(formData.toJson()), equals(formData));
    });

    test('AttachmentActions get Restored', () {
      final action = FormAction('/uri', 'POST');
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
                'type': {'type': 'string'}
              },
              'required': ['url', 'type'],
              'objectType': 'attachment'
            }
          },
        },
        'required': []
      };
      final attachment = Attachment(name: 'name', url: Uri(), type: 'type');
      final component = AttachmentFormComponent(
        fieldId: '4zc4l48ffin5v8pa2emyx9s15',
        options: const TextComponentOptions(),
        property: 'NumberC',
        data: AttachmentDataEntity([attachment]),
      );

      final formData = FormData(
        id: 'formId',
        name: 'name',
        title: title,
        components: [component],
        actions: [action],
        links: {},
        schema: schema,
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
      final formWithoutComponents = FormData.fromJson(FormData.fromJson(response).toJson()..['components'] = null);


      expect(
        formWithoutComponents
            .toRequestObject()
            .cast<dynamic, String?>(),
        equals({}),
      );
    });
  });

  group('Equality', () {
    final action = FormAction('/uri', 'POST');
    final schema = response['schema'];
    final component = IntegerFormComponent(
      fieldId: '4zc4l48ffin5v8pa2emyx9s15',
      data: IntegerDataEntity(),
      options: const TextComponentOptions(),
      property: 'NumberC',
    );

    final a = FormData(
      id: 'formId',
      name: 'name',
      title: title,
      components: [component],
      actions: [action],
      links: {},
      schema: schema,
    );
    final b = FormData(
      id: 'formId',
      name: 'name',
      title: title,
      components: [component],
      actions: [action],
      links: {},
      schema: schema,
    );
    final c = FormData.fromJson(response);

    test('a == b', () {
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a != c', () {
      expect(a, isNot(c));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('Without Actions', () {
    final responseWithoutActions = {
      'schema': {
        'type': 'object',
        'properties': {
          'b8qscjhfw5mukbred3tae8bd2': {'type': 'string'}
        },
        'required': []
      },
      'schemaObject':
          '/api/users/609bc536dad545d1af7e82db/spaces/60ae6036e65b14482e7f99ac/grids/60ae6039e65b14482e7f99af',
      'components': [
        {
          'property': 'name',
          'value': '123',
          'required': false,
          'options': {
            'multi': false,
            'placeholder': null,
            'description': null,
            'label': null
          },
          'fieldId': 'b8qscjhfw5mukbred3tae8bd2',
          'type': 'textfield'
        }
      ],
      'name': 'Name',
      'title': 'New title',
      'id': 'formId',
      '_links': {
        "submit": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "post"
        },
        "remove": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "delete"
        },
        "self": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "get"
        },
        "update": {
          "href":
              "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
          "method": "put"
        }
      },
    };
    test('Form Without Actions parses correctly', () {
      final formData = FormData.fromJson(responseWithoutActions);

      expect(formData.actions, isNull);
    });
  });

  group('Cross Reference', () {
    test('Form with Cross Reference without Value parses', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'uri': {'type': 'string'}
              },
              'required': ['uri'],
              'objectType': 'entityreference',
              'gridUri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': null,
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'name': 'Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post"
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete"
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get"
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put"
          }
        },
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, equals('New title'));
      expect(
        formData.components![0].runtimeType,
        equals(CrossReferenceFormComponent),
      );
      expect(formData.components![0].data.value, equals(null));
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).entityUri,
        null,
      );
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).gridUri,
        GridUri.fromUri(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        ),
      );
    });

    test('Form with Cross Reference with prefilled Value parses', () {
      final responseWithCrossReference = {
        'schema': {
          'type': 'object',
          'properties': {
            '3ftoqhqbct15h5o730uknpvp5': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'uri': {'type': 'string'}
              },
              'required': ['uri'],
              'objectType': 'entityreference',
              'gridUri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06'
            }
          },
          'required': []
        },
        'schemaObject':
            '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036e50edfa83071816e03',
        'components': [
          {
            'property': 'name',
            'value': {
              'displayValue': 'Yeah!',
              'uri':
                  '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d'
            },
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': '3ftoqhqbct15h5o730uknpvp5',
            'type': 'entitySelect'
          }
        ],
        'name': 'Name',
        'title': 'New title',
        'id': 'formId',
        '_links': {
          "submit": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "post"
          },
          "remove": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "delete"
          },
          "self": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "get"
          },
          "update": {
            "href":
                "/api/users/614c5440b50f51e3ea8a2a50/spaces/62600bf5d7f0d75408996f69/grids/62600bf9d7f0d75408996f6c/forms/6262aadbcd22c4725899a114",
            "method": "put"
          }
        },
      };

      final formData = FormData.fromJson(responseWithCrossReference);

      expect(formData.title, equals('New title'));
      expect(
        formData.components![0].runtimeType,
        equals(CrossReferenceFormComponent),
      );
      expect(formData.components![0].data.value, equals('Yeah!'));
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).entityUri,
        EntityUri.fromUri(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/entities/60d036ff0edfa83071816e0d',
        ),
      );
      expect(
        (formData.components![0].data as CrossReferenceDataEntity).gridUri,
        GridUri.fromUri(
          '/api/users/609bc536dad545d1af7e82db/spaces/60d036dc0edfa83071816e00/grids/60d036f00edfa83071816e07/views/60d036f00edfa83071816e06',
        ),
      );
    });
  });
}
