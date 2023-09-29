import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From json', () async {
      dynamic json = {
        'id': 'id',
        'pageId': 'pageId',
        'fieldIndex': 0,
        'text': 'text',
        'type': 'type',
        'style': 'style',
      };

      expect(
        FormBlock.fromJson(json),
        FormBlock(
          id: 'id',
          pageId: 'pageId',
          fieldIndex: 0,
          text: 'text',
          type: 'type',
          style: 'style',
        ),
      );
    });
    test('To json', () async {
      final block = FormBlock(
        id: 'id',
        pageId: 'pageId',
        fieldIndex: 0,
        text: 'text',
        type: 'type',
        style: 'style',
      );

      expect(
        block.toJson(),
        {
          'id': 'id',
          'pageId': 'pageId',
          'fieldIndex': 0,
          'text': 'text',
          'type': 'type',
          'style': 'style',
        },
      );
    });
  });
  test('Equality', () async {
    final a = FormBlock(
      id: 'id',
      pageId: 'pageId',
      fieldIndex: 0,
      text: 'text',
      type: 'type',
      style: 'style',
    );

    final b = FormBlock(
      id: 'id',
      pageId: 'pageId',
      fieldIndex: 0,
      text: 'text',
      type: 'type',
      style: 'style',
    );

    final c = FormBlock(
      id: 'id2',
      pageId: 'pageId',
      fieldIndex: 0,
      text: 'text',
      type: 'type',
      style: 'style',
    );

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
    expect(b, isNot(equals(c)));
  });
  test('toString', () async {
    final formBlock = FormBlock(
      id: 'id',
      pageId: 'pageId',
      fieldIndex: 0,
      text: 'text',
      type: 'type',
      style: 'style',
    );

    expect(
      formBlock.toString(),
      'FormBlock(id: id, pageId: pageId, fieldIndex: 0, text: text, type: type, style: style)',
    );
  });
  test('Hashcode', () async {
    final formBlock = FormBlock(
      id: 'id',
      pageId: 'pageId',
      fieldIndex: 0,
      text: 'text',
      type: 'type',
      style: 'style',
    );
    expect(
      formBlock.hashCode,
      Object.hash(
        formBlock.id,
        formBlock.pageId,
        formBlock.fieldIndex,
        formBlock.text,
        formBlock.type,
        formBlock.style,
      ),
    );
  });
}
