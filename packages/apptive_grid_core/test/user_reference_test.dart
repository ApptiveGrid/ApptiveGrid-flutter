import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid', () {
    final rawResponse = {
      'fieldNames': ['New field'],
      'sorting': [],
      'entities': [
        {
          'fields': [null],
          '_id': '61eeab7586c4f19eee92f1a6'
        },
        {
          'fields': [
            {
              'name': 'jane.doe@2denker.de',
              'displayValue': 'Jane Doe',
              'id': 'userId',
              'type': 'user'
            }
          ],
          '_id': '61eeab8286c4f19eee92f1e0'
        },
        {
          'fields': [
            {
              'name': '',
              'displayValue': '',
              'id': '61eeac4686c4f1d22992f260',
              'type': 'link'
            }
          ],
          '_id': '61eeac6486c4f1885092f263'
        },
        {
          'fields': [
            {
              'name': '',
              'displayValue': '',
              'id': '61eeac4686c4f1d22992f263',
              'type': 'accesscredentials'
            }
          ],
          '_id': '61eeac6486c4f1885092f263'
        },
      ],
      'fieldIds': ['f3k9zj2aaclqnhd2e8cvlwydt'],
      'filter': {},
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {
                'type': 'object',
                'properties': {
                  'displayValue': {'type': 'string'},
                  'id': {'type': 'string'},
                  'type': {'type': 'string'},
                  'name': {'type': 'string'}
                },
                'objectType': 'userReference'
              }
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'Yeah Ansicht',
    };

    test('Grid Parses Correctly', () {
      final grid = Grid.fromJson(rawResponse);

      expect(grid.fields.length, equals(1));
      expect(grid.rows.length, equals(4));
    });

    group('UserReference Type', () {
      final grid = Grid.fromJson(rawResponse);

      test('Null', () {
        expect(
          grid.rows[0].entries.first.data,
          UserReferenceDataEntity(),
        );
      });

      test('User', () {
        expect(
          grid.rows[1].entries.first.data,
          UserReferenceDataEntity(
            const UserReference(
              id: 'userId',
              type: UserReferenceType.user,
              displayValue: 'Jane Doe',
              name: 'jane.doe@2denker.de',
            ),
          ),
        );
      });

      test('Form Link', () {
        expect(
          grid.rows[2].entries.first.data,
          UserReferenceDataEntity(
            const UserReference(
              id: '61eeac4686c4f1d22992f260',
              type: UserReferenceType.formLink,
              displayValue: '',
              name: '',
            ),
          ),
        );
      });

      test('Api Key', () {
        expect(
          grid.rows[3].entries.first.data,
          UserReferenceDataEntity(
            const UserReference(
              id: '61eeac4686c4f1d22992f263',
              type: UserReferenceType.apiCredentials,
              displayValue: '',
              name: '',
            ),
          ),
        );
      });
    });

    test('Grid serializes back to original Response', () {
      final fromJson = Grid.fromJson(rawResponse);

      expect(fromJson.toJson(), equals(rawResponse));
    });
  });

  group('DataEntity', () {
    test('Equality', () {
      final a = UserReferenceDataEntity.fromJson({
        'name': 'jane.doe@2denker.de',
        'displayValue': 'Jane Doe',
        'id': 'userId',
        'type': 'user'
      });
      final b = UserReferenceDataEntity.fromJson({
        'name': 'jane.doe@2denker.de',
        'displayValue': 'Jane Doe',
        'id': 'userId',
        'type': 'user'
      });
      final c = UserReferenceDataEntity.fromJson({
        'name': '',
        'displayValue': '',
        'id': 'userId',
        'type': 'accesscredentials'
      });
      expect(a, equals(b));
      expect(a, isNot(c));

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(c.hashCode));
    });
  });

  group('FormComponent', () {
    test('Direct equals from Json', () {
      final responseWithUserReference = {
        'schemaObject':
            '/api/users/614c5440b50f51e3ea8a2a50/spaces/61eeab7086c4f19eee92f1a2/grids/61eeab7586c4f19eee92f1a5',
        'schema': {
          'type': 'object',
          'properties': {
            'f3k9zj2aaclqnhd2e8cvlwydt': {
              'type': 'object',
              'properties': {
                'displayValue': {'type': 'string'},
                'id': {'type': 'string'},
                'type': {'type': 'string'},
                'name': {'type': 'string'}
              },
              'objectType': 'userReference'
            }
          },
          'required': []
        },
        'title': 'New title',
        'name': 'Formular 1',
        'components': [
          {
            'property': 'New field',
            'value': {
              'name': 'jane.doe@2denker.de',
              'displayValue': 'Jane Doe',
              'id': 'userId',
              'type': 'user'
            },
            'required': false,
            'options': {
              'multi': false,
              'placeholder': null,
              'description': null,
              'label': null
            },
            'fieldId': 'f3k9zj2aaclqnhd2e8cvlwydt',
            'type': 'textfield'
          }
        ]
      };

      final formData = FormData.fromJson(responseWithUserReference);

      final fromJson = formData.components[0] as UserReferenceFormComponent;

      final directEntity = UserReferenceDataEntity.fromJson({
        'name': 'jane.doe@2denker.de',
        'displayValue': 'Jane Doe',
        'id': 'userId',
        'type': 'user'
      });

      final direct = UserReferenceFormComponent(
        property: 'New field',
        data: directEntity,
        fieldId: 'f3k9zj2aaclqnhd2e8cvlwydt',
      );

      expect(fromJson, equals(direct));
      expect(fromJson.hashCode, equals(direct.hashCode));
    });
  });

  group('UserReference', () {
    test('Equality', () {
      const one = UserReference(
        id: 'userId',
        type: UserReferenceType.user,
        displayValue: 'Jane Doe',
        name: 'jane.doe@2denker.de',
      );

      final two = UserReference.fromJson(
        {
          'name': 'jane.doe@2denker.de',
          'displayValue': 'Jane Doe',
          'id': 'userId',
          'type': 'user'
        },
      );

      expect(one, equals(two));
      expect(one.hashCode, equals(two.hashCode));
    });
  });
}