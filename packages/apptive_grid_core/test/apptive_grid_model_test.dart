import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Request('GET', Uri()));
  });

  final link = ApptiveLink(uri: Uri.parse('/apptive/link'), method: 'get');
  late ApptiveGridClient apptiveGridClient;
  late StreamedResponse response;

  StreamedResponse createResponse(dynamic response) {
    return StreamedResponse(
        Stream.value(utf8.encode(jsonEncode(response))), 200);
  }

  setUp(() {
    final httpClient = MockHttpClient();
    final authenticator = MockApptiveGridAuthenticator();
    when(() => authenticator.checkAuthentication()).thenAnswer((_) async {});
    apptiveGridClient = ApptiveGridClient(
      httpClient: httpClient,
      authenticator: authenticator,
    );
    when(
      () => httpClient.send(
        any(
          that: predicate<BaseRequest>(
            (request) =>
                request.url.scheme == 'https' &&
                request.url.host.endsWith('apptivegrid.de') &&
                request.url.path == link.uri.path &&
                request.method == link.method,
          ),
        ),
      ),
    ).thenAnswer((realInvocation) async {
      return response;
    });
  });

  group('Grid', () {
    final gridJson = {
      'fieldNames': [
        'TextC',
        'NumberC',
        'DateTimeC',
        'DateC',
        'New field',
        'New field 2',
        'CheckmarkC',
        'Enums',
      ],
      'entities': [
        {
          'fields': [
            'Hello',
            1,
            '2020-12-08T01:00:00.000Z',
            '2020-12-13',
            null,
            null,
            true,
            'Enum1'
          ],
          '_id': '3ojhtqm2bgtwzpdbktuv6syv5',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
        {
          'fields': [
            'Hola Web',
            1,
            '2020-12-14T09:12:00.000Z',
            '2020-12-15',
            null,
            null,
            true,
            'Enum2'
          ],
          '_id': '6bs7tqexlcy88cry3qzzvjbyz',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
        {
          'fields': [null, null, null, null, null, null, false, null],
          '_id': '6bs7tqf61rppn1nixxb6cr7se',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
        {
          'fields': [
            'AAA',
            null,
            '2020-12-14T11:42:00.000Z',
            '2020-12-17',
            null,
            null,
            true,
            'Enum2'
          ],
          '_id': 'bxzfxf43vaeefhje6xcmnofa8',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
        {
          'fields': [
            'TTTTTTT',
            12312344,
            '2020-12-14T06:00:00.000Z',
            '2020-12-16',
            null,
            null,
            true,
            null
          ],
          '_id': 'bxzfxf72k3j4d5fcmk6w0pa4s',
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        },
      ],
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
              {'type': 'integer'},
              {'type': 'string', 'format': 'date-time'},
              {'type': 'string', 'format': 'date'},
              {'type': 'string'},
              {'type': 'string'},
              {'type': 'boolean'},
              {
                'type': 'string',
                'enum': [
                  'Enum1',
                  'Enum2',
                ]
              },
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'fields': [
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "String",
          "schema": {"type": "string"},
          "id": "6282104004bd30efc49b7f17",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "integer",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "Number",
          "schema": {"type": "integer"},
          "id": "6282106a04bd30163b9b7f3b",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "date-time",
            "componentTypes": ["datePicker"]
          },
          "key": null,
          "name": "DateTime",
          "schema": {"type": "string", "format": "date-time"},
          "id": "6282104e04bd30efc49b7f22",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "date",
            "componentTypes": ["datePicker", "textfield"]
          },
          "key": null,
          "name": "Date",
          "schema": {"type": "string", "format": "date"},
          "id": "6282105c04bd30efc49b7f2e",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "String",
          "schema": {"type": "string"},
          "id": "6282104004bd30efc49b7f17",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "String",
          "schema": {"type": "string"},
          "id": "6282104004bd30efc49b7f17",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "boolean",
            "componentTypes": ["checkbox"]
          },
          "key": null,
          "name": "Checkmark",
          "schema": {"type": "boolean"},
          "id": "6282107c04bd30163b9b7f4d",
          "_links": <String, dynamic>{}
        },
        {
          "type": {
            "name": "enum",
            "options": ["A", "B"],
            "componentTypes": ["selectBox"]
          },
          "key": null,
          "name": "SingleSelect",
          "schema": {
            "type": "string",
            "enum": ["Enum1", "Enum2"]
          },
          "id": "6282108604bd30163b9b7f56",
          "_links": <String, dynamic>{}
        },
      ],
      'hiddenFields': [
        {
          "type": {
            "name": "string",
            "componentTypes": ["textfield"]
          },
          "key": null,
          "name": "Hidden Field",
          "schema": {"type": "string"},
          "id": "hiddenId",
          "_links": <String, dynamic>{}
        },
      ],
      '_embedded': {
        "forms": [
          {
            "name": "Formular 1",
            "id": "formId",
            "_links": {
              "self": {
                "href":
                    "/api/users/userId/spaces/spaceId/grids/gridId/forms/formId",
                "method": "get"
              }
            }
          }
        ]
      },
      'name': 'New grid',
      'id': 'gridId',
      'key': 'gridKey',
      '_links': {
        "addLink": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/AddLink",
          "method": "post"
        },
        "forms": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "get"
        },
        "updateFieldType": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnTypeChange",
          "method": "post"
        },
        "removeField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRemove",
          "method": "post"
        },
        "addEntity": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "post"
        },
        "views": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "get"
        },
        "addView": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "post"
        },
        "self": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "get"
        },
        "updateFieldKey": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnKeyChange",
          "method": "post"
        },
        "query": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/query",
          "method": "get"
        },
        "entities": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "get"
        },
        "updates": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/updates",
          "method": "get"
        },
        "schema": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/schema",
          "method": "get"
        },
        "updateFieldName": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRename",
          "method": "post"
        },
        "addForm": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "post"
        },
        "addField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnAdd",
          "method": "post"
        },
        "rename": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/Rename",
          "method": "post"
        },
        "remove": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "delete"
        }
      },
    };

    test('Single Grid', () async {
      response = createResponse(gridJson);

      final grid = await apptiveGridClient.performApptiveLink<Grid>(link: link);
      expect(grid, predicate((result) => result is Grid));
    });

    test('Simple List', () async {
      response = createResponse([gridJson]);

      final result =
          await apptiveGridClient.performApptiveLink<List<Grid>>(link: link);
      expect(result, predicate((result) => result is List<Grid>));
    });

    test('Nested List', () async {
      response = createResponse({
        'items': [gridJson],
      });

      final result =
          await apptiveGridClient.performApptiveLink<List<Grid>>(link: link);
      expect(result, predicate((result) => result is List<Grid>));
    });
  });
}
