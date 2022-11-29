# ApptiveGrid GridBuilder

[![Pub](https://img.shields.io/pub/v/apptive_grid_grid_builder.svg)](https://pub.dartlang.org/packages/apptive_grid_grid_builder)  [![pub points](https://img.shields.io/pub/points/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)  [![popularity](https://img.shields.io/pub/popularity/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)  [![likes](https://img.shields.io/pub/likes/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)

A Flutter Package to build Widgets based on Grid Data

## Usage

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
      child: MyApp(
        child: ApptiveGridGridBuilder(
          uri: Uri.parse('LINK_TO_GRID'),
          builder: (context, snapshot) {
            // Build your app based on snapshot.data
          }
        ),
      ),
    ),
  );
}
```

## Authentication

Grids need Authentication. In order to authenticate a user either manually call `ApptiveGrid.getClient(context).authenticate()`.
In order to authenticate a user either manually call `ApptiveGrid.getClient(context).authenticate()`.
Alternatively you can set `autoAuthenticate` to `true` in `ApptiveGridAuthenticationOptions` in the `ApptiveGridOptions` this will automatically trigger the process.
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
  child: MyApp(),
));
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

### API Key Auth
If you want to authenticate with an API Key, add a `ApptiveGridApiKey` to the `ApptiveGridAuthenticationOptions`
```dart
ApptiveGridOptions(
  environment: ApptiveGridEnvironment.alpha,
  authenticationOptions: ApptiveGridAuthenticationOptions(
    autoAuthenticate: true,
    apiKey: ApptiveGridApiKey(
      authKey: 'YOUR_AUTH_KEY',
      password: 'YOUR_AUTH_KEY_PASSWORD',
    ),
  )
)
```

