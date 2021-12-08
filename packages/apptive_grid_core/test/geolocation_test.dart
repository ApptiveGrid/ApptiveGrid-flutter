import 'dart:convert';

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
            [6.944374229580692, 50.90713366617792]
          ],
          "_id": "61b08a87aa660541e58f58ef"
        }
      ],
      "fieldIds": ["78lnph2fb2olm9jtc696d66q9"],
      "filter": {},
      "schema": {
        "type": "object",
        "properties": {
          "fields": {
            "type": "array",
            "items": [
              {
                "type": "array",
                "items": [
                  {"type": "number", "format": "double"},
                  {"type": "number", "format": "double"}
                ]
              }
            ]
          },
          "_id": {"type": "string"}
        }
      },
      "name": "Test Ansicht"
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
      "schema": {
        "type": "object",
        "properties": {
          "fields": {
            "type": "array",
            "items": [
              {
                "type": "array",
                "items": [
                  {"type": "number", "format": "double"},
                  {"type": "number", "format": "double"}
                ]
              }
            ]
          },
          "_id": {"type": "string"}
        }
      },
      "name": "Test Ansicht"
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields.length, 1);
      expect(
        grid.rows[0].entries[0].data,
        GeolocationDataEntity.fromJson(
          [6.944374229580692, 50.90713366617792],
        ),
      );
    });

    test('Grid With null value Parses Correctly', () {
      final grid = Grid.fromJson(rawResponseWithNullValue);

      expect(grid.fields.length, 1);
      expect(
        grid.rows[0].entries[0].data,
        GeolocationDataEntity(),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(
        jsonDecode(jsonEncode(fromJson.toJson())),
        equals(jsonDecode(jsonEncode(rawResponse))),
      );
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithAttachment = {
        "schema": {
          "type": "object",
          "properties": {
            "78lnph2fb2olm9jtc696d66q9": {
              "type": "array",
              "items": [
                {"type": "number", "format": "double"},
                {"type": "number", "format": "double"}
              ]
            }
          },
          "required": []
        },
        "title": "New title",
        "name": "Formular 1",
        "components": [
          {
            "property": "Location",
            "value": [6.944374229580692, 50.90713366617792],
            "required": false,
            "options": {"label": null, "description": null},
            "fieldId": "78lnph2fb2olm9jtc696d66q9",
            "type": "locationPicker"
          }
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ]
      };

      final formData = FormData.fromJson(responseWithAttachment);

      final fromJson = formData.components[0] as GeolocationFormComponent;

      final directEntity = GeolocationDataEntity(
        Geolocation(
          longitude: 6.944374229580692,
          latitude: 50.90713366617792,
        ),
      );

      final direct = GeolocationFormComponent(
        property: 'Location',
        data: directEntity,
        fieldId: '78lnph2fb2olm9jtc696d66q9',
      );

      expect(fromJson, direct);
      expect(fromJson.hashCode, direct.hashCode);
    });
  });

  group('Geolocation', () {
    test('Equality', () {
      final one = Geolocation(
        latitude: 47,
        longitude: 11,
      );

      final two = Geolocation(
        latitude: 47,
        longitude: 11,
      );

      expect(one, equals(two));
      expect(one.hashCode, equals(two.hashCode));
    });
  });
}
