## 0.12.3
* Thumbnails for Attachments
* Attachments are now using their path when being added

## 0.12.2
* Use new `submitFormWithProgress` and display the progress when submitting

## 0.12.1
* Add support for `DataType.currency` and `DataType.uri`

## 0.12.0
* Query backend when searching for CrossReferences
* Fix Bug where CrossReferences could only be selected if their type was String
* Improve Loading behaviour. Show Loading after validation and disable inputs while form is uploading
### Breaking Change
* Remove `Fields` from `HeaderRowWidget`
* Remove `FilterController` and `FilterListener`


## 0.11.0
* Updated to apptive_grid_core  to 0.11.0
* This includes breaking changes regarding the FormData Model. Most important there is now no dedicated FormComponent per type but one generic one
* Renamed UserReference to CreatedBy
* Add UserFormWidget for `DataType.user`

## 0.10.0
* Update apptive_grid_core Package to include breaking [Model Changes from Version 0.10.0](https://pub.dev/packages/apptive_grid_core/changelog#0100)
* Deprecate `FormActions`
* Add `scrollController`, `buttonAlignment` and `buttonLabel` to `ApptiveGridForm` and `ApptiveGridFormData`
* Add `description` to forms
* Remove dependency on google_maps_webservice for location search and reverse geocoding
* Deprecate `ApptiveLink`(`GridUri`, `FormUri`, `EntityUri`, etc) in favor of plain `Uri`
### Breaking Change
* Model changes from apptive_grid_core see [here]((https://pub.dev/packages/apptive_grid_core/changelog#0100)) for more details
* Removed `spaceUris` from `User` and `gridUris` from `Space`
* Remove `actions` from forms

## 0.10.0-alpha.6
* Deprecate all `ApptiveLink` in favor of plain `Uri`
* Upgraded to dart 2.17
* Remove dependency on google_maps_webservice in favor of a local copy to be able to release stable versions of this package

## 0.10.0-alpha.5
* Add `description` to forms
* Upgraded to `flutter_lints 2`

## 0.10.0-alpha.4
* Update Core Package to 0.10.0-alpha.4 to include breaking changes to GridField

## 0.10.0-alpha.3
* Deprecate `FormActions`
* Add `scrollController`, `buttonAlignment` and `buttonLabel` to `ApptiveGridForm` and `ApptiveGridFormData`
### Breaking Changes
* Remove `actions` from forms

## 0.10.0-alpha.2
* Update Core Package to 0.10.0-alpha.2 to include breaking changes to GridRow
### Breaking Change
* Removed `spaceUris` from `User` and `gridUris` from `Space`

## 0.10.0-alpha.1
* Update Core Package
* Includes a lot of breaking changes in the Models. Including in `FormData`

## 0.9.1
* Use new Attachment System
* Show Error Message in Form Error
* Don't clear data/reload form if the form was loaded

## 0.9.1-alpha.2
* Show Error Message in Form Error
* Don't clear data/reload form if the form was loaded

## 0.9.1-alpha.1
* Use new Attachment System

## 0.9.0

### Breaking Changes
* `DataType.selectionBox` is now `DataType.singleSelect`
* Due to new external dependencies there is some additional setup required. Please see the README for more details

### New Data Types
* `DataType.attachment`
* `DataType.enumCollection`
* `DataType.multiCrossReference`
* `DataType.createdBy`

### New Features
* Rework structure of Uris to be more generic

### Bugfixes
* Fixed Multiline Text FormWidgets
* Fix required validation not working for all types if Form has initial data
* Fix stretched submit Loading Indicator

## 0.9.0-alpha.12
* Add * to label of required fields
* Fix bug where required fields where not validated for long forms
* Reload ApptiveGridForm when FormUri changed

## 0.9.0-alpha.11
* Use `apptive_grid_core: ^0.9.0`
* Fix stretched submit Loading Indicator

## 0.9.0-alpha.10
* Use stable version of `apptive_grid_core`

## 0.9.0-alpha.9
* Add Support for `DataType.createdBy`
* Fix required validation not working for all types if Form has initial data

## 0.9.0-alpha.8
* Show Loading Indicator while submitting a Form

## 0.9.0-alpha.7
* Add proper support for `DataType.multiCrossReference` in Forms

## 0.9.0-alpha.6
* Add support for `DataType.multiCrossReference`
* The Form Widget only offers very basic support for now. It only supports selecting single Values from CrossReferenced Grids
* Adjust Attachment Form Widget to offer more options to select attachments from camera, gallery and files

## 0.9.0-alpha.5
* Fix Multiline Text FormWidgets
* Add Spacing for EnumCollection

## 0.9.0-alpha.4
* Add support for Geolocation Form Widgets

## 0.9.0-alpha.3
* **BREAKING CHANGE** `DataType.selectionBox` is now `DataType.singleSelect`
* Add support for `DataType.enumCollection`

## 0.9.0-alpha.2
* Fix Required Form Field not updating if required

## 0.9.0-alpha.1
* Preview support for attachments

## 0.8.0
* **BREAKING CHANGE** Requires minSdkVersion for Android to be at least 18

## 0.7.3+1
* Use Locale for DateTime Formats in `DateFormWidget` and `DateTimeFormWidget`

## 0.7.3
* Add missing translations
  * Hints for DateTimeFormWidget
* Adjust CheckboxForm Widget
  * Remove Error Border
  * Adjust alignment of checkbox and label

## 0.7.2
* Adding translations to Forms. Right now English and German are supported

## 0.7.1
* Adding a way to get `currentData` of a FormWidget

## 0.7.0
* **BREAKING CHANGE** Added `FormData` to `onActionSuccess` callback to receive the data that was successfully send

## 0.6.0
* Upgrade to [Provider](https://pub.dev/packages/provider) 6.0.1

## 0.5.0
* **BREAKING CHANGE** Supporting new Format for RedirectFormUris. `RedirectFormUris` now take a list of `component`

## 0.4.3
* Update Lints

## 0.4.2
* Adding support for Decimal Data

## 0.4.1
* Make [FormData.name] optional
* Fix Multiline TextFields

## 0.4.0
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## 0.3.1
* Add support for Authenticating with an API Key

## 0.3.0+1
* Fix Overflow behavior for Selected Single Select, Selected CrossReference, Grid Cells in CrossReference Previews

## 0.3.0
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## 0.2.7+1
* Show `null` values as empty cells in CrossReferenceFormWidget

## 0.2.7
* Support CrossReferences in Forms. This still requires Authentication however it is already a first look at how this will look and work

## 0.2.6
* Update apptive_grid_core to support cached Action
* Expose ApptiveGridFormData Widget to allow building Forms with custom DataSet

## 0.2.5
* Fix Parsing of Enum Entries

## 0.2.3
* Fix Refresh Authentication

## 0.2.1+2
* Make CheckboxFormWidget have no background

## 0.2.1+1
* Display up to 100 Lines of Field Description
* Fix Overflow in CheckBoxFormWidget
* Fix Display Problems when using Filled InputDecorations for DateTime Components

## 0.2.1
* Updated ApptiveGridCore to 0.2.1 to use new FormUris

## 0.2.0
* It's ApptiveGrid now
* Load Forms using FormUri
* Supports accessing Forms with a direct Uri representation

## 0.1.0
* Initial Release
