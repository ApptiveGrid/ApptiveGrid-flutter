## [0.8.0]

### Breaking Changes
* `DataType.selectionBox` is now `DataType.singleSelect`

### New Data Types
* `DataType.attachment`
* `DataType.enumCollection`
* `Data.multiCrossReference`

### New Features
* Added support for sorting when loading a Grid

## [0.8.0-alpha.6]
* Add support for `DataType.multiCrossReference`

## [0.8.0-alpha.5]
* Add Sorting to loading a Grid

## [0.8.0-alpha.4]
* Add support for `DataType.geolocation`
* Make `ApptiveGrid.withClient` public
* Add support for unauthenticated attachment uploading


## [0.8.0-alpha.3]
* **BREAKING CHANGE** `DataType.selectionBox` is now `DataType.singleSelect`
* Add support for `DataType.enumCollection`

## [0.8.0-alpha.2]
* Include Fixes from [0.7.1]

## [0.8.0-alpha.1]
* Preview support for attachments

## [0.7.1]
* Fix Timezone Issues with `DateTimeDataEntities`
* Fix parsing error if receiving a non float decimal value from the backend

## [0.7.0+1]
* Refresh saved token after restoring also handling errors that might occur during that process

## [0.7.0]
* **BREAKING CHANGE** Requires minSdkVersion for Android to be at least 18

## [0.6.0+1]
* Check equality of `schema` of `Grid` and `FormData` based on`toString()` representation reach a clearer equality

## [0.6.0]
* Upgrade to [Provider](https://pub.dev/packages/provider) 6.0.1

## [0.5.0]
* **BREAKING CHANGE** Supporting new Format for RedirectFormUris. `RedirectFormUris` now take a list of `component`
* Remove deprecated constructors `FormUri.redirectUri` and `FormUri.directUri`

## [0.4.3]
* Update Lints

## [0.4.2]
* Adding support for Decimal Data

## [0.4.1]
* Make [FormData.name] optional

## [0.4.0]
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## [0.3.2]
* Add support to get a EditLink for a EntityUri and a given formId
* Add call in ApptiveGridClient to update Environment

## [0.3.1]
* Add support for Authenticating with an API Key

## [0.3.0]
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## [0.2.7]
* Support CrossReferences in Forms. This still requires Authentication however it is already a first look at how this will look and work
* Call ApptiveGridClient.logout() to log out the user

## [0.2.6+2]
* Send empty/null values when submitting a Form. Enables sending non-selected enum values

## [0.2.6+1]
* Catch more Errors to cache a FormAction

## [0.2.6]
* Add Option to cache Actions with ApptiveGridCache

## [0.2.5]
* Fix Parsing of Enum Entries

## [0.2.4]
* Add support for `CrossReference` Data Type

## [0.2.3]
* Fix Refresh Authentication

## [0.2.2]
* Add support for GridViews

## [0.2.1]
* FormUri Changes
    * Please use `DirectFormUri` and `RedirectFormUri` now
    * Add ability to get a Filled Form with `DirectFormUri.forEntity`

## [0.2.0]
* It's ApptiveGrid now
* Use SpaceUri, GridUri and FormUri to access data via the api
* Use ApptiveGrid Backend
* Add Support for new calls
    * "me" User
    * available spaces
    * available grids
    * available forms

## [0.1.1+2]
* Fix closeWebView invocation on Web

## [0.1.1+1]
* Cleanup
* Add Authentication Documentation to README

## [0.1.1]
* Fix Web Authentication

## [0.1.0]
* Initial Release
