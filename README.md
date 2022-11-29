[![Build](https://github.com/ApptiveGrid/apptive_grid_flutter/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/ApptiveGrid/apptive_grid_flutter/actions/workflows/main.yml?query=branch%3Amain)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=plastic)](https://github.com/invertase/melos)
# Flutter Apptivegrid #

A collection of Flutter Packages to integrate Apptivegrid into Flutter Apps.

| Package                                                               | Description                                                                                             | Pub                                                                                                                                     | Points                                                                                                                                                 | Popularity                                                                                                                                                 | Likes                                                                                                                                            |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| [apptive_grid_core](packages/apptive_grid_core)                       | Core Package for general functionalities. This includes all Network Calls, Authentication, Models, etc. | [![Pub](https://img.shields.io/pub/v/apptive_grid_core.svg)](https://pub.dartlang.org/packages/apptive_grid_core)                       | [![pub points](https://img.shields.io/pub/points/apptive_grid_core?logo=dart)](https://pub.dev/packages/apptive_grid_core/score)                       | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_core?logo=dart)](https://pub.dev/packages/apptive_grid_core/score)                       | [![likes](https://img.shields.io/pub/likes/apptive_grid_core?logo=dart)](https://pub.dev/packages/apptive_grid_core/score)                       |
| [apptive_grid_form](packages/apptive_grid_form)                       | Display Apptivegrid Forms in an app and send data                                                       | [![Pub](https://img.shields.io/pub/v/apptive_grid_form.svg)](https://pub.dartlang.org/packages/apptive_grid_form)                       | [![pub points](https://img.shields.io/pub/points/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)                       | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)                       | [![likes](https://img.shields.io/pub/likes/apptive_grid_form?logo=dart)](https://pub.dev/packages/apptive_grid_form/score)                       |
| [apptive_grid_grid_builder](packages/apptive_grid_grid_builder)       | Build custom Widgets with Grids as the Data source                                                      | [![Pub](https://img.shields.io/pub/v/apptive_grid_grid_builder.svg)](https://pub.dartlang.org/packages/apptive_grid_grid_builder)       | [![pub points](https://img.shields.io/pub/points/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)       | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)       | [![likes](https://img.shields.io/pub/likes/apptive_grid_grid_builder?logo=dart)](https://pub.dev/packages/apptive_grid_grid_builder/score)       |
| [apptive_grid_web_apptive](packages/apptive_grid_web_apptive)         | Wrap Apptives to show them on ApptiveGrid                                                               | [![Pub](https://img.shields.io/pub/v/apptive_grid_web_apptive.svg)](https://pub.dartlang.org/packages/apptive_grid_web_apptive)         | [![pub points](https://img.shields.io/pub/points/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)         | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)         | [![likes](https://img.shields.io/pub/likes/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)         |
| [apptive_grid_theme](packages/apptive_grid_theme)                     | Theming for apps using ApptiveGrid. This includes colors, icons and fonts used by ApptiveGrid.          | [![Pub](https://img.shields.io/pub/v/apptive_grid_theme.svg)](https://pub.dartlang.org/packages/apptive_grid_theme)                     | [![pub points](https://img.shields.io/pub/points/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)                     | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)                     | [![likes](https://img.shields.io/pub/likes/apptive_grid_theme?logo=dart)](https://pub.dev/packages/apptive_grid_theme/score)                     |
| [apptive_grid_user_management](packages/apptive_grid_user_management) | Package for adding UserManagement through ApptiveGrid to Apps                                           | [![Pub](https://img.shields.io/pub/v/apptive_grid_user_management.svg)](https://pub.dartlang.org/packages/apptive_grid_user_management) | [![pub points](https://img.shields.io/pub/points/apptive_grid_user_management?logo=dart)](https://pub.dev/packages/apptive_grid_user_management/score) | [![popularity](https://img.shields.io/pub/popularity/apptive_grid_user_management?logo=dart)](https://pub.dev/packages/apptive_grid_user_management/score) | [![likes](https://img.shields.io/pub/likes/apptive_grid_user_management?logo=dart)](https://pub.dev/packages/apptive_grid_user_management/score) |

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
- [`DataEntity`](packages/apptive_grid_core/lib/src/model/data_entity.dart) representing the added `DataType` needs to be added


### apptive_grid_form
- Add a `FormWidget` in [the form_widget Folder](packages/apptive_grid_form/lib/src/widgets/form_widget)
- Make sure that your newly created `FormWidget` is added in [fromModel](packages/apptive_grid_form/lib/src/widgets/form_widget/form_widget.dart)