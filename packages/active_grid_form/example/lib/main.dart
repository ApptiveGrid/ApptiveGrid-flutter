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

/// Simply add a ActiveGridForm Widget to your Widget Tree
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Active Grid Forms'),
        ),
        body: ActiveGridForm(
          formUri: FormUri.fromRedirectUri(form: 'YOUR_FORM_ID'),
          titleStyle: Theme.of(context).textTheme.headline6,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          titlePadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
