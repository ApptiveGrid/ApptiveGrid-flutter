## [0.4.1]
* Make [FormData.name] optional
* Fix Multiline TextFields

## [0.4.0]
* **BREAKING CHANGE** `FormData` and `Grid` now take named constructor arguments to avoid confusion. Before the order of arguments did not have `schema` at the same part
* Add `name` to `FormData`

## [0.3.1]
* Add support for Authenticating with an API Key

## [0.3.0+1]
* Fix Overflow behavior for Selected Single Select, Selected CrossReference, Grid Cells in CrossReference Previews

## [0.3.0]
* AUTHENTICATION CHANGES
    * In order to fully support Google OAuth you need to add a custom redirect Scheme to ApptiveGridAuthenticationOptions. Also make sure your App can be opened via a deeplink with that scheme

## [0.2.7+1]
* Show `null` values as empty cells in CrossReferenceFormWidget

## [0.2.7]
* Support CrossReferences in Forms. This still requires Authentication however it is already a first look at how this will look and work

## [0.2.6]
* Update apptive_grid_core to support cached Action
* Expose ApptiveGridFormData Widget to allow building Forms with custom DataSet

## [0.2.5]
* Fix Parsing of Enum Entries

## [0.2.3]
* Fix Refresh Authentication

## [0.2.1+2]
* Make CheckboxFormWidget have no background

## [0.2.1+1]
* Display up to 100 Lines of Field Description
* Fix Overflow in CheckBoxFormWidget
* Fix Display Problems when using Filled InputDecorations for DateTime Components

## [0.2.1]
* Updated ApptiveGridCore to 0.2.1 to use new FormUris

## [0.2.0]
* It's ApptiveGrid now
* Load Forms using FormUri
* Supports accessing Forms with a direct Uri representation

## [0.1.0]
* Initial Release
