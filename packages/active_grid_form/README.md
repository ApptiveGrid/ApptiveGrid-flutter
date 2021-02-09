# ActiveGrid Form

A Flutter Package to display ActiveGrid Forms inside a Flutter App

## Setup

In order to use any ActiveGrid Feature you must wrap your App with a `ActiveGrid` Widget

```dart
import 'package:active_grid_core/active_grid_core.dart';

void main() {
  runApp(
    ActiveGrid(
      options: ActiveGridOptions(
        environment: ActiveGridEnvironment.alpha,
      ),
      child: MyApp(),
    ),
  );
}
```

## Showing a Form

In order to display an ActiveGrid Form in your App use the `ActiveGridForm` Widget

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ActiveGridForm(
        formId: 'YOUR_FORM_ID',
      ),
    );
  }
```

This works with empty forms and with pre-filled Forms.

## Customization

The Form will adjust to the App Theme to blend into the rest of the App. You can adjust the Title Style and the Padding by providing more arguments to `ActiveGridForm`.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: ActiveGridForm(
      formId: 'YOUR_FORM_ID',
      titleStyle: Theme.of(context).textTheme.headline6,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      titlePadding: const EdgeInsets.all(16),
    ),
  );
}
```