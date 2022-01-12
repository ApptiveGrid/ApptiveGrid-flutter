import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldFilters produces correct json', () {
    test('Substring', () async {
      expect(
        jsonEncode(
          SubstringFilter(
            fieldId: 'fieldId',
            value: StringDataEntity('value'),
          ).toJson(),
        ),
        equals(
          jsonEncode({
            'fieldId': {'\$substring': 'value'}
          }),
        ),
      );
    });

    test('Equal', () async {
      expect(
        jsonEncode(
          EqualFilter(fieldId: 'fieldId', value: StringDataEntity('value'))
              .toJson(),
        ),
        equals(jsonEncode({'fieldId': 'value'})),
      );
    });

    test('GreaterThan', () async {
      expect(
        jsonEncode(
          GreaterThanFilter(fieldId: 'fieldId', value: IntegerDataEntity(2))
              .toJson(),
        ),
        equals(
          jsonEncode({
            'fieldId': {'\$gt': 2}
          }),
        ),
      );
    });

    test('LesserThan', () async {
      expect(
        jsonEncode(
          LesserThanFilter(fieldId: 'fieldId', value: IntegerDataEntity(2))
              .toJson(),
        ),
        equals(
          jsonEncode({
            'fieldId': {'\$lt': 2}
          }),
        ),
      );
    });

    group('Collection', () {
      test('Any', () async {
        expect(
          jsonEncode(
            AnyOfFilter(
              fieldId: 'fieldId',
              value: EnumCollectionDataEntity(value: {'2', '3'}),
            ).toJson(),
          ),
          equals(
            jsonEncode({
              'fieldId': {
                '\$any': ['2', '3']
              }
            }),
          ),
        );
      });

      test('AllOf', () async {
        expect(
          jsonEncode(
            AllOfFilter(
              fieldId: 'fieldId',
              value: EnumCollectionDataEntity(value: {'2', '3'}),
            ).toJson(),
          ),
          equals(
            jsonEncode({
              'fieldId': {
                '\$all': ['2', '3']
              }
            }),
          ),
        );
      });

      test('None', () async {
        expect(
          jsonEncode(
            NoneOfFilter(
              fieldId: 'fieldId',
              value: EnumCollectionDataEntity(value: {'2', '3'}),
            ).toJson(),
          ),
          equals(
            jsonEncode({
              'fieldId': {
                '\$none': ['2', '3']
              }
            }),
          ),
        );
      });
    });
  });

  group('Combination produces correct json', () {
    test('And', () async {
      expect(
        jsonEncode(
          AndFilterCondition(
            conditions: [
              EqualFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
              AnyOfFilter(
                fieldId: 'fieldId1',
                value: EnumCollectionDataEntity(value: {'2', '3'}),
              ),
            ],
          ).toJson(),
        ),
        equals(
          jsonEncode({
            '\$and': [
              {
                'fieldId': 'value',
              },
              {
                'fieldId1': {
                  '\$any': ['2', '3']
                }
              },
            ]
          }),
        ),
      );
    });
    test('Or', () async {
      expect(
        jsonEncode(
          OrFilterCondition(
            conditions: [
              EqualFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
              AnyOfFilter(
                fieldId: 'fieldId1',
                value: EnumCollectionDataEntity(value: {'2', '3'}),
              ),
            ],
          ).toJson(),
        ),
        equals(
          jsonEncode({
            '\$or': [
              {
                'fieldId': 'value',
              },
              {
                'fieldId1': {
                  '\$any': ['2', '3']
                }
              },
            ]
          }),
        ),
      );
    });
  });
}
