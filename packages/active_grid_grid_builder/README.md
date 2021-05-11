# ActiveGrid GridBuilder

[![Pub](https://img.shields.io/pub/v/active_grid_grid_builder.svg)](https://pub.dartlang.org/packages/active_grid_grid_builder)  [![pub points](https://badges.bar/active_grid_grid_builder/pub%20points)](https://pub.dev/packages/active_grid_grid_builder/score)  [![popularity](https://badges.bar/active_grid_grid_builder/popularity)](https://pub.dev/packages/active_grid_grid_builder/score)  [![likes](https://badges.bar/active_grid_grid_builder/likes)](https://pub.dev/packages/active_grid_grid_builder/score)

A Flutter Package to build Widgets based on Grid Data

## Setup

In order to use any ActiveGrid Feature you must wrap your App with a `ActiveGrid` Widget

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ActiveGrid(
      options: ActiveGridOptions(
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

Grids need Authentication. In order to authenticate a user either manually call `ActiveGrid.getClient(context).authenticate()`.
Alternatively you can set `autoAuthenticate` to `true` in `ActiveGridAuthenticationOptions` in the `ActiveGridOptions`

### Flutter Web
If you want to use it with Flutter web you need to call and await `enableWebAuth` before runApp. This takes care of the redirect of the Authentication Server

```dart
void main() async {
  await enableWebAuth();
  runApp(ActiveGrid(child: MyApp()));
}
```

## Usage

Add `ActiveGridGridBuilder` to your widget tree. The `builder` behaves the same as `FutureBuilder`.

```dart
ActiveGridGridBuilder(
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

