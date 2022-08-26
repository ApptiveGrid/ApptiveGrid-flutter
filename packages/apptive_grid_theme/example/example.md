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