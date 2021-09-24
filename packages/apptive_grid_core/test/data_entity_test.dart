import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String', () {
    test('Value is set', () {
      final entity = StringDataEntity('Value');

      expect(entity.value, 'Value');
      expect(entity.schemaValue, 'Value');
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, null);
    });
  });

  group('Integer', () {
    test('Value is set', () {
      final entity = IntegerDataEntity(3);

      expect(entity.value, 3);
      expect(entity.schemaValue, 3);
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, null);
    });
  });

  group('Decimal', () {
    test('Value is set', () {
      final entity = DecimalDataEntity(47.11);

      expect(entity.value, 47.11);
      expect(entity.schemaValue, 47.11);
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, null);
    });
  });

  group('Date', () {
    test('Value is set', () {
      final date = DateTime(
        2020,
        3,
        3,
      );
      final entity = DateDataEntity(date);

      expect(entity.value, date);
      expect(entity.schemaValue, '2020-03-03');
    });

    test('Json is parsed', () {
      final date = DateTime(
        2020,
        3,
        3,
      );
      final entity = DateDataEntity.fromJson('2020-03-03');

      expect(entity.value, date);
      expect(entity.schemaValue, '2020-03-03');
    });

    test('Default is null', () {
      final entity = DateDataEntity();

      expect(entity.value, null);
    });
  });

  group('DateTime', () {
    test('Value is set', () {
      final date = DateTime(2020, 3, 3, 12, 12, 12);
      final entity = DateTimeDataEntity(date);

      expect(entity.value, date);
      expect(entity.schemaValue, '2020-03-03T12:12:12.000');
    });

    test('Json is parsed', () {
      final date = DateTime(2020, 3, 3, 12, 12, 12);
      final entity = DateTimeDataEntity.fromJson('2020-03-03T12:12:12.000');

      expect(entity.value, date);
      expect(entity.schemaValue, '2020-03-03T12:12:12.000');
    });

    test('Default is null', () {
      final entity = DateTimeDataEntity();

      expect(entity.value, null);
    });
  });

  group('Boolean', () {
    test('Value is set', () {
      final entity = BooleanDataEntity(true);

      expect(entity.value, true);
      expect(entity.schemaValue, true);
    });

    test('Default is false', () {
      final entity = BooleanDataEntity();

      expect(entity.value, false);
    });
  });

  group('Enum', () {
    test('Value is set', () {
      const value = 'value';
      final values = ['value', 'otherValue'];
      final entity = EnumDataEntity(value: value, options: values);

      expect(entity.value, value);
      expect(entity.options, values);
      expect(entity.schemaValue, value);
    });

    test('Default is null', () {
      final entity = EnumDataEntity();

      expect(entity.value, null);
      expect(entity.options, []);
    });
  });

  group('Equality', () {
    final string = StringDataEntity('Value');
    final stringEquals = StringDataEntity('Value');
    final stringUnequals = StringDataEntity('otherValue');
    final integer = IntegerDataEntity(2);
    final date = DateDataEntity.fromJson('2020-03-03');
    final dateTime = DateTimeDataEntity.fromJson('2020-03-03T12:12:12.000');
    final boolean = BooleanDataEntity(true);
    final selection =
        EnumDataEntity(value: 'value', options: ['value', 'otherValue']);
    final equalSelection =
        EnumDataEntity(value: 'value', options: ['value', 'otherValue']);
    final unEqualSelection =
        EnumDataEntity(value: 'otherValue', options: ['value', 'otherValue']);

    test('equals', () {
      expect(string == stringEquals, true);
      expect(string.hashCode - stringEquals.hashCode == 0, true);
      expect(selection == equalSelection, true);
      expect(selection.hashCode - equalSelection.hashCode == 0, true);
    });
    test('not equals', () {
      expect(string == stringUnequals, false);
      expect(string.hashCode - stringUnequals.hashCode == 0, false);
      expect(string.hashCode != integer.hashCode, true);
      expect(string.hashCode != date.hashCode, true);
      expect(string.hashCode != dateTime.hashCode, true);
      expect(string.hashCode != boolean.hashCode, true);
      expect(selection == unEqualSelection, false);
      expect(selection.hashCode - unEqualSelection.hashCode == 0, false);
    });
  });
}
