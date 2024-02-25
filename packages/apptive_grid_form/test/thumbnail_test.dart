import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/src/widgets/attachment/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'common.dart';
import 'util/mocktail_custom_image_network.dart';
import 'package:http/http.dart' as http;

// Create a mock class for SvgLoader using mocktail

class TestLoader extends SvgNetworkLoader {
  const TestLoader({
    required String url,
    this.keyName = 'A',
    SvgTheme? theme,
    ColorMapper? colorMapper,
  }) : super(
          url,
          theme: theme,
          colorMapper: colorMapper,
        );
  final String keyName;

  @override
  String provideSvg(Uint8List? message) {
    return '<svg width="10" height="10"></svg>';
  }

  @override
  SvgCacheKey cacheKey(BuildContext? context) {
    return SvgCacheKey(
      theme: getTheme(context),
      colorMapper: colorMapper,
      keyData: keyName,
    );
  }
}

class _FakeHttpClient extends Fake implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return http.Response(_svgStr, 200);
  }
}

const String _svgStr = '''
<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
</svg>
''';

void main() {
  group('Files', () {
    testWidgets('application/pdf shows pdf file', (tester) async {
      final target = MaterialApp(
        home: SizedBox(
          width: 70,
          height: 70,
          child: Thumbnail(
            attachment: Attachment(
              name: 'pdf',
              url: Uri(path: '/attachmentPath'),
              type: 'application/pdf',
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);

      expect(
        find.descendant(
          of: find.byType(Thumbnail),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });
  });

  group('Images', () {
    testWidgets('Shows image from url', (tester) async {
      await mockNetworkImages(() async {
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: Attachment(
                name: 'svg',
                url: Uri(path: '/uri'),
                type: 'image/png',
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final imageUrl = ((find.byType(Image).evaluate().first.widget as Image)
                .image as NetworkImage)
            .url;
        expect(imageUrl, '/uri');
      });
    });

    testWidgets('Shows image from large thumbnail', (tester) async {
      await mockNetworkImages(() async {
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: Attachment(
                name: 'svg',
                url: Uri(path: '/uri'),
                largeThumbnail: Uri(path: '/largeThumbnailUri'),
                type: 'image/png',
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final imageUrl = ((find.byType(Image).evaluate().first.widget as Image)
                .image as NetworkImage)
            .url;
        expect(imageUrl, '/largeThumbnailUri');
      });
    });

    testWidgets('Shows image from small thumbnail', (tester) async {
      await mockNetworkImages(() async {
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: Attachment(
                name: 'svg',
                url: Uri(path: '/uri'),
                largeThumbnail: Uri(path: '/largeThumbnailUri'),
                smallThumbnail: Uri(path: '/smallThumbnailUri'),
                type: 'image/png',
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final imageUrl = ((find.byType(Image).evaluate().first.widget as Image)
                .image as NetworkImage)
            .url;
        expect(imageUrl, '/smallThumbnailUri');
      });
    });

    group('Add Attachment', () {
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        largeThumbnail: Uri(path: '/largeThumbnailUri'),
        smallThumbnail: Uri(path: '/smallThumbnailUri'),
        type: 'image/png',
      );
      testWidgets('Shows image from file', (tester) async {
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: attachment,
              addAttachmentAction: AddAttachmentAction(
                attachment: attachment,
                path: '/attachmentPath',
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final file = ((find.byType(Image).evaluate().first.widget as Image)
                .image as FileImage)
            .file;
        expect(file.path, '/attachmentPath');
      });

      testWidgets('Shows image from memory', (tester) async {
        final bytes = base64Decode(
          '''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''',
        );
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: attachment,
              addAttachmentAction: AddAttachmentAction(
                attachment: attachment,
                byteData: bytes,
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final imageBytes =
            ((find.byType(Image).evaluate().first.widget as Image).image
                    as MemoryImage)
                .bytes;
        expect(imageBytes, bytes);
      });
    });
  });

  group('SVG Images', () {
    testWidgets('Shows image from url', (tester) async {
      final http.Client fakeClient = _FakeHttpClient();
      final mockSvgLoader = SvgNetworkLoader('/uri', httpClient: fakeClient);

      final target = MaterialApp(
        home: SizedBox(
          width: 70,
          height: 70,
          child: Thumbnail(
            attachment: Attachment(
              name: 'svg',
              url: Uri(path: '/uri'),
              type: 'image/svg',
            ),
            svgLoader: mockSvgLoader,
          ),
        ),
      );

      await tester.pumpWidget(target);

      final imageUrl =
          ((find.byType(SvgPicture).evaluate().first.widget as SvgPicture)
                  .bytesLoader as SvgNetworkLoader)
              .url;
      expect(imageUrl, '/uri');
    });

    group('Add Attachment', () {
      final bytes = base64Decode(
        '''PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNyIgaGVpZ2h0PSIxNyI+CjxwYXRoIGZpbGw9IiMwRkZGMDAiIHN0cm9rZT0iIzBGMEYwMCIgc3Ryb2tlLXdpZHRoPSIwIiBkPSJtNCw0djloOVY0eiIvPgo8L3N2Zz4=''',
      );
      final attachment = Attachment(
        name: 'svg',
        url: Uri(path: '/uri'),
        largeThumbnail: Uri(path: '/largeThumbnailUri'),
        smallThumbnail: Uri(path: '/smallThumbnailUri'),
        type: 'image/svg',
      );
      testWidgets('Shows image from file', (tester) async {
        final mockFile = MockFile();
        when(() => mockFile.readAsBytesSync()).thenReturn(bytes);
        await IOOverrides.runZoned(
          () async {
            final target = MaterialApp(
              home: SizedBox(
                width: 70,
                height: 70,
                child: Thumbnail(
                  attachment: attachment,
                  addAttachmentAction: AddAttachmentAction(
                    attachment: attachment,
                    path: '/attachmentPath',
                  ),
                ),
              ),
            );

            await tester.pumpWidget(target);

            final file =
                ((find.byType(SvgPicture).evaluate().first.widget as SvgPicture)
                        .bytesLoader as SvgFileLoader)
                    .file;
            expect(file.path, '/attachmentPath');
          },
          createFile: (dir) {
            when(() => mockFile.path).thenReturn(dir);
            return mockFile;
          },
        );
      });

      testWidgets('Shows image from memory', (tester) async {
        final target = MaterialApp(
          home: SizedBox(
            width: 70,
            height: 70,
            child: Thumbnail(
              attachment: attachment,
              addAttachmentAction: AddAttachmentAction(
                attachment: attachment,
                byteData: bytes,
              ),
            ),
          ),
        );

        await tester.pumpWidget(target);

        final imageBytes =
            ((find.byType(SvgPicture).evaluate().first.widget as SvgPicture)
                    .bytesLoader as SvgBytesLoader)
                .bytes;
        expect(imageBytes, bytes);
      });
    });
  });
}
