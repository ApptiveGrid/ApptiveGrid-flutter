# ApptiveGrid Extension

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
