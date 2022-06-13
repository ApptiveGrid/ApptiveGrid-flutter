import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      "fieldNames": ["Location"],
      "sorting": [],
      "entities": [
        {
          "fields": [
            {
              'lon': 6.944374229580692,
              'lat': 50.90713366617792,
            },
          ],
          "_id": "61b08a87aa660541e58f58ef",
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get"
            },
          },
        }
      ],
      "fieldIds": ["78lnph2fb2olm9jtc696d66q9"],
      "filter": {},
      'fields': [
        {
          "type": {
            "name": "geolocation",
            "componentTypes": ["locationPicker"]
          },
          "key": null,
          "name": "Geolocation",
          "schema": {
            "type": "object",
            "properties": {
              "lat": {"type": "number", "format": "double"},
              "lon": {"type": "number", "format": "double"}
            },
            "required": ["lat", "lon"],
            "objectType": "geolocation"
          },
          "id": "628210c204bd301aa89b7f8a",
          "_links": {}
        },
      ],
      "name": "Test Ansicht",
      'id': 'gridId',
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
    final rawResponseWithNullValue = {
      "fieldNames": ["Location"],
      "sorting": [],
      "entities": [
        {
          "fields": [null],
          "_id": "61b08a87aa660541e58f58ef"
        }
      ],
      "fieldIds": ["78lnph2fb2olm9jtc696d66q9"],
      "filter": {},
      'fields': [
        {
          "type": {
            "name": "geolocation",
            "componentTypes": ["locationPicker"]
          },
          "key": null,
          "name": "Geolocation",
          "schema": {
            "type": "object",
            "properties": {
              "lat": {"type": "number", "format": "double"},
              "lon": {"type": "number", "format": "double"}
            },
            "required": ["lat", "lon"],
            "objectType": "geolocation"
          },
          "id": "628210c204bd301aa89b7f8a",
          "_links": {}
        },
      ],
      "name": "Test Ansicht",
      'id': 'gridId',
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

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        GeolocationDataEntity.fromJson(
          {
            'lon': 6.944374229580692,
            'lat': 50.90713366617792,
          },
        ),
      );
    });

    test('Grid With null value Parses Correctly', () {
      final grid = Grid.fromJson(rawResponseWithNullValue);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        GeolocationDataEntity(),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithAttachment = {
        'fields': [
          {
            "type": {
              "name": "geolocation",
              "componentTypes": ["locationPicker"]
            },
            "schema": {
              "type": "object",
              "properties": {
                "lat": {"type": "number", "format": "double"},
                "lon": {"type": "number", "format": "double"}
              },
              "required": ["lat", "lon"],
              "objectType": "geolocation"
            },
            "id": "78lnph2fb2olm9jtc696d66q9",
            "name": "Property",
            "key": null,
            "_links": {}
          }
        ],
        "title": "New title",
        "name": "Formular 1",
        "components": [
          {
            "property": "Location",
            "value": {
              'lon': 6.944374229580692,
              'lat': 50.90713366617792,
            },
            "required": false,
            "options": {"label": null, "description": null},
            "fieldId": "78lnph2fb2olm9jtc696d66q9",
            "type": "locationPicker"
          }
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ],
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

      final formData = FormData.fromJson(responseWithAttachment);

      final fromJson = formData.components![0];

      final directEntity = GeolocationDataEntity(
        const Geolocation(
          longitude: 6.944374229580692,
          latitude: 50.90713366617792,
        ),
      );

      final direct = FormComponent<GeolocationDataEntity>(
        property: 'Location',
        data: directEntity,
        field: GridField(
          id: '78lnph2fb2olm9jtc696d66q9',
          name: 'Property',
          type: DataType.geolocation,
        ),
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });

  group('Geolocation', () {
    test('Equality', () {
      const one = Geolocation(
        latitude: 47,
        longitude: 11,
      );

      final two = Geolocation.fromJson(
        {
          'lon': 11,
          'lat': 47,
        },
      );

      expect(one, equals(two));
      expect(one.hashCode, equals(two.hashCode));
    });
  });
}
