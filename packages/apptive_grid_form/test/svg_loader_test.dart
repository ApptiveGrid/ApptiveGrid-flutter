import 'dart:typed_data';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/attachment/thumbnail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAttachment extends Mock implements Attachment {}

class MockAddAttachmentAction extends Mock implements AddAttachmentAction {}

void main() {
  group('SvgLoaderFactory Tests', () {
    test(
        'returns SvgNetworkLoader when only Attachment with largeThumbnailUri is provided',
        () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        largeThumbnail: Uri(path: '/largeThumbnailUri'),
        type: 'image/svg',
      );

      final loader = SvgLoaderFactory.getLoader(attachment: attachment);

      expect(loader, isA<SvgNetworkLoader>());
      expect((loader as SvgNetworkLoader).url, '/largeThumbnailUri');
    });

    test(
        'returns SvgNetworkLoader when only Attachment with smallThumbnail is provided',
        () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        smallThumbnail: Uri(path: '/smallThumbnail'),
        type: 'image/svg',
      );

      final loader = SvgLoaderFactory.getLoader(attachment: attachment);

      expect(loader, isA<SvgNetworkLoader>());
      expect((loader as SvgNetworkLoader).url, '/smallThumbnail');
    });

    test('returns SvgNetworkLoader when only Attachment with uri is provided',
        () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        type: 'image/svg',
      );

      final loader = SvgLoaderFactory.getLoader(attachment: attachment);

      expect(loader, isA<SvgNetworkLoader>());
      expect((loader as SvgNetworkLoader).url, '/uri');
    });

    test('returns SvgFileLoader when AddAttachmentAction with path is provided',
        () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        largeThumbnail: Uri(path: '/largeThumbnailUri'),
        type: 'image/svg',
      );
      final action =
          AddAttachmentAction(path: 'path/to/file.svg', attachment: attachment);

      final loader = SvgLoaderFactory.getLoader(addAttachmentAction: action);

      expect(loader, isA<SvgFileLoader>());
    });

    test(
        'returns SvgBytesLoader when AddAttachmentAction with byteData is provided',
        () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        largeThumbnail: Uri(path: '/largeThumbnailUri'),
        type: 'image/svg',
      );
      final action = AddAttachmentAction(
        byteData: Uint8List(10),
        attachment: attachment,
      ); // Example byte data

      final loader = SvgLoaderFactory.getLoader(addAttachmentAction: action);

      expect(loader, isA<SvgBytesLoader>());
    });

    test('returns provided SvgLoader when SvgLoader is explicitly provided',
        () {
      final svgLoader = SvgBytesLoader(Uint8List(10)); // Example SVG loader

      final loader = SvgLoaderFactory.getLoader(svgLoader: svgLoader);

      expect(loader, svgLoader);
    });
  });
}
