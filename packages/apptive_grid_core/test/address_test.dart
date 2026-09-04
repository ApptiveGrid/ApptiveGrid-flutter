import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const addressFieldJson = {
    "type": {
      "name": "address",
      "typeName": "address",
    },
    "key": null,
    "name": "Address",
    "schema": {
      "type": "object",
      "properties": {
        "line1": {"type": "string"},
        "line2": {"type": "string"},
        "city": {"type": "string"},
        "postCode": {"type": "string"},
        "state": {"type": "string"},
        "geoLocation": {
          "type": "object",
          "properties": {
            "lat": {"type": "number", "format": "double"},
            "lon": {"type": "number", "format": "double"},
          },
          "required": ["lat", "lon"],
        },
      },
    },
    "id": "628210c204bd301aa89b7f8a",
    "_links": <String, dynamic>{},
  };

  const addressValueJson = {
    'line1': 'Musterstraße 1',
    'line2': 'Apt 2',
    'city': 'Berlin',
    'postCode': '12345',
    'state': 'Berlin',
    'country': 'Germany',
    'geoLocation': {
      'lat': 50.90713366617792,
      'lon': 6.944374229580692,
    },
  };

  group('Grid', () {
    final rawResponse = {
      "fieldNames": ["Address"],
      "sorting": [],
      "entities": [
        {
          "fields": [addressValueJson],
          "_id": "61b08a87aa660541e58f58ef",
          '_links': {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04/entities/619b63e84a391314968da9a0",
              "method": "get",
            },
          },
        }
      ],
      "filter": {},
      'fields': [addressFieldJson],
      "name": "Test Ansicht",
      'id': 'gridId',
      '_links': {
        "addLink": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/AddLink",
          "method": "post",
        },
        "forms": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "get",
        },
        "updateFieldType": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnTypeChange",
          "method": "post",
        },
        "removeField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRemove",
          "method": "post",
        },
        "addEntity": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "post",
        },
        "views": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "get",
        },
        "addView": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/views",
          "method": "post",
        },
        "self": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "get",
        },
        "updateFieldKey": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/gridId/ColumnKeyChange",
          "method": "post",
        },
        "query": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/query",
          "method": "get",
        },
        "entities": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/entities",
          "method": "get",
        },
        "updates": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/updates",
          "method": "get",
        },
        "schema": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/schema",
          "method": "get",
        },
        "updateFieldName": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnRename",
          "method": "post",
        },
        "addForm": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/forms",
          "method": "post",
        },
        "addField": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/ColumnAdd",
          "method": "post",
        },
        "rename": {
          "href": "/api/users/userId/spaces/spaceId/grids/gridId/Rename",
          "method": "post",
        },
        "remove": {
          "href":
              "/api/users/userId/spaces/spaceId/grids/61bb271d457c98231c8fbb04",
          "method": "delete",
        },
      },
    };

    final rawResponseWithNullValue = {
      "fieldNames": ["Address"],
      "sorting": [],
      "entities": [
        {
          "fields": [null],
          "_id": "61b08a87aa660541e58f58ef",
        }
      ],
      "filter": {},
      'fields': [addressFieldJson],
      "name": "Test Ansicht",
      'id': 'gridId',
      '_links': <String, dynamic>{},
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        AddressDataEntity.fromJson(addressValueJson),
      );
    });

    test('Grid With partial value Parses Correctly', () {
      final partialResponse = {
        ...rawResponse,
        'entities': [
          {
            'fields': [
              {'line1': 'Musterstraße 1'},
            ],
            '_id': '61b08a87aa660541e58f58ef',
          },
        ],
      };

      final grid = Grid.fromJson(partialResponse);

      expect(
        grid.rows![0].entries[0].data,
        AddressDataEntity.fromJson({'line1': 'Musterstraße 1'}),
      );
    });

    test('Grid With null value Parses Correctly', () {
      final grid = Grid.fromJson(rawResponseWithNullValue);

      expect(grid.fields!.length, equals(1));
      expect(
        grid.rows![0].entries[0].data,
        AddressDataEntity(),
      );
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(Grid.fromJson(fromJson.toJson()), fromJson);
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final response = {
        'fields': [
          {
            ...addressFieldJson,
            'id': '78lnph2fb2olm9jtc696d66q9',
            'name': 'Property',
          },
        ],
        "title": "New title",
        "name": "Formular 1",
        "components": [
          {
            "property": "Address",
            "value": addressValueJson,
            "required": false,
            "options": {"label": null, "description": null},
            "fieldId": "78lnph2fb2olm9jtc696d66q9",
            "type": "addressPicker",
          }
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'},
        ],
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

      final formData = FormData.fromJson(response);

      final fromJson = formData.components![0];

      final directEntity =
          AddressDataEntity(Address.fromJson(addressValueJson));

      final direct = FormComponent<AddressDataEntity>(
        property: 'Address',
        data: directEntity,
        field: const GridField(
          id: '78lnph2fb2olm9jtc696d66q9',
          name: 'Property',
          type: DataType.address,
        ),
        type: 'addressPicker',
      );

      expect(fromJson, equals(direct));
    });

    test('Hashcode', () {
      const field =
          GridField(id: 'id', name: 'property', type: DataType.address);

      final entity = AddressDataEntity(Address.fromJson(addressValueJson));
      final component = FormComponent<AddressDataEntity>(
        property: 'New field',
        data: entity,
        field: field,
        type: 'addressPicker',
      );

      expect(
        component.hashCode,
        Object.hash(
          component.field,
          component.property,
          component.data,
          component.options,
          component.required,
          component.type,
          component.enabled,
        ),
      );
    });
  });

  group('Address', () {
    group('Parsing', () {
      test('Succeeds', () {
        final address = Address.fromJson(addressValueJson);

        expect(address.line1, addressValueJson['line1']);
        expect(address.line2, addressValueJson['line2']);
        expect(address.city, addressValueJson['city']);
        expect(address.postCode, addressValueJson['postCode']);
        expect(address.state, addressValueJson['state']);
        expect(address.country, addressValueJson['country']);
        expect(
          address.geoLocation,
          Geolocation.fromJson(addressValueJson['geoLocation']),
        );
      });

      test('Succeeds with only some fields set', () {
        final json = {'line1': 'Musterstraße 1', 'city': 'Berlin'};

        final address = Address.fromJson(json);

        expect(address.line1, 'Musterstraße 1');
        expect(address.city, 'Berlin');
        expect(address.line2, isNull);
        expect(address.postCode, isNull);
        expect(address.state, isNull);
        expect(address.country, isNull);
        expect(address.geoLocation, isNull);
      });

      test('Fails for invalid json', () {
        try {
          Address.fromJson('not an address');
          fail('Parsing should not succeed');
        } catch (error) {
          expect(error, isArgumentError);
        }
      });
    });

    test('toJson() omits null fields', () {
      final address = Address.fromJson({'line1': 'Musterstraße 1'});

      expect(address.toJson(), {'line1': 'Musterstraße 1'});
    });

    test('toJson() roundtrips', () {
      final address = Address.fromJson(addressValueJson);

      expect(Address.fromJson(address.toJson()), address);
    });

    test('Equality', () {
      final one = Address.fromJson(addressValueJson);
      final two = Address.fromJson(addressValueJson);

      expect(one, equals(two));
    });

    test('Hashcode', () {
      final address = Address.fromJson(addressValueJson);

      expect(
        address.hashCode,
        Object.hash(
          address.line1,
          address.line2,
          address.city,
          address.postCode,
          address.state,
          address.country,
          address.geoLocation,
        ),
      );
    });

    test('toString()', () {
      const address = Address(line1: 'Musterstraße 1', city: 'Berlin');

      expect(
        address.toString(),
        'Address(line1: Musterstraße 1, line2: null, city: Berlin, postCode: null, state: null, country: null, geoLocation: null)',
      );
    });

    test('copyWith()', () {
      const address = Address(line1: 'Musterstraße 1');

      final copy = address.copyWith(city: 'Berlin');

      expect(copy.line1, 'Musterstraße 1');
      expect(copy.city, 'Berlin');
    });
  });
}
