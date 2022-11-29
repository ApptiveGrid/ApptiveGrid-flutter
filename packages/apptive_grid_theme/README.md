## ApptiveGrid Theme

[![Pub](https://img.shields.io/pub/v/apptive_grid_theme.svg)](https://pub.dartlang.org/packages/apptive_grid_theme)  [![pub points](https://img.shields.io/pub/points/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)  [![popularity](https://img.shields.io/pub/popularity/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)  [![likes](https://img.shields.io/pub/likes/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)

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
