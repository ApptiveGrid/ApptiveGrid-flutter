import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GridField', () {
    Map<String, dynamic> fieldJson(DataType lookupType) => {
          "name": "LookUp Field",
          "schema": {"type": "any"},
          "id": "fieldId",
          "key": null,
          "type": {
            "referenceField":
                "/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId",
            "lookupField":
                "/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId",
            "componentTypes": [],
            "name": "lookup",
            "typeName": "lookup",
            "lookupType": {
              'name': lookupType.backendName,
              'referenceField': '',
              'referencesField': '',
              'lookupField': '',
              'currency': 'EUR',
              'reduceFunction': 'sum',
              'lookupType': {
                'name': DataType.text.backendName,
              },
              'reducedType': {
                'name': DataType.integer.backendName,
              },
              'expression': '',
              'valueType': {
                'name': DataType.integer.backendName,
              },
            },
          },
          "_links": {
            "self": {
              "href":
                  "/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId",
              "method": "get",
            },
          },
        };

    test('Field is parsed', () {
      final fieldFromJson = GridField.fromJson(fieldJson(DataType.text));

      final directField = LookUpGridField(
        id: 'fieldId',
        name: 'LookUp Field',
        referenceField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId',
        ),
        lookedUpField: const GridField(
          id: 'lookedUpId',
          name: 'lookedUp',
          type: DataType.text,
        ),
        links: {
          ApptiveLinkType.self: ApptiveLink(
            uri: Uri.parse(
              '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
            ),
            method: 'get',
          ),
        },
      );

      expect(fieldFromJson, equals(directField));
    });

    test('To and From Json', () {
      final directField = LookUpGridField(
        id: 'fieldId',
        name: 'LookUp Field',
        referenceField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId',
        ),
        lookedUpField: const GridField(
          id: 'lookedUpId',
          name: 'lookedUp',
          type: DataType.text,
        ),
        links: {
          ApptiveLinkType.self: ApptiveLink(
            uri: Uri.parse(
              '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
            ),
            method: 'get',
          ),
        },
      );

      expect(GridField.fromJson(directField.toJson()), equals(directField));
    });

    test('HashCode', () {
      final field = LookUpGridField(
        id: 'fieldId',
        name: 'LookUp Field',
        referenceField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId',
        ),
        lookedUpField: const GridField(
          id: 'lookedUpId',
          name: 'lookedUp',
          type: DataType.text,
        ),
        links: {
          ApptiveLinkType.self: ApptiveLink(
            uri: Uri.parse(
              '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
            ),
            method: 'get',
          ),
        },
      );

      expect(
        field.hashCode,
        equals(
          Object.hash(
            GridField(
              id: field.id,
              name: field.name,
              type: field.type,
              links: field.links,
            ),
            field.referenceField,
            field.lookUpField,
            field.lookedUpField,
          ),
        ),
      );
    });

    test('To String', () {
      final field = LookUpGridField(
        id: 'fieldId',
        name: 'LookUp Field',
        referenceField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId',
        ),
        lookedUpField: const GridField(
          id: 'lookedUpId',
          name: 'lookedUp',
          type: DataType.text,
        ),
        links: {
          ApptiveLinkType.self: ApptiveLink(
            uri: Uri.parse(
              '/api/users/userId/spaces/spaceId/grids/gridId/fields/fieldId',
            ),
            method: 'get',
          ),
        },
      );

      expect(
        field.toString(),
        equals(
          'LookUpGridField(id: fieldId, name: LookUp Field, key: null, referenceField: /api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId, lookupField: /api/users/userId/spaces/spaceId/grids/referenceGridId/fields/lookUpFieldId, lookupType: text)',
        ),
      );
    });

    group('LookedUpTypes', () {
      for (final type in DataType.values) {
        test('Parse with $type as LookUpType', () {
          final field = GridField.fromJson(fieldJson(type));

          expect((field as LookUpGridField).lookedUpField.type, type);
        });
      }
    });
  });

  group('DataEntity', () {
    GridField field(DataType type) => GridField.fromJson({
          'id': 'fieldId',
          'name': 'field',
          'type': {
            'name': DataType.lookUp.backendName,
            'referenceField':
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
            'lookupField':
                '/api/users/userId/spaces/spaceId/grids/referencedGridId/fields/lookedupFieldId',
            'lookupType': {
              'name': type.backendName,
              'referenceField': '',
              'referencesField': '',
              'lookupField': '',
              'currency': 'EUR',
              'reduceFunction': 'sum',
              'lookupType': {
                'name': DataType.text.backendName,
              },
              'reducedType': {
                'name': DataType.integer.backendName,
              },
              'expression': '',
              'valueType': {
                'name': DataType.integer.backendName,
              },
            },
          },
        });

    DataEntity subEntity(DataType type) => switch (type) {
          DataType.text => StringDataEntity('Test'),
          DataType.dateTime =>
            DateTimeDataEntity(DateTime(2023, 07, 07, 11, 42)),
          DataType.date => DateDataEntity(DateTime(2023, 07, 07)),
          DataType.integer => IntegerDataEntity(1),
          DataType.decimal => DecimalDataEntity(1.1),
          DataType.checkbox => BooleanDataEntity(true),
          DataType.singleSelect => EnumDataEntity(value: 'value'),
          DataType.enumCollection =>
            EnumCollectionDataEntity(value: {'value1', 'value2'}),
          DataType.crossReference => CrossReferenceDataEntity(
              value: 'DisplayValue',
              gridUri: Uri(),
              entityUri: Uri.parse('path/to/refEntity'),
            ),
          DataType.attachment => AttachmentDataEntity(
              [Attachment(name: 'name', url: Uri(), type: 'image/png')],
            ),
          DataType.geolocation => GeolocationDataEntity(
              const Geolocation(latitude: 47, longitude: 11),
            ),
          DataType.multiCrossReference => MultiCrossReferenceDataEntity(
              gridUri: Uri(),
              references: [
                CrossReferenceDataEntity(
                  value: 'DisplayValue1',
                  gridUri: Uri(),
                  entityUri: Uri.parse('path/to/refEntity1'),
                ),
                CrossReferenceDataEntity(
                  value: 'DisplayValue2',
                  gridUri: Uri(),
                  entityUri: Uri.parse('path/to/refEntity2'),
                ),
              ],
            ),
          DataType.createdBy => CreatedByDataEntity(
              const CreatedBy(
                id: 'id',
                type: CreatedByType.user,
                name: 'Creator',
                displayValue: 'User',
              ),
            ),
          DataType.user => UserDataEntity(
              DataUser(displayValue: 'User Name', uri: Uri()),
            ),
          DataType.currency =>
            CurrencyDataEntity(currency: 'EUR', value: 47.11),
          DataType.uri => UriDataEntity(Uri(path: '/test/uri')),
          DataType.email => EmailDataEntity('email@testing.com'),
          DataType.phoneNumber => PhoneNumberDataEntity('+49123456'),
          DataType.signature => SignatureDataEntity(
              Attachment(name: 'signature', url: Uri(), type: 'image/svg'),
            ),
          DataType.createdAt =>
            DateTimeDataEntity(DateTime(2023, 7, 7, 11, 58)),
          DataType.lookUp => LookUpDataEntity(StringDataEntity('Chaining')),
          DataType.reducedLookUp =>
            ReducedLookUpDataEntity(IntegerDataEntity(3)),
          DataType.formula => FormulaDataEntity(value: IntegerDataEntity(3))
        } as DataEntity;

    for (final type in DataType.values) {
      test('Parses Lookup Type with Looked Up $type', () {
        final expectedEntity = subEntity(type);

        final entity = DataEntity.fromJson(
          json: expectedEntity.schemaValue,
          field: field(type),
        );

        expect(entity, isInstanceOf<LookUpDataEntity>());

        expect(entity.value.runtimeType, expectedEntity.runtimeType);
        expect(
          (entity as LookUpDataEntity).value!.value,
          expectedEntity.value,
        );
      });
    }
  });
}
