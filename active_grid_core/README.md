# ActiveGrid Core

Core Library for ActiveGrid. Other libraries should depend on this, so a manual import of this package should not be necessary.
## Setup

In order to use any ActiveGrid Feature you must wrap your App with a `ActiveGrid` Widget

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ActiveGrid(
      options: ActiveGridOptions(
        environment: ActiveGridEnvironment.alpha,
      ),
      child: MyApp(),
    ),
  );
}
```
