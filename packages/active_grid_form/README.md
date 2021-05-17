# ApptiveGrid Form

[![Pub](https://img.shields.io/pub/v/active_grid_form.svg)](https://pub.dartlang.org/packages/active_grid_form)  [![pub points](https://badges.bar/active_grid_form/pub%20points)](https://pub.dev/packages/active_grid_form/score)  [![popularity](https://badges.bar/active_grid_form/popularity)](https://pub.dev/packages/active_grid_form/score)  [![likes](https://badges.bar/active_grid_form/likes)](https://pub.dev/packages/active_grid_form/score)

A Flutter Package to display ApptiveGrid Forms inside a Flutter App

## Setup

In order to use any ApptiveGrid Feature you must wrap your App with a `ApptiveGrid` Widget

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
      ),
      child: MyApp(),
    ),
  );
}
```

## Showing a Form

In order to display an ApptiveGrid Form in your App use the `ApptiveGridForm` Widget

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ApptiveGridForm(
        formUri: FormUri.redirectForm(form: 'YOUR_FORM_ID'),
      ),
    );
  }
```

This works with empty forms and with pre-filled Forms.

## Customization

The Form will adjust to the App Theme to blend into the rest of the App. You can adjust the Title Style and the Padding by providing more arguments to `ApptiveGridForm`.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: ApptiveGridForm(
      formUri: FormUri.redirectForm(form: 'YOUR_FORM_ID'),
      titleStyle: Theme.of(context).textTheme.headline6,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      titlePadding: const EdgeInsets.all(16),
    ),
  );
}
```