# ApptiveGrid GridBuilder

[![Pub](https://img.shields.io/pub/v/apptive_grid_grid_builder.svg)](https://pub.dartlang.org/packages/apptive_grid_grid_builder)  [![pub points](https://badges.bar/apptive_grid_grid_builder/pub%20points)](https://pub.dev/packages/apptive_grid_grid_builder/score)  [![popularity](https://badges.bar/apptive_grid_grid_builder/popularity)](https://pub.dev/packages/apptive_grid_grid_builder/score)  [![likes](https://badges.bar/apptive_grid_grid_builder/likes)](https://pub.dev/packages/apptive_grid_grid_builder/score)

A Flutter Package to build Widgets based on Grid Data

## Setup

In order to use any ApptiveGrid Feature you must wrap your App with a `ApptiveGrid` Widget

```dart
import 'package:apptive_grid_core/apptive_grid_core.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
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

Grids need Authentication. In order to authenticate a user either manually call `ApptiveGrid.getClient(context).authenticate()`.
Alternatively you can set `autoAuthenticate` to `true` in `ApptiveGridAuthenticationOptions` in the `ApptiveGridOptions`
### Auth Redirect
To get redirected by authentication you need to provide a custom `redirectScheme` in `ApptiveGridAuthenticationOptions`
```dart
ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.beta,
        authenticationOptions: ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          redirectScheme: 'apptivegrid'
        ),
      ),
      child: MyApp()));
```
Also make sure that your app can be opened with that redirect Link. For more info check the documentation of [uni_links](https://pub.dev/packages/uni_links)
### Flutter Web
If you want to use it with Flutter web you need to call and await `enableWebAuth` before runApp. This takes care of the redirect of the Authentication Server

```dart
void main() async {
  await enableWebAuth(options);
  runApp(ApptiveGrid(child: MyApp()));
}
```

## Usage

Add `ApptiveGridGridBuilder` to your widget tree. The `builder` behaves the same as `FutureBuilder`.

```dart
ApptiveGridGridBuilder(
    gridUri: GridUri(
        user: 'USER_ID',
        space: 'SPACE_ID',
        grid: 'GRID_ID',
    ),
    builder: (context, snapshot) {
        return YourWidget(gridData: snapshot.data);
    }
);
```

