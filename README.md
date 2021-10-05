[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=plastic)](https://github.com/invertase/melos)
# Flutter ApptiveGrid #

A collection of Flutter Packages to integrate ApptiveGrid into Flutter Apps.

| Package | Description | Pub | Points | Popularity | Likes 
| ------- | ----------- | --- | ------ | ---------- | -----
| [apptive_grid_core](packages/apptive_grid_core) | Core Package for general functionalities. This includes all Network Calls, Authentication, Models, etc. | [![Pub](https://img.shields.io/pub/v/apptive_grid_core.svg)](https://pub.dartlang.org/packages/apptive_grid_core) | [![pub points](https://badges.bar/apptive_grid_core/pub%20points)](https://pub.dev/packages/apptive_grid_core/score) | [![popularity](https://badges.bar/apptive_grid_core/popularity)](https://pub.dev/packages/apptive_grid_core/score) | [![likes](https://badges.bar/apptive_grid_core/likes)](https://pub.dev/packages/apptive_grid_core/score)
| [apptive_grid_form](packages/apptive_grid_form) | Display ApptiveGrid Forms in an app and send data | [![Pub](https://img.shields.io/pub/v/apptive_grid_form.svg)](https://pub.dartlang.org/packages/apptive_grid_form) | [![pub points](https://badges.bar/apptive_grid_form/pub%20points)](https://pub.dev/packages/apptive_grid_form/score) | [![popularity](https://badges.bar/apptive_grid_form/popularity)](https://pub.dev/packages/apptive_grid_form/score) | [![likes](https://badges.bar/apptive_grid_form/likes)](https://pub.dev/packages/apptive_grid_form/score)
| [apptive_grid_grid_builder](packages/apptive_grid_grid_builder) | Build custom Widgets with Grids as the Data source | [![Pub](https://img.shields.io/pub/v/apptive_grid_grid_builder.svg)](https://pub.dartlang.org/packages/apptive_grid_grid_builder) | [![pub points](https://badges.bar/apptive_grid_grid_builder/pub%20points)](https://pub.dev/packages/apptive_grid_grid_builder/score) | [![popularity](https://badges.bar/apptive_grid_grid_builder/popularity)](https://pub.dev/packages/apptive_grid_grid_builder/score) | [![likes](https://badges.bar/apptive_grid_grid_builder/likes)](https://pub.dev/packages/apptive_grid_grid_builder/score)
| [apptive_grid_web_apptive](packages/apptive_grid_web_apptive) | Wrap Apptives to show them on ApptiveGrid | [![Pub](https://img.shields.io/pub/v/apptive_grid_web_apptive.svg)](https://pub.dartlang.org/packages/apptive_grid_web_apptive) | [![pub points](https://badges.bar/apptive_grid_web_apptive/pub%20points)](https://pub.dev/packages/apptive_grid_web_apptive/score) | [![popularity](https://badges.bar/apptive_grid_web_apptive/popularity)](https://pub.dev/packages/apptive_grid_web_apptive/score) | [![likes](https://badges.bar/apptive_grid_web_apptive/likes)](https://pub.dev/packages/apptive_grid_web_apptive/score)

## Melos

This mono repo is maintained using [Melos](https://github.com/invertase/melos). 
### Install
```
dart pub global activate melos
```
### Usage
To link internal dependencies:
```
melos bootstrap
```
List available commands to be run with `melos run $command`
```
melos run --list
```
Please refer to the [Documentation of Melos](https://docs.page/invertase/melos) for more information and further installation instructions

## Adding a new Type

To add a new type the following steps need to be taken

### apptive_grid_core

- `DataType` in [data_type.dart](packages/apptive_grid_core/lib/model/data_type.dart) needs to be added and parsing implemented in `dataTypeFromSchemaProperty` in the same file
- [`DataEntity`](packages/apptive_grid_core/lib/model/data_entity.dart) representing the added `DataType` needs to be added
- Create a `FormComponent` in [the component Folder](packages/apptive_grid_core/lib/model/form/component)


### apptive_grid_form
- Add a `FormWidget` in [the form_widget Folder](packages/apptive_grid_form/lib/widgets/form_widget)
- Make sure that your newly created `FormWidget` is added in [fromModel](packages/apptive_grid_form/lib/widgets/form_widget/form_widget.dart)