import 'dart:io';
import 'dart:typed_data';

import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestApp extends StatelessWidget {
  _TestApp({
    Key? key,
    this.appBarBuilder,
    this.isDark = false,
    required this.childBuilder,
  }) : super(key: key);

  final Widget Function(ThemeData data) childBuilder;
  final bool isDark;
  final AppBar? Function(ThemeData data)? appBarBuilder;

  late final _themeData = isDark
      ? ApptiveGridTheme(brightness: Brightness.dark).theme()
      : ApptiveGridTheme(brightness: Brightness.light).theme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData,
      darkTheme: _themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appBarBuilder?.call(_themeData),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: childBuilder(_themeData),
        ),
      ),
    );
  }
}

Future<void> loadFonts() async {
  //https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }

  final bold = File('fonts/DMSans-Bold.ttf')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
  final medium = File('fonts/DMSans-Medium.ttf')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
  final regular = File('fonts/DMSans-Regular.ttf')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
  final fontLoader = FontLoader('DMSans')
    ..addFont(bold)
    ..addFont(medium)
    ..addFont(regular);
  await fontLoader.load();

  final icons = File('fonts/ApptiveGridIcons.ttf')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
  final iconLoader = FontLoader('ApptiveGridIcons')..addFont(icons);
  await iconLoader.load();
}

void main() {
  String _goldenFilePath(String name, {bool isDark = false}) =>
      'goldenFiles/${name}_${isDark ? 'dark' : 'light'}.png';

  setUpAll(() async {
    await loadFonts();
  });

  Future<void> _test(
    Widget Function(ThemeData data) testableBuilder,
    String name,
    WidgetTester tester, {
    AppBar? Function(ThemeData data)? appBarBuilder,
  }) async {
    debugDisableShadows = false;
    tester.binding.window.physicalSizeTestValue = const Size(720, 1290);

    final testApp = _TestApp(
      appBarBuilder: appBarBuilder,
      childBuilder: testableBuilder,
    );

    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(_TestApp),
      matchesGoldenFile(_goldenFilePath(name)),
    );

    final testAppDark = _TestApp(
      isDark: true,
      appBarBuilder: appBarBuilder,
      childBuilder: testableBuilder,
    );

    await tester.pumpWidget(testAppDark);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(_TestApp),
      matchesGoldenFile(_goldenFilePath(name, isDark: true)),
    );

    debugDisableShadows = true;
    tester.binding.window.clearAllTestValues();
  }

  group('Buttons', () {
    testWidgets('ElevatedButton Enabled', (widgetTester) async {
      await _test(
        (data) => Center(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Enabled',
            ),
          ),
        ),
        'ElevatedButton_enabled',
        widgetTester,
      );
    });

    testWidgets('ElevatedButton disabled', (widgetTester) async {
      await _test(
        (data) => const Center(
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              'Disabled',
            ),
          ),
        ),
        'ElevatedButton_disabled',
        widgetTester,
      );
    });

    testWidgets('TextButton Enabled', (widgetTester) async {
      await _test(
        (data) => Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Enabled',
            ),
          ),
        ),
        'TextButton_enabled',
        widgetTester,
      );
    });

    testWidgets('TextButton disabled', (widgetTester) async {
      await _test(
        (data) => const Center(
          child: TextButton(
            onPressed: null,
            child: Text(
              'Disabled',
            ),
          ),
        ),
        'TextButton_disabled',
        widgetTester,
      );
    });

    testWidgets('OutlinedButton Enabled', (widgetTester) async {
      await _test(
        (data) => Center(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text(
              'Enabled',
            ),
          ),
        ),
        'OutlinedButton_enabled',
        widgetTester,
      );
    });

    testWidgets('OutlinedButton disabled', (widgetTester) async {
      await _test(
        (data) => const Center(
          child: OutlinedButton(
            onPressed: null,
            child: Text(
              'Disabled',
            ),
          ),
        ),
        'OutlinedButton_disabled',
        widgetTester,
      );
    });

    testWidgets('Icon button theme', (widgetTester) async {
      await _test(
        (data) => Center(
          child: IconButton(
            icon: const Icon(
              ApptiveGridIcons.grid,
            ),
            onPressed: () {},
          ),
        ),
        'IconButton',
        widgetTester,
      );
    });
  });

  group('TextField', () {
    testWidgets('TextField Empty', (widgetTester) async {
      await _test(
        (data) => Center(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Hint',
            ),
          ),
        ),
        'TextField_empty',
        widgetTester,
      );
    });

    testWidgets('TextField Filled', (widgetTester) async {
      await _test(
        (data) => Center(
          child: TextFormField(
            initialValue: 'Input',
            decoration: const InputDecoration(
              hintText: 'Hint',
            ),
          ),
        ),
        'TextField_filled',
        widgetTester,
      );
    });

    testWidgets('TextField Error', (widgetTester) async {
      await _test(
        (data) => Center(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Hint',
              errorText: 'Error',
            ),
          ),
        ),
        'TextField_error',
        widgetTester,
      );
    });
  });

  testWidgets('Card theme', (widgetTester) async {
    await _test(
      (data) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Test',
            ),
          ),
        ),
      ),
      'Card',
      widgetTester,
    );
  });

  testWidgets('Alert dialog theme', (widgetTester) async {
    await _test(
      (data) => AlertDialog(
        title: const Text(
          'Title',
        ),
        content: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Dialog Content'),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('OK'),
          )
        ],
      ),
      'AlertDialog',
      widgetTester,
    );
  });

  testWidgets('App bar theme', (widgetTester) async {
    await _test(
      (data) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Body',
        ),
      ),
      'AppBar',
      widgetTester,
      appBarBuilder: (data) => AppBar(
        title: const Text(
          'Test',
        ),
      ),
    );
  });

  testWidgets('Text theme', (widgetTester) async {
    await _test(
      (data) => Center(
        child: Column(
          children: [
            Text(
              'BodyText1',
              style: data.textTheme.bodyText1,
            ),
            Text(
              'BodyText2',
              style: data.textTheme.bodyText2,
            ),
            Text(
              'Caption',
              style: data.textTheme.caption,
            ),
            Text(
              'Headline1',
              style: data.textTheme.headline1,
            ),
            Text(
              'Headline2',
              style: data.textTheme.headline2,
            ),
            Text(
              'Headline3',
              style: data.textTheme.headline3,
            ),
            Text(
              'Headline4',
              style: data.textTheme.headline4,
            ),
            Text(
              'Headline5',
              style: data.textTheme.headline5,
            ),
            Text(
              'Headline6',
              style: data.textTheme.headline6,
            ),
            Text(
              'Overline',
              style: data.textTheme.overline,
            ),
            Text(
              'Subtitle1',
              style: data.textTheme.subtitle1,
            ),
            Text(
              'Subtitle2',
              style: data.textTheme.subtitle2,
            ),
          ],
        ),
      ),
      'Text',
      widgetTester,
    );
  });
}
