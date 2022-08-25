## ApptiveGrid Theme

[![Pub](https://img.shields.io/pub/v/apptive_grid_theme.svg)](https://pub.dartlang.org/packages/apptive_grid_theme)  [![pub points](https://badges.bar/apptive_grid_theme/pub%20points)](https://pub.dev/packages/apptive_grid_theme/score)  [![popularity](https://badges.bar/apptive_grid_theme/popularity)](https://pub.dev/packages/apptive_grid_theme/score)  [![likes](https://badges.bar/apptive_grid_theme/likes)](https://pub.dev/packages/apptive_grid_theme/score)

This is a package for the theme and all the assets of ApptiveGrid apps.

## Usage

```dart
import 'package:apptive_grid_theme/apptive_grid_theme.dart';


@override
Widget build(BuildContext context) {
    return MaterialApp(
        theme: ApptiveGridTheme.light(),
        darkTheme: ApptiveGridTheme.dark(),
        home: MyWidget(),
    );
}
```
