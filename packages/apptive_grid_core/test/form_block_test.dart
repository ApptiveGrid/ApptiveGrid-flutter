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
        'style': 'paragraph',
      };

      expect(
        FormTextBlock.fromJson(json),
        FormTextBlock(
          id: 'id',
          pageId: 'pageId',
          positionOnPage: 0,
          text: 'text',
          type: 'type',
          style: FormTextBlockStyle.paragraph,
        ),
      );
    });
    test('To json', () async {
      final block = FormTextBlock(
        id: 'id',
        pageId: 'pageId',
        positionOnPage: 0,
        text: 'text',
        type: 'type',
        style: FormTextBlockStyle.paragraph,
      );

      expect(
        block.toJson(),
        {
          'id': 'id',
          'pageId': 'pageId',
          'fieldIndex': 0,
          'text': 'text',
          'type': 'type',
          'style': 'paragraph',
        },
      );
    });
  });
  test('Equality', () async {
    final a = FormTextBlock(
      id: 'id',
      pageId: 'pageId',
      positionOnPage: 0,
      text: 'text',
      type: 'type',
      style: FormTextBlockStyle.paragraph,
    );

    final b = FormTextBlock(
      id: 'id',
      pageId: 'pageId',
      positionOnPage: 0,
      text: 'text',
      type: 'type',
      style: FormTextBlockStyle.paragraph,
    );

    final c = FormTextBlock(
      id: 'id2',
      pageId: 'pageId',
      positionOnPage: 0,
      text: 'text',
      type: 'type',
      style: FormTextBlockStyle.paragraph,
    );

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
    expect(b, isNot(equals(c)));
  });
  test('toString', () async {
    final formBlock = FormTextBlock(
      id: 'id',
      pageId: 'pageId',
      positionOnPage: 0,
      text: 'text',
      type: 'type',
      style: FormTextBlockStyle.paragraph,
    );

    expect(
      formBlock.toString(),
      'FormTextBlock(id: id, pageId: pageId, positionOnPage: 0, text: text, type: type, style: FormTextBlockStyle.paragraph)',
    );
  });
  test('Hashcode', () async {
    final formBlock = FormTextBlock(
      id: 'id',
      pageId: 'pageId',
      positionOnPage: 0,
      text: 'text',
      type: 'type',
      style: FormTextBlockStyle.paragraph,
    );
    expect(
      formBlock.hashCode,
      Object.hash(
        formBlock.id,
        formBlock.pageId,
        formBlock.positionOnPage,
        formBlock.text,
        formBlock.type,
        formBlock.style,
      ),
    );
  });
}
