import 'package:apptive_grid_extension/apptive_grid_extension.dart';
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
        body: ApptiveGridExtension(builder: (context, grid) {
          return ApptiveGridPieChart(
            grid: grid,
          );
        }),
      ),
    );
  }
}
