## [0.3.1]
* Add support for Authenticating with an API Key

## [0.3.0]
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## [0.2.7]
* Support CrossReferences in Forms. This still requires Authentication however it is already a first look at how this will look and work
* Call ApptiveGridClient.logout() to logout the user

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
