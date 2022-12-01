# ApptiveGrid Extension

[![Pub](https://img.shields.io/pub/v/apptive_grid_web_apptive.svg)](https://pub.dartlang.org/packages/apptive_grid_web_apptive)  [![pub points](https://img.shields.io/pub/points/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)  [![popularity](https://img.shields.io/pub/popularity/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)  [![likes](https://img.shields.io/pub/likes/apptive_grid_web_apptive?logo=dart)](https://pub.dev/packages/apptive_grid_web_apptive/score)

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
