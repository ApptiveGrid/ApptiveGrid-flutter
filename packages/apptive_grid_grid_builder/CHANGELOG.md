## 2.0.2

 - Update a dependency to the latest release.

## 2.0.1

 - Update a dependency to the latest release.

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Upgrade to dart 3 (#123).

## 1.2.5

 - Update a dependency to the latest release.

## 1.2.4

 - Update a dependency to the latest release.

## 1.2.3

 - Update a dependency to the latest release.

## 1.2.2

 - Update a dependency to the latest release.

## 1.2.1

 - Update a dependency to the latest release.

## 1.2.0

 - **FEAT**: Upgrade Dependencies for Flutter 3.10 (#108).

## 1.1.2

 - Update a dependency to the latest release.

## 1.1.1

 - Update a dependency to the latest release.

## 1.1.0

 - **FEAT**: Add support for custom additional answer button label through web app.

## 1.0.0

 - Version 1.0.0

## 0.15.0
* Update apptive_grid_core to 0.15.0

## 0.13.1+1
* Use `const` where possible

## 0.13.1
* Upgrade apptive_grid_core to 0.14.2

## 0.13.0
* Upgrade apptive_grid_core to 0.14.0
* Update dependencies

# 0.12.0
* Remove deprecated members
* Adjust file structure

## 0.11.0
* Update apptive_grid_core to [0.12.0](https://pub.dev/packages/apptive_grid_core/changelog#0120)

## 0.10.0
* Renamed `UserReference` to `CreatedBy`. The old `UserReference` is still available but deprecated

## 0.9.0
* Update apptive_grid_core Package to include breaking [Model Changes from Version 0.10.0](https://pub.dev/packages/apptive_grid_core/changelog#0100)
* GridField now includes `key` and `schema`
* Deprecate `ApptiveLink`(`GridUri`, `FormUri`, `EntityUri`, etc) in favor of plain `Uri`
### Breaking Change
* Model changes from apptive_grid_core see [here](https://pub.dev/packages/apptive_grid_core/changelog#0100) for more details
* Removed `spaceUris` from `User` and `gridUris` from `Space`

## 0.9.0-alpha.5
* Deprecate all `ApptiveLink` in favor of plain `Uri`
* Upgraded to dart 2.17

## 0.9.0-alpha.4
* Upgraded to `flutter_lints 2`

## 0.9.0-alpha.3
* Update Core Package to 0.10.0-alpha.4
* Adjust GridField to include `key` and `schema`

### Breaking Changes
* GridField now uses named arguments
* Removed `schema` from `Grid`

## 0.9.0-alpha.2
* Update Core Package to 0.10.0-alpha.2 to include breaking changes to GridRow
### Breaking Change
* Removed `spaceUris` from `User` and `gridUris` from `Space`

## 0.9.0-alpha.1
* Update Core package
* Includes a lot of breaking changes in the model including in `Grid`

## 0.8.1+1
* Reload builder when uri changed

## 0.8.1
* Use `apptive_grid_core: ^0.9.0`

## 0.8.0

### Breaking Changes
* `DataType.selectionBox` is now `DataType.singleSelect`

### New Data Types
* `DataType.attachment`
* `DataType.enumCollection`
* `DataType.multiCrossReference`
* 'DataType.createdBy'

### New Features
* Added support for sorting when loading a Grid
* Added support for filtering when loading a Grid
* Rework structure of Uris to be more generic

## 0.8.0-alpha.4
* Add support for `ApptiveGridFilter` through `filter` argument

## 0.8.0-alpha.3
* Add `sorting` parameter to ApptiveGridGridBuilder

## 0.8.0-alpha.2
* Adds support for MultiEnum and Geolocation Types

## 0.8.0-alpha.1
* Preview support for attachments

## 0.7.0
* **BREAKING CHANGE** Requires minSdkVersion for Android to be at least 18

## 0.6.0
* Upgrade to [Provider](https://pub.dev/packages/provider) 6.0.1

## 0.5.0
* **BREAKING CHANGE** Supporting new Format for RedirectFormUris. `RedirectFormUris` now take a list of `component`
* Remove deprecated constructors `FormUri.redirectUri` and `FormUri.directUri`

## 0.4.3
* Update Lints

## 0.4.1
* Make [FormData.name] optional

## 0.4.0
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## 0.3.1
* Add support for Authenticating with an API Key

## 0.3.0
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## 0.2.6
* Update apptive_grid_core

## 0.2.5
* Fix Parsing of Enum Entries

## 0.2.4
* Update apptive_grid_core to add support for CrossReference

## 0.2.3
* Fix Refresh Authentication

## 0.2.2
* Add support for GridViews

## 0.2.1
* Updated ApptiveGridCore to 0.2.1

## 0.2.0
* It's ApptiveGrid now
* Load Grids with GridUri

## 0.1.1
* Update Core Library for proper Web Support

## 0.1.0
* Initial Releas