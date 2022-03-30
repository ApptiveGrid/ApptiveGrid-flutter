import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';

import 'mocks.dart';

class StubUserManagement extends StatelessWidget {
  const StubUserManagement({Key? key, required this.child, this.client})
      : super(key: key);

  final Widget child;

  final ApptiveGridUserManagementClient? client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: ApptiveGridUserManagement.withClient(
          group: 'group',
          clientId: 'clientId',
          confirmAccountPrompt: (_) {},
          onAccountConfirmed: (_) {},
          onChangeEnvironment: (_) async {},
          resetPasswordPrompt: (_) {},
          onPasswordReset: (_) async {},
          client: client ?? MockApptiveGridUserManagementClient(),
          child: child,
        ),
      ),
    );
  }
}
