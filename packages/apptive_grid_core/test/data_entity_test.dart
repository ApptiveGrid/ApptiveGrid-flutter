import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String', () {
    test('Value is set', () {
      final entity = StringDataEntity('Value');

      expect(entity.value, equals('Value'));
      expect(entity.schemaValue, equals('Value'));
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, equals(null));
    });
  });

  group('Integer', () {
    test('Value is set', () {
      final entity = IntegerDataEntity(3);

      expect(entity.value, equals(3));
      expect(entity.schemaValue, equals(3));
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, equals(null));
    });
  });

  group('Decimal', () {
    test('Value is set', () {
      final entity = DecimalDataEntity(47.11);

      expect(entity.value, equals(47.11));
      expect(entity.schemaValue, equals(47.11));
    });

    test('Default is null', () {
      final entity = StringDataEntity();

      expect(entity.value, equals(null));
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

      expect(entity.value, equals(date));
      expect(entity.schemaValue, equals('2020-03-03'));
    });

    test('Json is parsed', () {
      final date = DateTime(
        2020,
        3,
        3,
      );
      final entity = DateDataEntity.fromJson('2020-03-03');

      expect(entity.value, equals(date));
      expect(entity.schemaValue, equals('2020-03-03'));
    });

    test('Default is null', () {
      final entity = DateDataEntity();

      expect(entity.value, equals(null));
    });
  });

  group('DateTime', () {
    test('Value is set', () {
      final date = DateTime(2020, 3, 3, 12, 12, 12).toLocal();
      final entity = DateTimeDataEntity(date);

      expect(entity.value?.toLocal(), equals(date));
      expect(entity.schemaValue, equals('2020-03-03T11:12:12.000Z'));
    });

    test('Json is parsed', () {
      final date = DateTime(2020, 3, 3, 12, 12, 12).toLocal();
      final entity = DateTimeDataEntity.fromJson('2020-03-03T11:12:12.000Z');

      expect(entity.value?.toLocal(), equals(date));
      expect(entity.schemaValue, equals('2020-03-03T11:12:12.000Z'));
    });

    test('Default is null', () {
      final entity = DateTimeDataEntity();

      expect(entity.value, equals(null));
    });
  });

  group('Boolean', () {
    test('Value is set', () {
      final entity = BooleanDataEntity(true);

      expect(entity.value, equals(true));
      expect(entity.schemaValue, equals(true));
    });

    test('Default is false', () {
      final entity = BooleanDataEntity();

      expect(entity.value, equals(false));
    });
  });

  group('Enum', () {
    test('Value is set', () {
      const value = 'value';
      final values = {'value', 'otherValue'};
      final entity = EnumDataEntity(value: value, options: values);

      expect(entity.value, equals(value));
      expect(entity.options, equals(values));
      expect(entity.schemaValue, equals(value));
    });

    test('Default is null', () {
      final entity = EnumDataEntity();

      expect(entity.value, equals(null));
      expect(entity.options, equals([]));
    });
  });

  group('EnumCollection', () {
    test('Value is set', () {
      const value = 'value';
      final values = {'value', 'otherValue'};
      final entity = EnumCollectionDataEntity(value: {value}, options: values);

      expect(entity.value, equals({value}));
      expect(entity.options, equals(values));
      expect(entity.schemaValue, equals([value]));
    });

    test('Default is empty list', () {
      final entity = EnumCollectionDataEntity();

      expect(entity.value, equals(<String>{}));
      expect(entity.options, equals(<String>{}));
      expect(entity.schemaValue, equals(null));
    });

    group('Equality', () {
      test('Equals', () {
        final a =
            EnumCollectionDataEntity(value: {'A', 'B'}, options: {'A', 'B'});
        final b =
            EnumCollectionDataEntity(value: {'A', 'B'}, options: {'A', 'B'});

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test(
          'Different Order Value Set '
          'equals but different Hashcode', () {
        final a =
            EnumCollectionDataEntity(value: {'A', 'B'}, options: {'A', 'B'});
        final b =
            EnumCollectionDataEntity(value: {'B', 'A'}, options: {'A', 'B'});

        expect(a, equals(b));
        expect(a.hashCode, isNot(b.hashCode));
      });

      test('Unequals', () {
        final a =
            EnumCollectionDataEntity(value: {'A', 'B'}, options: {'A', 'B'});
        final b = EnumCollectionDataEntity(
          value: {
            'B',
          },
          options: {'A', 'B'},
        );

        expect(a, isNot(b));
        expect(a.hashCode, isNot(b.hashCode));
      });
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
        EnumDataEntity(value: 'value', options: {'value', 'otherValue'});
    final equalSelection =
        EnumDataEntity(value: 'value', options: {'value', 'otherValue'});
    final unEqualSelection =
        EnumDataEntity(value: 'otherValue', options: {'value', 'otherValue'});

    test('equals', () {
      expect(string, equals(stringEquals));
      expect(string.hashCode, equals(stringEquals.hashCode));
      expect(selection, equals(equalSelection));
      expect(selection.hashCode, equals(equalSelection.hashCode));
    });
    test('not equals', () {
      expect(string, isNot(stringUnequals));
      expect(string.hashCode, isNot(stringUnequals.hashCode));
      expect(string.hashCode, isNot(integer.hashCode));
      expect(string.hashCode, isNot(date.hashCode));
      expect(string.hashCode, isNot(dateTime.hashCode));
      expect(string.hashCode, isNot(boolean.hashCode));
      expect(selection, isNot(unEqualSelection));
      expect(selection.hashCode, isNot(unEqualSelection.hashCode));
    });
  });

  group('Attachment', () {
    test('Value is set', () {
      final attachments = <Attachment>[
        Attachment(name: 'one', url: Uri.parse('one'), type: 'image/png'),
        Attachment(name: 'two', url: Uri.parse('two'), type: 'image/png'),
      ];
      final entity = AttachmentDataEntity(attachments);

      expect(entity.value, equals(attachments));
      expect(
        entity.schemaValue,
        attachments.map((attachment) => attachment.toJson()),
      );
    });

    test('From Json', () {
      final attachments = <Attachment>[
        Attachment(name: 'one', url: Uri.parse('one'), type: 'image/png'),
        Attachment(name: 'two', url: Uri.parse('two'), type: 'image/png'),
      ];
      final direct = AttachmentDataEntity(attachments);

      final fromJson = AttachmentDataEntity.fromJson(
        attachments.map((attachment) => attachment.toJson()).toList(),
      );

      expect(direct, equals(fromJson));
      expect(direct.hashCode, equals(fromJson.hashCode));
    });

    test('Null json is Empty List', () {
      final entity = AttachmentDataEntity.fromJson(null);

      expect(entity.value, equals([]));
      expect(entity.schemaValue, isNull);
    });

    test('Default is Empty List', () {
      final entity = AttachmentDataEntity();

      expect(entity.value, equals([]));
      expect(entity.schemaValue, isNull);
    });
  });
}
