import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ApptiveGrid(
      options: const ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
      ),
      child: Builder(builder: (context) {
        return ApptiveGridUserManagement(
          group: 'YOUR_USER_GROUP',
          clientId: 'app',
          confirmAccountPrompt: (confirmWidget) {
            // Show [confirmWidget] to allow Users to confirm their account
          },
          onAccountConfirmed: (loggedIn) {
            // Account was confirmed
            // go to login screen if [loggedIn] is false
          },
          child: MaterialApp(
            title: 'Apptive Grid User Management Example',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const LoginRegistrationPage(),
          ),
        );
      }),
    );
  }
}

class LoginRegistrationPage extends StatelessWidget {
  const LoginRegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ApptiveGridUserManagementContent(),
            )),
          ),
        ],
      ),
    );
  }
}
