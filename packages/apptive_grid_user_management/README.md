# ApptiveGrid UserManagement

[![Pub](https://img.shields.io/pub/v/apptive_grid_user_management.svg)](https://pub.dartlang.org/packages/apptive_grid_user_management)  [![pub points](https://badges.bar/apptive_grid_user_management/pub%20points)](https://pub.dev/packages/apptive_grid_user_management/score)  [![popularity](https://badges.bar/apptive_grid_user_management/popularity)](https://pub.dev/packages/apptive_grid_user_management/score)  [![likes](https://badges.bar/apptive_grid_user_management/likes)](https://pub.dev/packages/apptive_grid_user_management/score)

## Setup
Add a `ApptiveGridUserManagment` to your Widget tree. Ideally close to the `ApptiveGrid` Widget
```dart
ApptiveGrid(
    child: ApptiveGridUserManagement(
    group: 'YOUR_GROUP_ID',
    onChangeEnvironment: (newEnvironment) async {},
    confirmAccountPrompt: (confirmationWidget) {
      // Show confirmationWidget
    },
    onAccountConfirmed: (loggedIn) {
      // Handle account confirmed
    },
    child: MyApp(),,
    ),
)
```

### Android
Add the following entries to your `AndroidManifest` to be able to open confirmation links

```xml
<activity>
  ...
<intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>

        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>

        <data
                android:host="alpha.apptivegrid.de"
                android:pathPattern="/auth/regio4all/confirm/.*"
                android:scheme="YOUR_SCHEME"/>
        <data
                android:host="beta.apptivegrid.de"
                android:pathPattern="/auth/regio4all/confirm/.*"
                android:scheme="YOUR_SCHEME"/>
        <data
                android:host="app.apptivegrid.de"
                android:pathPattern="/auth/regio4all/confirm/.*"
                android:scheme="YOUR_SCHEME"/>
      </intent-filter>
</activity>
```

##iOS
Do the following to open confirmation Links

1. Using Universal Links (https as scheme) `Runner.entitlements`
    ```entitlements
   <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:*.apptivegrid.de</string>
    </array>
    ```
2. Using custom schema in `Info.plist`
    ```plist
   <key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>YOUR_SCHEMA</string>
			</array>
		</dict>
	</array>
    ```

## Show Login/Registration Content
On your Screens add a `ApptiveGridUserManagementContent` Widget to your layout. That's all. The themeing will be taken from your App's theme
```dart
Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ApptiveGridUserManagementContent(
        initialContentType: ContentType.login,
        onLogin: () {
          context.go('/home');
        },
      ),
)
```