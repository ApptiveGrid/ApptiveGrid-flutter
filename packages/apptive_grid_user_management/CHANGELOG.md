## 2.0.3

 - Update for flutter 3.22.3 (intl 19)

## 2.0.2

 - Update a dependency to the latest release.

## 2.0.1

 - Update a dependency to the latest release.

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Upgrade to dart 3 (#123).

## 1.4.5

 - Update a dependency to the latest release.

## 1.4.4

 - Update a dependency to the latest release.

## 1.4.3

 - Update a dependency to the latest release.

## 1.4.2

 - Update a dependency to the latest release.

## 1.4.1

 - Update a dependency to the latest release.

## 1.4.0

 - **FEAT**: Upgrade Dependencies for Flutter 3.10 (#108).

## 1.3.1

 - **FIX**: Handle Confirming already confirmed registration (#106).

## 1.3.0

 - **FEAT**: Add keyboard actions to user component (#103).

## 1.1.2

 - Update a dependency to the latest release.

## 1.1.1

 - Update a dependency to the latest release.

## 1.1.0

 - **FEAT**: Add support for custom additional answer button label through web app.

## 1.0.0

 - Version 1.0.0

## 0.4.0
* Update apptive_grid_core to 0.15.0

## 0.3.1
* Upgrade apptive_grid_core to 0.14.4
* Fix Lints for Flutter 3.7.0

## 0.3.0
* Upgrade apptive_grid_core to 0.14.0
* Update dependencies

## 0.2.1
* Improve autofill for login and registration

## 0.2.0
* Remove deprecated members

## 0.1.1
* Add option to delete a user's account

## 0.1.0
* Promote to 0.1.0 release
* Update apptive_grid_core to [0.12.0](https://pub.dev/packages/apptive_grid_core/changelog#0120)

## 0.0.6
* Adjust handling of different scenarios
  * Login with valid credentials but user not part of the group: Ask to join group
  * Register with valid credentials and user is already part of the group: Login User
  * Register with email that is already registered: Hint that mail with confirmation link has been sent

## 0.0.5
* Update apptive_grid_core Package to include breaking [Model Changes from Version 0.10.0](https://pub.dev/packages/apptive_grid_core/changelog#0100)
* Add support for custom translations
### Breaking Change
* Model changes from apptive_grid_core see [here](https://pub.dev/packages/apptive_grid_core/changelog#0100) for more details
* Remove `ApptiveGridUserManagement.withClient` in favor of a named argument in the default constructor

## 0.0.5-alpha.4
* Upgraded to dart 2.17

## 0.0.5-alpha.3
* Add support for custom translations

## 0.0.5-alpha.2
* Upgraded to `flutter_lints 2`
### Breaking Change
* Remove `ApptiveGridUserManagement.withClient` in favor of a named argument in the default constructor

## 0.0.5-alpha.1
* Update apptive_grid_core to 0.10.0 to include breaking model changes

## 0.0.4+1
* Add Group to Login call url

## 0.0.4
* Allow customization of Password Rule enforcement through `PasswordRequirement`

## 0.0.3
* Add functionality to reset passwords
* **BREAKING** Rename `redirectSchema` to `redirectScheme`
* Add AutofillHints to input fields

## 0.0.2
* Add Example
* Disallow spaces in email fields

## 0.0.1

### Initial Release
Support for Login, Registration and Account Confirmation using ApptiveGrid
