import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GridField', () {
    Map<String, dynamic> fieldJson(DataType reducedLookUpType) => {
          "name": "ReducedLookUp Field",
          "schema": {"type": "any"},
          "id": "fieldId",
          "key": null,
          "type": {
            "referencesField":
                "/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId",
            "lookupField":
                "/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId",
            "componentTypes": [],
            "name": "reducedLookupCollectionType",
            "typeName": "reducedLookupCollectionType",
            'reduceFunction': 'sum',
            "reducedType": {
              'name': reducedLookUpType.backendName,
              'referencesField': '',
              'referenceField': '',
              'lookupField': '',
              'reduceFunction': 'sum',
              'currency': 'EUR',
              'expression': '',
              'reducedType': {
                'name': DataType.integer.backendName,
              },
              'lookupType': {
                'name': DataType.text.backendName,
              },
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

      final directField = ReducedLookUpField(
        id: 'fieldId',
        name: 'ReducedLookUp Field',
        referencesField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId',
        ),
        reducedField: const GridField(
          id: 'reducedId',
          name: 'reduced',
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
        reduceFunction: 'sum',
      );

      expect(fieldFromJson, equals(directField));
    });

    test('To and From Json', () {
      final directField = ReducedLookUpField(
        id: 'fieldId',
        name: 'ReducedLookUp Field',
        referencesField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId',
        ),
        reducedField: const GridField(
          id: 'reducedId',
          name: 'reduced',
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
        reduceFunction: 'sum',
      );

      expect(GridField.fromJson(directField.toJson()), equals(directField));
    });

    test('HashCode', () {
      final field = ReducedLookUpField(
        id: 'fieldId',
        name: 'ReducedLookUp Field',
        referencesField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId',
        ),
        reducedField: const GridField(
          id: 'reducedId',
          name: 'reduced',
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
        reduceFunction: 'sum',
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
            field.referencesField,
            field.lookUpField,
            field.reducedField,
            field.reduceFunction,
          ),
        ),
      );
    });

    test('To String', () {
      final field = ReducedLookUpField(
        id: 'fieldId',
        name: 'ReducedLookUp Field',
        referencesField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
        ),
        lookUpField: Uri.parse(
          '/api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId',
        ),
        reducedField: const GridField(
          id: 'reducedId',
          name: 'reduced',
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
        reduceFunction: 'sum',
      );

      expect(
        field.toString(),
        equals(
          'ReducedLookUpGridField(id: fieldId, name: ReducedLookUp Field, key: null, referencesField: /api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId, lookUpField: /api/users/userId/spaces/spaceId/grids/referenceGridId/fields/reducedLookUpFieldId, reducedType: text, reduceFunction: sum)',
        ),
      );
    });

    group('SumedUpTypes', () {
      for (final type in DataType.values) {
        test('Parse with $type as ReducedLookUpType', () {
          final field = GridField.fromJson(fieldJson(type));

          expect((field as ReducedLookUpField).reducedField.type, type);
        });
      }
    });
  });

  group('DataEntity', () {
    GridField field(DataType type) => GridField.fromJson({
          'id': 'fieldId',
          'name': 'field',
          'type': {
            'name': DataType.reducedLookUp.backendName,
            'referencesField':
                '/api/users/userId/spaces/spaceId/grids/gridId/fields/referencedFieldId',
            'lookupField':
                '/api/users/userId/spaces/spaceId/grids/referencedGridId/fields/sumedupFieldId',
            'reduceFunction': 'sum',
            'reducedType': {
              'name': type.backendName,
              'referencesField': '',
              'referenceField': '',
              'lookupField': '',
              'reduceFunction': 'sum',
              'currency': 'EUR',
              'expression': '',
              'reducedType': {
                'name': DataType.integer.backendName,
              },
              'lookupType': {
                'name': DataType.text.backendName,
              },
              'valueType': {
                'name': DataType.integer.backendName,
              },
            },
          },
        });

    DataEntity subEntity(DataType type) {
      switch (type) {
        case DataType.text:
          return StringDataEntity('Test');
        case DataType.dateTime:
          return DateTimeDataEntity(DateTime(2023, 07, 07, 11, 42));
        case DataType.date:
          return DateDataEntity(DateTime(2023, 07, 07));

        case DataType.integer:
          return IntegerDataEntity(1);

        case DataType.decimal:
          return DecimalDataEntity(1.1);

        case DataType.checkbox:
          return BooleanDataEntity(true);

        case DataType.singleSelect:
          return EnumDataEntity(value: 'value');

        case DataType.enumCollection:
          return EnumCollectionDataEntity(value: {'value1', 'value2'});

        case DataType.crossReference:
          return CrossReferenceDataEntity(
            value: 'DisplayValue',
            gridUri: Uri(),
            entityUri: Uri.parse('path/to/refEntity'),
          );

        case DataType.attachment:
          return AttachmentDataEntity(
            [Attachment(name: 'name', url: Uri(), type: 'image/png')],
          );

        case DataType.geolocation:
          return GeolocationDataEntity(
            const Geolocation(latitude: 47, longitude: 11),
          );

        case DataType.multiCrossReference:
          return MultiCrossReferenceDataEntity(
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
          );

        case DataType.createdBy:
          return CreatedByDataEntity(
            const CreatedBy(
              id: 'id',
              type: CreatedByType.user,
              name: 'Creator',
              displayValue: 'User',
            ),
          );

        case DataType.user:
          return UserDataEntity(
            DataUser(displayValue: 'User Name', uri: Uri()),
          );

        case DataType.currency:
          return CurrencyDataEntity(currency: 'EUR', value: 47.11);

        case DataType.uri:
          return UriDataEntity(Uri(path: '/test/uri'));

        case DataType.email:
          return EmailDataEntity('email@testing.com');

        case DataType.phoneNumber:
          return PhoneNumberDataEntity('+49123456');

        case DataType.signature:
          return SignatureDataEntity(
            Attachment(name: 'signature', url: Uri(), type: 'image/svg'),
          );

        case DataType.createdAt:
          return DateTimeDataEntity(DateTime(2023, 7, 7, 11, 58));

        case DataType.lookUp:
          return LookUpDataEntity(StringDataEntity('Chaining'));

        case DataType.reducedLookUp:
          return ReducedLookUpDataEntity(IntegerDataEntity(3));

        case DataType.formula:
          return FormulaDataEntity(value: IntegerDataEntity(3));
      }
    }

    for (final type in DataType.values) {
      test('Parses ReducedLookUp Type with Sumed Up $type', () {
        final expectedEntity = subEntity(type);

        final entity = DataEntity.fromJson(
          json: expectedEntity.schemaValue,
          field: field(type),
        );

        expect(entity, isInstanceOf<ReducedLookUpDataEntity>());

        expect(entity.value.runtimeType, expectedEntity.runtimeType);
        expect(
          (entity as ReducedLookUpDataEntity).value!.value,
          expectedEntity.value,
        );
      });
    }
  });
}