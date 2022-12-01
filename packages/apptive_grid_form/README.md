# ApptiveGrid Form

[![Pub](https://img.shields.io/pub/v/apptive_grid_form.svg)](https://pub.dartlang.org/packages/apptive_grid_form)  [![pub points](https://img.shields.io/pub/points/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)  [![popularity](https://img.shields.io/pub/popularity/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)  [![likes](https://img.shields.io/pub/likes/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)

A Flutter Package to display ApptiveGrid Forms inside a Flutter App

## Setup

In order to use any ApptiveGrid Feature you must wrap your App with a `ApptiveGrid` Widget

```dart
import 'package:apptive_grid_core/apptive_grid_core.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
      ),
      child: MyApp(),
    ),
  );
}
```

### Additional Configurations

There are some steps necessary because `apptive_grid_form` uses packages and plugins to provide certain functionality.

#### iOS Entitlements
Add the following entries to your app's `ios/Runner/Info.plist` if not there yet. Used for Attachments and Geolocation Form entries.

**Note that the Entries starting with *NS* are mandatory for releasing even if you are not using Attachments/Geolocations in your forms**
```plist
<key>UIBackgroundModes</key>
<array>
   <string>fetch</string>
   <string>remote-notification</string>
</array>
<key>UISupportsDocumentBrowser</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Get your current location in Geolocation Forms</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used for picking images from gallery in Attachments in Forms</string>
<key>NSCameraUsageDescription</key>
<string>Used for taking pictures with the camera in Attachments in Forms</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used for recording videos in Attachments in Forms</string>
```

You need to add [macros](https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler/ios/Classes/PermissionHandlerEnums.h) to your podfile to make sure Apple accepts your app submission.
Follow the guide in Setup/iOS and make sure you remove the `#` character for the following permissions
- `PERMISSION_CAMERA=1`
- `'PERMISSION_PHOTOS=1'`
- `'PERMISSION_LOCATION=1'`

#### Android Permissions
If you are using Geolocation in Forms add the following permissions to your `AndroidManifest`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

If you are using Attachments in Forms add the following permission to your `AndroidManifest`
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

#### Google Maps and Places Api Key
If you are using Geolocation in Forms you need to add a Google Maps Key to your Android and iOS App

`ios/Runner/App`
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```


`AndroidManifest`
```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

For more information and a guide to create a key check the documentation of [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

In order to provide the ability so search for locations by names and reverse geocode locations on a map to an address you need to add a Google Places Api Key.
Add it to your base `ApptiveGrid` Widget like this:

```dart
ApptiveGrid(
    formWidgetConfigurations: [
      const GeolocationFormWidgetConfiguration(
        placesApiKey: 'YOUR_PLACES_API_KEY',
      ),
    ],
    child: MyApp(),
)
```

Make sure the Api Key has the permission for Places API (Search by Name) and/or Geocoding API (Reverse Geocoding)

For more information and a guide to create a key check the documentation of [google_maps_webservice](https://pub.dev/packages/google_maps_webservice)

## Showing a Form

In order to display an ApptiveGrid Form in your App use the `ApptiveGridForm` Widget

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ApptiveGridForm(
        uri: Uri.parse('YOUR_FORM_URI'),
      ),
    );
  }
```

This works with empty forms and with pre-filled Forms.

## Customization

The Form will adjust to the App Theme to blend into the rest of the App. You can adjust the Title Style and the Padding by providing more arguments to `ApptiveGridForm`.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: ApptiveGridForm(
      formUri: FormUri.fromUri('YOUR_FORM_URI'),
      titleStyle: Theme.of(context).textTheme.headline6,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      titlePadding: const EdgeInsets.all(16),
    ),
  );
}
```