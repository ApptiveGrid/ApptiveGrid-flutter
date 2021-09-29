import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ApptiveGrid(
      options: const ApptiveGridOptions(
          environment: ApptiveGridEnvironment.alpha,
          authenticationOptions: ApptiveGridAuthenticationOptions(
            autoAuthenticate: true,
          )),
      child: MyApp(),
    ),
  );
}

/// Simply add a ApptiveGridForm Widget to your Widget Tree
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
          title: const Text('ApptiveGrid Forms'),
        ),
        body: ApptiveGridForm(
          formUri: FormUri.fromUri('YOUR_FORM_URI'),
          titleStyle: Theme.of(context).textTheme.headline6,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          titlePadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
