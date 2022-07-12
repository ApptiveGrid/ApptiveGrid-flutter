// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ApptiveGrid(
      options: const ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
      ),
      child: Builder(
        builder: (context) {
          return ApptiveGridUserManagement(
            group: 'YOUR_USER_GROUP',
            clientId: 'app',
            redirectScheme: 'resetTest',
            confirmAccountPrompt: (confirmWidget) {
              // Show [confirmWidget] to allow Users to confirm their account
              _navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Confirm Account'),
                    ),
                    body: SingleChildScrollView(
                      child: confirmWidget,
                    ),
                  ),
                ),
              );
            },
            onAccountConfirmed: (loggedIn) {
              // Account was confirmed
              // go to login screen if [loggedIn] is false
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account Confirmed. LoggedIn: $loggedIn'),
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    return const AccountPage();
                  },
                ),
              );
            },
            resetPasswordPrompt: (resetPasswordWidget) {
              // Show [resetPasswordWidget] to allow Users to set a new password
              _navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Reset Password'),
                    ),
                    body: SingleChildScrollView(
                      child: resetPasswordWidget,
                    ),
                  ),
                ),
              );
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
        },
      ),
    );
  }
}

class LoginRegistrationPage extends StatelessWidget {
  const LoginRegistrationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ApptiveGridUserManagementContent(
                  appName: 'ApptiveGridUserManagement Example',
                  onLogin: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) {
                          return const AccountPage();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ApptiveGrid.getClient(context).getMe().then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Builder(
        builder: (_) {
          if (_user == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Column(
              children: [
                Text('Logged in as ${_user!.firstName} ${_user!.lastName}'),
                TextButton(
                  onPressed: () {
                    ApptiveGrid.getClient(context, listen: false)
                        .logout()
                        .then((_) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return const LoginRegistrationPage();
                          },
                        ),
                      );
                    });
                  },
                  child: const Text('Logout'),
                ),
                DeleteAccount.textButton(
                  onAccountDeleted: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return const LoginRegistrationPage();
                          },
                        ),
                      );
                    });
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
