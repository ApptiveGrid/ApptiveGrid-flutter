import 'package:alchemist/alchemist.dart';
import 'package:apptive_grid_theme/src/apptive_grid_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart' show loadAppFonts;

import '../font_util.dart';

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
      'Light': ApptiveGridTheme.create(brightness: Brightness.light),
      'Dark': ApptiveGridTheme.create(brightness: Brightness.dark),
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
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  goldenTestInLightAndDark(
    description: 'Buttons',
    fileName: 'buttons',
    columns: 2,
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
      'Icon button enabled': Center(
        child: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {},
        ),
      ),
      'Icon button disabled': const Center(
        child: IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: null,
        ),
      ),
      'Floating Action Button Enabled': Center(
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      'Floating Action Button Disabled': const Center(
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(
            Icons.add,
          ),
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
    constraints: const BoxConstraints(maxWidth: 1500),
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
      ),
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
          ),
        ],
      ),
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
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Text Theme',
    fileName: 'text',
    constraints: const BoxConstraints(maxWidth: 1500),
    scenarios: {
      'Display Large': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.displayLarge;
          return Text(
            'Display Large \n(Size: ${style?.fontSize},  Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Display Medium': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.displayMedium;
          return Text(
            'Display Medium \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Display Small': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.displaySmall;
          return Text(
            'Display Small \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Headline Large': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.headlineLarge;
          return Text(
            'Headline Large \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Headline Medium': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.headlineMedium;
          return Text(
            'Headline Medium \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Headline Small': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.headlineSmall;
          return Text(
            'Headline Small \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Title Large': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.titleLarge;
          return Text(
            'Title Large \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Title Medium': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.titleMedium;
          return Text(
            'Title Medium \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Title Small': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.titleSmall;
          return Text(
            'Title Small \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Body Large': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.bodyLarge;
          return Text(
            'Body Large \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Body Medium': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.bodyMedium;
          return Text(
            'Body Medium \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Body Small': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.bodySmall;
          return Text(
            'Body Small \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Label Large': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.labelLarge;
          return Text(
            'Label Large \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Label Medium': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.labelMedium;
          return Text(
            'Label Medium \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
      ),
      'Label Small': Builder(
        builder: (context) {
          final style = Theme.of(context).textTheme.labelSmall;
          return Text(
            'Label Small \n(Size: ${style?.fontSize}, Weight: ${style?.fontWeight})',
            style: style,
          );
        },
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

  goldenTestInLightAndDark(
    description: 'Checkbox',
    fileName: 'checkbox',
    scenarios: {
      'Checked': Checkbox(
        value: true,
        onChanged: (_) {},
      ),
      'Un-Checked': Checkbox(
        value: false,
        onChanged: (_) {},
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Switch',
    fileName: 'switch',
    scenarios: {
      'Checked': Switch(
        value: true,
        onChanged: (_) {},
      ),
      'Un-Checked': Switch(
        value: false,
        onChanged: (_) {},
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Radio',
    fileName: 'radio',
    scenarios: {
      'Checked': Radio(
        value: true,
        groupValue: true,
        onChanged: (_) {},
      ),
      'Un-Checked': Radio(
        value: false,
        groupValue: true,
        onChanged: (_) {},
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Slider',
    fileName: 'slider',
    scenarios: {
      'Default': Slider(
        value: 0.5,
        label: 'Label',
        onChanged: (_) {},
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Progress Indicator',
    fileName: 'progress_indicator',
    scenarios: {
      'Circular': const CircularProgressIndicator(
        value: 0.5,
      ),
      'Linear': const LinearProgressIndicator(
        value: 0.5,
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Divider',
    fileName: 'divider',
    scenarios: {
      'Divider': const Divider(),
    },
  );

  goldenTestInLightAndDark(
    description: 'List Tile',
    fileName: 'list_tile',
    scenarios: {
      'Title': const ListTile(
        title: Text('Title'),
      ),
      'With Subtitle': const ListTile(
        title: Text('Title'),
        subtitle: Text('Subtitle'),
      ),
      'With Leading': const ListTile(
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        leading: Icon(Icons.account_circle),
      ),
      'With Trailing': const ListTile(
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        leading: Icon(Icons.account_circle),
        trailing: Icon(Icons.chevron_right),
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'Bottom Navigation Bar',
    fileName: 'bottom_navigation_bar',
    scenarios: {
      'Bottom Navigation Bar': BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Item 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Item 2',
          ),
        ],
      ),
    },
  );

  goldenTestInLightAndDark(
    description: 'TabBar',
    fileName: 'tab_bar',
    scenarios: {
      'TabBar': const DefaultTabController(
        length: 2,
        child: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.favorite), text: 'Item 1'),
            Tab(icon: Icon(Icons.person), text: 'Item 2'),
          ],
        ),
      ),
    },
  );
}
