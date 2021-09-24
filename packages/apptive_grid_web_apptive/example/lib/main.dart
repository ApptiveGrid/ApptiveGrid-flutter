import 'package:apptive_grid_web_apptive/apptive_grid_web_apptive.dart';
import 'package:example/apptive_grid_pie_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apptive Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ApptiveGridExtension(
          builder: (context, event) {
            return ApptiveGridPieChart(
              grid: gridEvent,
            );
          },
        ),
      ),
    );
  }
}
