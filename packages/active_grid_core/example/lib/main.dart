import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter/material.dart';

void main() async {
  await enableWebAuth();
  runApp(MyApp());
}

/// Add A ActiveGrid Widget to your Widget Tree to enable ActiveGrid Functionality
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ActiveGrid(
        options: ActiveGridOptions(
          environment: ActiveGridEnvironment.alpha,
        ),
        child: Container(),
      ),
    );
  }
}
