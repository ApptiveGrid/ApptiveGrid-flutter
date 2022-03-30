import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

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
          redirectScheme: 'resetTest',
          confirmAccountPrompt: (confirmWidget) {
            // Show [confirmWidget] to allow Users to confirm their account
          },
          onAccountConfirmed: (loggedIn) {
            // Account was confirmed
            // go to login screen if [loggedIn] is false
          },
          resetPasswordPrompt: (resetPasswordWidget) {
            // Show [resetPasswordWidget] to allow Users to set a new password
            _navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(
                  title: const Text('Reset Password'),
                ),
                body: SingleChildScrollView(
                  child: resetPasswordWidget,
                ),
              ),
            ));
          },
          onPasswordReset: (loggedIn) async {
            // User reset their password
            // go to login screen
            debugPrint('Password reset success');
            debugPrint('User is now loggedIn: $loggedIn');
            _navigatorKey.currentState?.pop();
          },
          passwordRequirement: PasswordRequirement.safetyHint,
          child: MaterialApp(
            navigatorKey: _navigatorKey,
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
