## Apptive Grid Theme

This is a package for the theme and all the assets of Apptive Grid apps.

## Usage

```dart
import 'package:apptive_grid_theme/apptive_grid_theme.dart';


@override
Widget build(BuildContext context) {
    return MaterialApp(
        theme: ZweidenkerTheme().theme(),
        darkTheme: ZweidenkerTheme().theme(brightness: Brightness.dark),
        home: MyWidget(),
    );
}
```
