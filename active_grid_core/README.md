# ActiveGrid Core

Core Library for ActiveGrid. This provides general access to ActiveGrid functionalities.
It also contains authentication and general client logic so you can build your own ActiveGrid experiences using this.

## Setup

In order to use any ActiveGrid Feature you must wrap your App with a `ActiveGrid` Widget

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ActiveGrid(
      options: ActiveGridOptions(
        environment: ActiveGridEnvironment.alpha,
        authentication: ActiveGridAuthentication(
          username: 'USERNAME',
          password: 'PASSWORD',
        ),
      ),
      child: MyApp(),
    ),
  );
}
```
