import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_form/active_grid_form.dart';
import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
}
