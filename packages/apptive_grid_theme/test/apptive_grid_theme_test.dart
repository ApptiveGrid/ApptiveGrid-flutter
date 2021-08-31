import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptive_grid_theme/apptive_grid_theme.dart';

class _TestApp extends StatelessWidget {
  _TestApp(
      {Key? key,
      required AppBar? Function(ThemeData data) this.appBarBuilder,
      bool this.isDark = false,
      required Widget Function(ThemeData data) this.childBuilder})
      : super(key: key);

  final Widget Function(ThemeData data) childBuilder;
  final bool isDark;
  final AppBar? Function(ThemeData data) appBarBuilder;

  late final _themeData = isDark
      ? ApptiveGridTheme(brightness: Brightness.dark).theme()
      : ApptiveGridTheme(brightness: Brightness.light).theme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData,
      darkTheme: _themeData,
      home: Scaffold(
        appBar: appBarBuilder(_themeData),
        body: Theme(data: _themeData, child: childBuilder(_themeData)),
      ),
    );
  }
}

void main() {
  String _goldenFilePath(String name, {bool isDark = false}) =>
      'goldenFiles/' + (isDark ? 'dark' : 'light') + '/' + name + '.png';

  void _test(Widget Function(ThemeData data) testableBuilder, String name,
      WidgetTester widgetTester,
      {AppBar? Function(ThemeData data)? appBarBuilder}) async {
    appBarBuilder ??= (data) => null;
    final testApp = _TestApp(
      appBarBuilder: appBarBuilder,
      childBuilder: testableBuilder,
    );

    await widgetTester.pumpWidget(testApp);
    await expectLater(
        find.byType(_TestApp), matchesGoldenFile(_goldenFilePath(name)));

    final testAppDark = _TestApp(
      isDark: true,
      appBarBuilder: appBarBuilder,
      childBuilder: testableBuilder,
    );

    await widgetTester.pumpWidget(testAppDark);
    await expectLater(find.byType(_TestApp),
        matchesGoldenFile(_goldenFilePath(name, isDark: true)));
  }

  testWidgets('TextField theme', (widgetTester) async {
    _test(
        (data) => TextField(
              style: data.textTheme.bodyText1,
              controller: TextEditingController(
                text: 'Test',
              ),
            ),
        'TextField',
        widgetTester);
  });

  testWidgets('Elevated button theme', (widgetTester) async {
    _test(
        (data) => ElevatedButton(
              onPressed: null,
              style: data.elevatedButtonTheme.style,
              child: Text(
                'Button',
                style: data.textTheme.button,
              ),
            ),
        'ElevatedButton',
        widgetTester);
  });

  testWidgets('Text button theme', (widgetTester) async {
    _test(
        (data) => TextButton(
              onPressed: null,
              style: data.elevatedButtonTheme.style,
              child: Text(
                'Button',
                style: data.textTheme.button,
              ),
            ),
        'TextButton',
        widgetTester);
  });

  testWidgets('Text form field theme', (widgetTester) async {
    _test(
        (data) => TextFormField(
              initialValue: 'Test',
              style: data.textTheme.bodyText1,
            ),
        'TextFormField',
        widgetTester);
  });

  testWidgets('Popup menu button theme', (widgetTester) async {
    _test(
        (data) => PopupMenuButton(
              itemBuilder: (context) => [],
            ),
        'PopupMenuButton',
        widgetTester);
  });

  testWidgets('Icon button theme', (widgetTester) async {
    _test(
        (data) => IconButton(
              icon: Text(
                'Test',
                style: data.textTheme.button,
              ),
              onPressed: null,
            ),
        'IconButton',
        widgetTester);
  });

  testWidgets('Card theme', (widgetTester) async {
    _test(
        (data) => Card(
              child: Text(
                'Test',
                style: data.textTheme.bodyText1,
              ),
            ),
        'Card',
        widgetTester);
  });

  testWidgets('Alert dialog theme', (widgetTester) async {
    _test(
        (data) => AlertDialog(
              title: Text(
                'Test',
                style: data.textTheme.bodyText1,
              ),
            ),
        'AlertDialog',
        widgetTester);
  });

  testWidgets('App bar theme', (widgetTester) async {
    _test(
        (data) => Text(
              'Body',
              style: data.textTheme.bodyText1,
            ),
        'AppBar',
        widgetTester,
        appBarBuilder: (data) => AppBar(
              title: Text(
                'Test',
                style: data.textTheme.headline5,
              ),
            ));
  });

  testWidgets('Text theme', (widgetTester) async {
    _test(
        (data) => Column(
              children: [
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.bodyText2,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.caption,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline1,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline2,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline3,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline4,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline5,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.headline6,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.overline,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    'test',
                    style: data.textTheme.subtitle2,
                  ),
                ),
              ],
            ),
        'Text',
        widgetTester);
  });
}
