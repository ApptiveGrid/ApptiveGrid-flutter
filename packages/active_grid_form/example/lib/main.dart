import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
      ),
      child: MyApp(),
    ),
  );
}

/// Simply add a ApptiveGridForm Widget to your Widget Tree
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apptive grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Apptive grid Forms'),
        ),
        body: ApptiveGridForm(
          formUri: FormUri.redirectForm(form: 'YOUR_FORM_ID'),
          titleStyle: Theme.of(context).textTheme.headline6,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          titlePadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
