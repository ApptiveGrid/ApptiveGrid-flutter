import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';

/// Widget to confirm an account
class ConfirmAccount extends StatefulWidget {
  /// Creates a Widget that allows users to confirm their account
  const ConfirmAccount({
    Key? key,
    required this.confirmationUri,
    required this.confirmAccount,
  }) : super(key: key);

  /// Uri the Confirmation should be made against
  final Uri confirmationUri;

  /// Callback invoked after the account was confirmed
  /// [loggedIn] indicates if the user was logged in automatically after confirmation
  final void Function(bool loggedIn) confirmAccount;

  @override
  _ConfirmAccountState createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final localisation = ApptiveGridUserManagementLocalization.of(context)!;
    return AbsorbPointer(
      absorbing: _loading,
      child: Column(
        children: [
          Text(localisation.confirmAccountCreation),
          _loading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : ElevatedButton(
                  onPressed: _confirmAccount,
                  child: Text(localisation.actionConfirm),
                )
        ],
      ),
    );
  }

  Future<void> _confirmAccount() async {
    setState(() {
      _loading = true;
    });
    final client = ApptiveGridUserManagement.maybeOf(context)!.client;

    final confirmResponse = await client
        ?.confirmAccount(
      confirmationUri: widget.confirmationUri.replace(scheme: 'https'),
    )
        .catchError((error) {
      setState(() {
        _loading = false;
        debugPrint('Error while Logging in ${error.toString()}');
      });
      return error;
    });

    if (confirmResponse != null && confirmResponse.statusCode < 400) {
      final loggedIn = await client?.loginAfterConfirmation() ?? false;
      widget.confirmAccount.call(loggedIn);
    }
  }
}
