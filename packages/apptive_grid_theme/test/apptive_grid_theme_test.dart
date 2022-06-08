import 'package:alchemist/alchemist.dart';
import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart' show loadAppFonts;

import 'font_util.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Future<void> goldenTestInLightAndDark({
    required String description,
    required String fileName,
    required Map<String, Widget> scenarios,
    BoxConstraints constraints = const BoxConstraints(maxWidth: 1600),
    int columns = 1,
  }) {
    final themes = {
      'Light': ApptiveGridTheme(brightness: Brightness.light).theme(),
      'Dark': ApptiveGridTheme(brightness: Brightness.dark).theme(),
    };
    return goldenTest(
      description,
      fileName: fileName,
      constraints: constraints,
      builder: () {
        return GoldenTestGroup(
          columns: themes.length,
          columnWidthBuilder: (_) => const FlexColumnWidth(),
          children: [
            for (final theme in themes.entries)
              GoldenTestScenario(
                name: theme.key,
                child: Theme(
                  data: theme.value.stripFontPackages(),
                  child: ColoredBox(
                    color: theme.value.scaffoldBackgroundColor,
                    child: GoldenTestGroup(
                      columns: columns,
                      columnWidthBuilder: (_) => const FlexColumnWidth(),
                      children: [
                        for (final scenario in scenarios.entries)
                          GoldenTestScenario(
                            name: scenario.key,
                            child: scenario.value,
                          )
                      ],
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  goldenTestInLightAndDark(
    description: 'Buttons',
    fileName: 'buttons',
    scenarios: {
      'ElevatedButton Enabled': Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Enabled',
          ),
        ),
      ),
      'ElevatedButton disabled': const Center(
        child: ElevatedButton(
          onPressed: null,
          child: Text(
            'Disabled',
          ),
        ),
      ),
      'TextButton Enabled': Center(
        child: TextButton(
          onPressed: () {},
          child: const Text(
            'Enabled',
          ),
        ),
      ),
      'TextButton disabled': const Center(
        child: TextButton(
          onPressed: null,
          child: Text(
            'Disabled',
          ),
        ),
      ),
      'OutlinedButton Enabled': Center(
        child: OutlinedButton(
          onPressed: () {},
          child: const Text(
            'Enabled',
          ),
        ),
      ),
      'OutlinedButton disabled': const Center(
        child: OutlinedButton(
          onPressed: null,
          child: Text(
            'Disabled',
          ),
        ),
      ),
      'Icon button': Center(
        child: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {},
        ),
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Text Field',
    fileName: 'text_field',
    scenarios: {
      'Empty': Center(
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Hint',
          ),
        ),
      ),
      'Filled': Center(
        child: TextFormField(
          initialValue: 'Input',
          decoration: const InputDecoration(
            hintText: 'Hint',
          ),
        ),
      ),
      'Error': Center(
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Hint',
            errorText: 'Error',
          ),
        ),
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Card',
    fileName: 'card',
    scenarios: {
      'Card': const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Card Test',
            ),
          ),
        ),
      )
    },
  );

  goldenTestInLightAndDark(
    description: 'Alert Dialog',
    fileName: 'alert_dialog',
    scenarios: {
      'Alert Dialog': AlertDialog(
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
      )
    },
  );

  goldenTestInLightAndDark(
    description: 'App Bar',
    fileName: 'app_bar',
    scenarios: {
      'Default': AppBar(
        title: const Text('App Bar'),
      ),
      'With Leading Icon': AppBar(
        title: const Text('App Bar'),
        leading: const Icon(Icons.arrow_back),
      ),
      'With Actions': AppBar(
        title: const Text('App Bar'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      )
    },
  );

  goldenTestInLightAndDark(
    description: 'Text Theme',
    fileName: 'text',
    scenarios: {
      'BodyText1': Builder(
        builder: (context) => Text(
          'BodyText1',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      'BodyText2': Builder(
        builder: (context) => Text(
          'BodyText2',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      'Caption': Builder(
        builder: (context) => Text(
          'Caption',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      'Headline1': Builder(
        builder: (context) => Text(
          'Headline1',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      'Headline2': Builder(
        builder: (context) => Text(
          'Headline2',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      'Headline3': Builder(
        builder: (context) => Text(
          'Headline3',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      'Headline4': Builder(
        builder: (context) => Text(
          'Headline4',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      'Headline5': Builder(
        builder: (context) => Text(
          'Headline5',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      'Headline6': Builder(
        builder: (context) => Text(
          'Headline6',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      'Overline': Builder(
        builder: (context) => Text(
          'Overline',
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      'Subtitle1': Builder(
        builder: (context) => Text(
          'Subtitle1',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      'Subtitle2': Builder(
        builder: (context) => Text(
          'Subtitle2',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Chips',
    fileName: 'chips',
    scenarios: {
      'Chip': const Chip(
        label: Text('Chip'),
      ),
      'InputChip': const InputChip(
        label: Text('InputChip'),
      ),
      'Choice Chip, Selected': ChoiceChip(
        label: const Text('Choice Chip, Selected'),
        selected: true,
        onSelected: (_) {},
      ),
      'Choice Chip, UnSelected': ChoiceChip(
        label: const Text('Choice Chip, UnSelected'),
        selected: false,
        onSelected: (_) {},
      ),
      'Choice Chip, Selected, no Callback': const ChoiceChip(
        label: Text('Choice Chip, Selected, no Callback'),
        selected: true,
      ),
      'Choice Chip, UnSelected, no Callback': const ChoiceChip(
        label: Text('Choice Chip, UnSelected, no Callback'),
        selected: false,
      ),
      'FilterChip': FilterChip(
        label: const Text('FilterChip'),
        onSelected: (_) {},
      ),
      'ActionChip': ActionChip(
        label: const Text('ActionChip'),
        onPressed: () {},
      ),
    },
  );
}
