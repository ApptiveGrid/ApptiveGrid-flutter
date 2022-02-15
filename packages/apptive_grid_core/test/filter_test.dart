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
          EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'))
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
                '\$hasAnyOf': ['2', '3']
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
                '\$hasAllOf': ['2', '3']
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
                '\$hasNoneOf': ['2', '3']
              }
            }),
          ),
        );
      });
    });
  });

  group('Equality', () {
    group('Composition', () {
      test('Equality', () {
        final a = AndFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value1'),
            ),
          ],
        );

        final b = AndFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value1'),
            ),
          ],
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('Different Type', () {
        final a = AndFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value1'),
            ),
          ],
        );

        final b = OrFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value1'),
            ),
          ],
        );

        expect(a, isNot(equals(b)));
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });

      test('Different Conditions', () {
        final a = OrFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value1'),
            ),
          ],
        );

        final b = OrFilterComposition(
          conditions: [
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value')),
            EqualsFilter(
              fieldId: 'fieldId1',
              value: StringDataEntity('value2'),
            ),
          ],
        );

        expect(a, isNot(equals(b)));
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });
    });

    group('FieldFilter', () {
      test('Equality', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('Different Operator', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b = SubstringFilter(
          fieldId: 'fieldId',
          value: StringDataEntity('value'),
        );

        expect(a, isNot(equals(b)));
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });

      test('Different Value', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value1'));

        expect(a, isNot(equals(b)));
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });

      test('Different Field', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId1', value: StringDataEntity('value'));

        expect(a, isNot(equals(b)));
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });
    });
  });

  group('Combination produces correct json', () {
    test('And', () async {
      expect(
        jsonEncode(
          AndFilterComposition(
            conditions: [
              EqualsFilter(
                fieldId: 'fieldId',
                value: StringDataEntity('value'),
              ),
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
                  '\$hasAnyOf': ['2', '3']
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
          OrFilterComposition(
            conditions: [
              EqualsFilter(
                fieldId: 'fieldId',
                value: StringDataEntity('value'),
              ),
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
                  '\$hasAnyOf': ['2', '3']
                }
              },
            ]
          }),
        ),
      );
    });
  });
}
