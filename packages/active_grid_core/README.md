# ApptiveGrid Core

[![Pub](https://img.shields.io/pub/v/apptive_grid_core.svg)](https://pub.dartlang.org/packages/apptive_grid_core)  [![pub points](https://badges.bar/apptive_grid_core/pub%20points)](https://pub.dev/packages/apptive_grid_core/score)  [![popularity](https://badges.bar/apptive_grid_core/popularity)](https://pub.dev/packages/apptive_grid_core/score)  [![likes](https://badges.bar/apptive_grid_core/likes)](https://pub.dev/packages/apptive_grid_core/score)

Core Library for ApptiveGrid. This provides general access to ApptiveGrid functionalities.
It also contains authentication and general client logic so you can build your own ApptiveGrid experiences using this.

## Setup
In order to use any ApptiveGrid Feature you must wrap your App with a `ApptiveGrid` Widget

```dart
import 'package:apptive_grid_core/apptive_grid_core.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
        authenticationOptions: ApptiveGridAuthenticationOptions(
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
In order to authenticate a user either manually call `ApptiveGrid.getClient(context).authenticate()`.
Alternatively you can set `autoAuthenticate` to `true` in `ApptiveGridAuthenticationOptions` in the `ApptiveGridOptions` this will automatically trigger the process.
### Flutter Web
If you want to use it with Flutter web you need to call and await `enableWebAuth` before runApp. This takes care of the redirect of the Authentication Server

```dart
void main() async {
  await enableWebAuth();
  runApp(ApptiveGrid(child: MyApp()));
}
```