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
                android:pathPattern="/auth/YOUR_GROUP_ID/confirm/.*"
                android:scheme="YOUR_SCHEME"/>
        <data
                android:host="beta.apptivegrid.de"
                android:pathPattern="/auth/YOUR_GROUP_ID/confirm/.*"
                android:scheme="YOUR_SCHEME"/>
        <data
                android:host="app.apptivegrid.de"
                android:pathPattern="/auth/YOUR_GROUP_ID/confirm/.*"
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
      <string>applinks:alpha.apptivegrid.de</string>
      <string>applinks:beta.apptivegrid.de</string>
      <string>applinks:app.apptivegrid.de</string>
    </array>
    ```
2. Using custom schema in `Info.plist`
    ```plist
   <key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Viewer</string>
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

## Delete Account
To comply with the Apple Review Guidelines Apps that offer Account Creation also require to provide an option to delete the account. [More Information](https://developer.apple.com/support/offering-account-deletion-in-your-app)

This package provides widgets to show the delete account option.

```dart
// As a ListTile
DeleteAccount.listTile(
  onAccountDeleted: () {
      // Go to Login Screen, etc...
  },
),

// As a TextButton
DeleteAccount.textButton(
    onAccountDeleted: () {
      // Go to Login Screen, etc...
    },
),

// As a Custom Widget
// Note that gesture detectors on your custom widget will be ignored
DeleteAccount(
    onAccountDeleted: () {
      // Go to Login Screen, etc...
    },
    child: CustomWidget(),
),
```

Clicking on one of these Widgets will show users a dialog where they can confirm that they want to delete their account.