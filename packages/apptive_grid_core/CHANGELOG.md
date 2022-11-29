## 0.14.0
**BREAKING CHANGE**
- Restructure `ApptiveGridAuthenticator` to handle changes in options correctly by using a specific `ApptiveGridClient` inside the authenticator

## 0.13.4+1
* Fix race condition when refreshing the access token

## 0.13.4
* Added `DataType.email`, `DataType.phoneNumber` and `DataType.signature`

## 0.13.3
* Fixed invalid cached credentials
 
## 0.13.2
* Fixed login via webview in the core package

## 0.13.1
* Parse multiline text to single line for single line form fields
* Add a new `FormDataProperties` object to forms with these properties
  * successTitle
  * successMessage
  * buttonTitle
  * reloadAfterSubmit

## 0.13.0
* Remove Deprecated Members
* Adjust File Structure

## 0.12.2
* Add `hiddenFields` to `Grid`
* Deprecate `ApptiveLinkType.rename` in favor of `ApptiveLinkType.patch`
* Adjust Format for equals Filter
* Introduce `ActorFilter` to use with `DataType.createdBy`

## 0.12.1
* Make `defaultHeaders` in ApptiveGridClient public outside of tests
* Give access to `authenticator` in ApptiveGridClient

## 0.12.0
* Update Attachment Processing
* Add option to add an attachment with a path to a file instead of only the raw bytes
### Breaking Changes
* Resizing of images was changed to the following
  * Requires an id for the operation
  * Takes in a list of sizes it should resize to instead of doing each resize separately
  * Returns a List of paths to the Files where the resized Images are stored

## 0.11.3
* Add `submitFormWithProgress` to client to submit a Form and receive Progress Event Updates

## 0.11.2
* Add `DataType.currency` and `DataType.uri`
* Sanitize Form Links to load correct format even if providing a redirect uri

## 0.11.1+1
* Fix parsing of GridField with `createdBy`. Convert deprecated `userReference` type into a static variable pointing to the correct `createdBy` type

## 0.11.1
* Resize Images in Isolate when uploading Attachments

## 0.11.0
* Add `fields` to `FormData`
* Add `field` to `FormComponent`
* Rename `UserReference` to `CreatedBy`. The old `UserReference` is still available but deprecated
* Add new `ApptiveLinkTypes`: `collaborators`, `patch`
* Add `DataType.user` to handle Use cases like assigning a User to a Task
  * Additional models are: `DataUser` and `UserDataEntity`
* Fix Google Login on Android
### Breaking Changes
* Removed `schema` from `FormData`
* Removed dedicated `FormComponent` Types in favor of a generic `FormComponent<T extends DataEntity>` type
* Unified `FormComponentOptions`

## 0.10.1
* Added `copy` link to `ApptiveLink`s

## 0.10.0
* Add HAL `ApptiveLink`s to User, Space, Grid, Form, GridRow
* Add embedded Objects to User, Space, Grid
* Deprecate `FormActions`
* Adjust GridField to include `key` and `schema`
* Add `description` to forms
* Added custom header to calls
* Added support for all `ApptiveGridLayout` layouts
* Add parameter `loadEntities` to `loadGrid` to enable not loading entities for the Grid to only get the GridFields and Grid Meta Data
* Add `key` to Grid
* Add `key` and `category` to Space
* Deprecate `ApptiveLink`(`GridUri`, `FormUri`, `EntityUri`, etc) in favor of plain `Uri`
* Add new Filter Options
    * `IsEmptyFilter`
    * `Today()` for filtering `DataType.date`
    * `LoggedInUser()` for filtering createdBy and in the future assignee
### Breaking Changes
* `rows` and `fields` of `Grid` are now `nullable`
* Added required parameter `id` to Grid
* Added required parameter `id' to FormData
* `title`, `actions` and `components` of `FormData` are now `nullable`
* id, entities and links are now required named arguments in GridRow
* Removed `spaces` from `User` and `grids` from `Space`
* Remove `actions` from forms
* GridField now uses named arguments
* Removed `schema` from `Grid`
* Removed deprecated `ApptiveGridAuthenticator.withAuthenticationStorage`
* `layout` in `loadEntities` is now `ApptiveGridLayout` instead of `String?`

## 0.10.0-alpha.6
* Deprecate all `ApptiveLink` in favor of plain `Uri`
* Upgraded to dart 2.17
* Add new Filter Options
  * `IsEmptyFilter`
  * `Today()` for filtering `DataType.date`
  * `LoggedInUser()` for filtering createdBy and in the future assignee

## 0.10.0-alpha.5
* Add `description` to forms
* Fixed parsing for `key`s in GridField
* Fixed unauthorized retry for performing an ApptiveLink
* Added custom header to calls where it was missing
* Upgraded to `flutter_lints 2`
* Added support for all `ApptiveGridLayout` layouts
* Add parameter `loadEntities` to `loadGrid` to enable not loading entities for the Grid to only get the GridFields and Grid Meta Data
* Add `key` to Grid
* Add `key` and `category` to Space
### Breaking Change
* `layout` in `loadEntities` is now `ApptiveGridLayout` instead of `String?`

## 0.10.0-alpha.4
* Adjust GridField to include `key` and `schema`

### Breaking Changes
* GridField now uses named arguments
* Removed `schema` from `Grid`
* Removed deprecated `ApptiveGridAuthenticator.withAuthenticationStorage`

## 0.10.0-alpha.3
* Add `virtualGrids` ApptiveLinkType
* Deprecate `FormActions`
### Breaking Changes
* Remove `actions` from forms

## 0.10.0-alpha.2
* Add HAL Links to GridRow
### Breaking Changes
* id, entities and links are now required named arguments in GridRow
* Removed `spaceUris` from `User` and `gridUris` from `Space`

## 0.10.0-alpha.1 - Model Rework
* Add HAL `ApptiveLink`s to User, Space, Grid and Form
* Add call to perform an HAL `ApptiveLink`
* Add embedded Objects to User, Space, Grid
### Breaking Changes
* Rename `spaces` in `User` to `spaceUris`
* Rename `grids` in `Space` to `gridUris`
* `rows` and `fields` of `Grid` are now `nullable`
* Added required parameter `id` to Grid
* Added required parameter `id' to FormData
* `title`, `actions` and `components` of `FormData` are now `nullable`

## 0.9.4
* Fix Bug where not having a saved token would ask for User Authentication directly

## 0.9.3
### Rework Attachments
  * Deprecated old call to generate an upload url
  * Uploading Thumbnails for Images
  * Scaling down images to have a maximum side of 1000px

## 0.9.2
* Add call to upload Profile Picture
* Hide `ContentType` in export of Network Package

## 0.9.1+1
* Fix entities not checking for authentication
* Store new Token after refreshing
* Only check for authentication when loading grids if initial loading returned 401
* Adjust required values for CrossReferenceDataEntities (Display Value is not necessary)

## 0.9.1
* Add call to load entities directly

## 0.9.0

### Breaking Changes
* `isAuthenticated` now returns `Future<bool>`

## New Features
* Add support for setting UserToken manually
* Add function for checking if a user is authenticated with a User Token

## 0.8.0

### Breaking Changes
* `DataType.selectionBox` is now `DataType.singleSelect`

### New Data Types
* `DataType.attachment`
* `DataType.enumCollection`
* `DataType.multiCrossReference`
* `DataType.createdBy`

### New Features
* Added support for sorting when loading a Grid
* Added support for filtering when loading a Grid
* Add call retrieve a single entity
* Rework structure of Uris to be more generic

## 0.8.0-alpha.9
* Add Support for `DataType.createdBy`
* Add call to retrieve a single entity

## 0.8.0-alpha.8
* Fix Collection Filter Operators

## 0.8.0-alpha.7
* Add support for `ApptiveGridFilter`

## 0.8.0-alpha.6
* Add support for `DataType.multiCrossReference`

## 0.8.0-alpha.5
* Add Sorting to loading a Grid

## 0.8.0-alpha.4
* Add support for `DataType.geolocation`
* Make `ApptiveGrid.withClient` public
* Add support for unauthenticated attachment uploading


## 0.8.0-alpha.3
* **BREAKING CHANGE** `DataType.selectionBox` is now `DataType.singleSelect`
* Add support for `DataType.enumCollection`

## 0.8.0-alpha.2
* Include Fixes from [0.7.1]

## 0.8.0-alpha.1
* Preview support for attachments

## 0.7.1
* Fix Timezone Issues with `DateTimeDataEntities`
* Fix parsing error if receiving a non float decimal value from the backend

## 0.7.0+1
* Refresh saved token after restoring also handling errors that might occur during that process

## 0.7.0
* **BREAKING CHANGE** Requires minSdkVersion for Android to be at least 18

## 0.6.0+1
* Check equality of `schema` of `Grid` and `FormData` based on`toString()` representation reach a clearer equality

## 0.6.0
* Upgrade to [Provider](https://pub.dev/packages/provider) 6.0.1

## 0.5.0
* **BREAKING CHANGE** Supporting new Format for RedirectFormUris. `RedirectFormUris` now take a list of `component`
* Remove deprecated constructors `FormUri.redirectUri` and `FormUri.directUri`

## 0.4.3
* Update Lints

## 0.4.2
* Adding support for Decimal Data

## 0.4.1
* Make [FormData.name] optional

## 0.4.0
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## 0.3.2
* Add support to get a EditLink for a EntityUri and a given formId
* Add call in ApptiveGridClient to update Environment

## 0.3.1
* Add support for Authenticating with an API Key

## 0.3.0
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## 0.2.7
* Support CrossReferences in Forms. This still requires Authentication however it is already a first look at how this will look and work
* Call ApptiveGridClient.logout() to log out the user

## 0.2.6+2
* Send empty/null values when submitting a Form. Enables sending non-selected enum values

## 0.2.6+1
* Catch more Errors to cache a FormAction

## 0.2.6
* Add Option to cache Actions with ApptiveGridCache

## 0.2.5
* Fix Parsing of Enum Entries

## 0.2.4
* Add support for `CrossReference` Data Type

## 0.2.3
* Fix Refresh Authentication

## 0.2.2
* Add support for GridViews

## 0.2.1
* FormUri Changes
    * Please use `DirectFormUri` and `RedirectFormUri` now
    * Add ability to get a Filled Form with `DirectFormUri.forEntity`

## 0.2.0
* It's ApptiveGrid now
* Use SpaceUri, GridUri and FormUri to access data via the api
* Use ApptiveGrid Backend
* Add Support for new calls
    * "me" User
    * available spaces
    * available grids
    * available forms

## 0.1.1+2
* Fix closeWebView invocation on Web

## 0.1.1+1
* Cleanup
* Add Authentication Documentation to README

## 0.1.1
* Fix Web Authentication

## 0.1.0
* Initial Release
