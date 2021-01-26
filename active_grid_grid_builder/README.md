# ActiveGrid GridBuilder

A Flutter Package to build Widgets based on Grid Data

## Setup

In order to use any ActiveGrid Feature you must wrap your App with a `ActiveGrid` Widget

As Grids require authentication you need to add `ActiveGridAuthentication` to `ActiveGridOptions`

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ActiveGrid(
      options: ActiveGridOptions(
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

## Usage

Add `ActiveGridGridBuilder` to your widget tree. The `builder` behaves the same as `FutureBuilder`.

```dart
ActiveGridGridBuilder(
    user: 'USER_ID',
    space: 'SPACE_ID',
    grid: 'GRID_ID',
    builder: (context, snapshot) {
        return YourWidget(gridData: snapshot.data);
    }
);
```

