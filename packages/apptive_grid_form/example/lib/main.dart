// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
        authenticationOptions: ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
        ),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          formUri: RedirectFormUri(form: 'YOUR_FORM_ID'),
          titleStyle: Theme.of(context).textTheme.headline6,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          titlePadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
