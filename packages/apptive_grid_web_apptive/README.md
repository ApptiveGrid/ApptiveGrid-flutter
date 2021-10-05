# ApptiveGrid Extension

[![Pub](https://img.shields.io/pub/v/apptive_grid_web_apptive.svg)](https://pub.dartlang.org/packages/apptive_grid_web_apptive)  [![pub points](https://badges.bar/apptive_grid_web_apptive/pub%20points)](https://pub.dev/packages/apptive_grid_web_apptive/score)  [![popularity](https://badges.bar/apptive_grid_web_apptive/popularity)](https://pub.dev/packages/apptive_grid_web_apptive/score)  [![likes](https://badges.bar/apptive_grid_web_apptive/likes)](https://pub.dev/packages/apptive_grid_web_apptive/score)

A Flutter Package to use as a Wrapper for Apptives on the web client of ApptiveGrid

## Setup

Wrap your Apptive with ApptiveGridWebApptive. The builder method will be called everytime the Data updates.

```dart
ApptiveGridWebApptive(
  builder: (context, event) {
    return ApptiveGridPieChart(
      grid: gridEvent,
);
```

## Adding Apptives to ApptiveGrid

Check back later to learn how you can add your Apptives to ApptiveGrid
