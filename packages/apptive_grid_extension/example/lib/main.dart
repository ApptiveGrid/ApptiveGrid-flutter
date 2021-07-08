import 'dart:convert';

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
        appBar: AppBar(
          title: Text('Flutter Extensions'),
        ),
        body: _real,
      ),
    );
  }

    Widget get _mock {
      return Builder(builder: (context) {
        final testGrid = Grid.fromJson(jsonDecode(
            '{"name":"View","schema":{"type":"object","properties":{"fields":{"type":"array","items":[{"type":"string"},{"type":"string","enum":["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]},{"type":"string"}]},"_id":{"type":"string"}}},"entities":[{"_id":"60e6a03c80eb91785382eb14","fields":["Anton","Saturday",null]},{"_id":"60e6c27880eb9152ef82eb67","fields":["Guillaume","Monday",null]},{"_id":"60e6d16f80eb912edd82ebad","fields":["Christian","Wednesday",null]},{"_id":"60e6d23f80eb91208282ebb4","fields":["Fabian","Tuesday",null]}],"fieldIds":["737c8bpuv7uh7h59uj65hc0y","737c8c26f1am0wyn8wttsbay","737c8bga7lll9udfzaxw0156"],"fieldNames":["Name","Day","New field"],"filter":{}}'));
        return ApptiveGridPieChart(grid: testGrid);
      });
    }

    Widget get _real {
      return ApptiveGridExtension(
        builder: (context, grid) {
          return ApptiveGridPieChart(grid: grid,);
        },
      );
    }
}
