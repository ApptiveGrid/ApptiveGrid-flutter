## [0.8.0-alpha.4]
* Add support for `ApptiveGridFilter` through `filter` argument

## [0.8.0-alpha.3]
* Add `sorting` parameter to ApptiveGridGridBuilder

## [0.8.0-alpha.2]
* Adds support for MultiEnum and Geolocation Types

## [0.8.0-alpha.1]
* Preview support for attachments

## [0.7.0]
* **BREAKING CHANGE** Requires minSdkVersion for Android to be at least 18

## [0.6.0]
* Upgrade to [Provider](https://pub.dev/packages/provider) 6.0.1

## [0.5.0]
* **BREAKING CHANGE** Supporting new Format for RedirectFormUris. `RedirectFormUris` now take a list of `component`
* Remove deprecated constructors `FormUri.redirectUri` and `FormUri.directUri`

## [0.4.3]
* Update Lints

## [0.4.1]
* Make [FormData.name] optional

## [0.4.0]
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## [0.3.1]
* Add support for Authenticating with an API Key

## [0.3.0]
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## [0.2.6]
* Update apptive_grid_core

## [0.2.5]
* Fix Parsing of Enum Entries

## [0.2.4]
* Update apptive_grid_core to add support for CrossReference

## [0.2.3]
* Fix Refresh Authentication

## [0.2.2]
* Add support for GridViews

## [0.2.1]
* Updated ApptiveGridCore to 0.2.1

## [0.2.0]
* It's ApptiveGrid now
* Load Grids with GridUri

## [0.1.1]
* Update Core Library for proper Web Support

## [0.1.0]
* Initial Release
