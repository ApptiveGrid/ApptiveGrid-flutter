```dart
import 'package:apptive_grid_theme/apptive_grid_theme.dart';


@override
Widget build(BuildContext context) {
    return MaterialApp(
        theme: ApptiveGridTheme(brightness: Brightness.light).create(),
        darkTheme: ApptiveGridTheme(brightness: Brightness.dark).create(),
        home: MyWidget(),
    );
}
```