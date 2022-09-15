// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:apptive_grid_web_apptive/apptive_grid_web_apptive.dart';
import 'package:apptive_grid_web_apptive_example/apptive_grid_pie_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApptiveGrid',
      theme: ApptiveGridTheme.light(),
      home: Scaffold(
        body: ApptiveGridWebApptive(
          builder: (context, event) {
            return ApptiveGridPieChart(
              grid: event.grid,
            );
          },
        ),
      ),
    );
  }
}
