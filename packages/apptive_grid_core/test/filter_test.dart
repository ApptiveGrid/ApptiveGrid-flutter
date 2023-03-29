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
        equals(
          jsonEncode({
            "fieldId": {"\$eq": "value"}
          }),
        ),
      );
    });

    test('isEmpty', () async {
      expect(
        jsonEncode(
          // Ignore const to enable coverage
          // ignore: prefer_const_constructors
          IsEmptyFilter(
            fieldId: 'fieldId',
          ).toJson(),
        ),
        equals(
          jsonEncode({
            'fieldId': {'\$isEmpty': true}
          }),
        ),
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

      test('Actor', () async {
        expect(
          jsonEncode(
            // Ignore const to enable coverage
            // ignore: prefer_const_constructors
            ActorFilter(
              fieldId: 'fieldId',
              value: LoggedInUser(),
            ).toJson(),
          ),
          equals(
            jsonEncode({
              'fieldId': {'\$isActor': '{{ loggedInUser() }}'}
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

        expect(a, isNot(b));
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

        expect(a, isNot(b));
      });
    });

    group('FieldFilter', () {
      test('Equality', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));

        expect(a, equals(b));
      });

      test('Different Operator', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b = SubstringFilter(
          fieldId: 'fieldId',
          value: StringDataEntity('value'),
        );

        expect(a, isNot(b));
      });

      test('Different Value', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value1'));

        expect(a, isNot(b));
      });

      test('Different Field', () {
        final a =
            EqualsFilter(fieldId: 'fieldId', value: StringDataEntity('value'));
        final b =
            EqualsFilter(fieldId: 'fieldId1', value: StringDataEntity('value'));

        expect(a, isNot(b));
      });
    });
  });

  group('Combination', () {
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
                'fieldId': {'\$eq': 'value'},
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
                'fieldId': {'\$eq': 'value'},
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

    test('Hashcode', () {
      final composition = OrFilterComposition(
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
      );
      expect(
        composition.hashCode,
        equals(Object.hash(composition.operator, composition.conditions)),
      );
    });
  });

  group('Not Filter', () {
    group('Equality', () {
      test('Same sub filter equals', () async {
        final filter1 = NotFilter(
          filter: EqualsFilter(
            fieldId: 'field',
            value: StringDataEntity('test'),
          ),
        );
        final filter2 = NotFilter(
          filter: EqualsFilter(
            fieldId: 'field',
            value: StringDataEntity('test'),
          ),
        );

        expect(filter1, equals(filter2));
        expect(filter1.hashCode, equals(filter2.hashCode));
      });

      test('Different sub filters are not equal', () async {
        final filter1 = NotFilter(
          filter: EqualsFilter(
            fieldId: 'field',
            value: StringDataEntity('test'),
          ),
        );
        final filter2 = NotFilter(
          filter: EqualsFilter(
            fieldId: 'field1',
            value: StringDataEntity('test2'),
          ),
        );

        expect(filter1, isNot(equals(filter2)));
        expect(filter1.hashCode, isNot(equals(filter2.hashCode)));
      });
    });

    test('Produces correct json', () {
      final filter = NotFilter(
        filter: EqualsFilter(fieldId: 'field', value: StringDataEntity('test')),
      );

      expect(
        jsonEncode(filter.toJson()),
        equals(
          jsonEncode({
            '\$not': {
              'field': {'\$eq': 'test'},
            }
          }),
        ),
      );
    });
  });
  group('Filter Expression', () {
    test('Equality', () {
      const todayExpression = Today();
      const loggedInExpression = LoggedInUser();

      expect(todayExpression, isNot(equals(loggedInExpression)));
      expect(
        todayExpression.hashCode,
        isNot(equals(loggedInExpression.hashCode)),
      );
      expect(
        todayExpression.filterValue,
        isNot(equals(loggedInExpression.filterValue)),
      );
    });

    test('Today', () {
      const todayExpression = Today();

      expect(todayExpression.filterValue, equals('{{ today() }}'));
    });

    test('LoggedIn User', () {
      const loggedInExpression = LoggedInUser();

      expect(loggedInExpression.filterValue, equals('{{ loggedInUser() }}'));
    });
  });

  group('toString()', () {
    test('Produces correct String Output', () {
      final filter = EqualsFilter(
        fieldId: 'field',
        value: StringDataEntity('test'),
      );

      expect(filter.toString(), equals('EqualsFilter({field: {\$eq: test}})'));
    });
  });
}
