import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['multi enum'],
      'sorting': [],
      'entities': [
        {
          'fields': [
            ['A', 'C']
          ],
          '_id': '61af483b85182c9a4e8eee91'
        },
      ],
      'fieldIds': ['8ou8s82tahpyqoowd0izr1nzm'],
      'filter': {},
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {
                'type': 'array',
                'items': {
                  'type': 'string',
                  'enum': ['A', 'B', 'C']
                }
              }
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Name'
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields.length, 1);
      expect(
        grid.rows[0].entries[0].data,
        EnumCollectionDataEntity(value: {'A', 'C'}, options: {'A', 'B', 'C'}),
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
      final responseWithEnumCollection = {
        'schema': {
          'type': 'object',
          'properties': {
            'c75385nsbbji82k5wntoj6sj2': {
              'type': 'array',
              'items': {
                'type': 'string',
                'enum': ['GmbH', 'AG', 'Freiberuflich']
              }
            },
          },
          'required': []
        },
        'title': 'New title',
        'name': 'Form 1',
        'components': [
          {
            'property': 'New field',
            'value': [
              "AG",
              "GmbH",
            ],
            'required': false,
            'options': {'label': null, 'description': null},
            'fieldId': 'c75385nsbbji82k5wntoj6sj2',
            'type': null
          },
        ],
        'actions': [
          {'uri': '/api/a/123/456', 'method': 'POST'}
        ]
      };

      final formData = FormData.fromJson(responseWithEnumCollection);

      final fromJson = formData.components.first as EnumCollectionFormComponent;

      final directEntity = EnumCollectionDataEntity(
        value: {'AG', 'GmbH'},
        options: {
          'GmbH',
          'AG',
          'Freiberuflich',
        },
      );

      final direct = EnumCollectionFormComponent(
        property: 'New field',
        data: directEntity,
        fieldId: 'c75385nsbbji82k5wntoj6sj2',
      );

      expect(fromJson, direct);
      expect(fromJson.hashCode, direct.hashCode);
    });
  });
}
