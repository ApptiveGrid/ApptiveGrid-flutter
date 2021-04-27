# ActiveGrid Core

[![Pub](https://img.shields.io/pub/v/active_grid_core.svg)](https://pub.dartlang.org/packages/active_grid_core)  [![pub points](https://badges.bar/active_grid_core/pub%20points)](https://pub.dev/packages/active_grid_core/score)  [![popularity](https://badges.bar/active_grid_core/popularity)](https://pub.dev/packages/active_grid_core/score)  [![likes](https://badges.bar/active_grid_core/likes)](https://pub.dev/packages/active_grid_core/score)

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
        authenticationOptions: ActiveGridAuthenticationOptions(
          autoAuthenticate = true,
        ),
      ),
      child: MyApp(),
    ),
  );
}
```

## Authentication
Some functionalities require authentication.
In order to authenticate a user either manually call `ActiveGrid.getClient(context).authenticate()`.
Alternatively you can set `autoAuthenticate` to `true` in `ActiveGridAuthenticationOptions` in the `ActiveGridOptions` this will automatically trigger the process.