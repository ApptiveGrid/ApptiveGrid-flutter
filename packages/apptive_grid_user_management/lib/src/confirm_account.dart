import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  State<ConfirmAccount> createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  bool _loading = false;

  dynamic _error;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final spacing =
        ApptiveGridUserManagementContent.maybeOf(context)?.widget.spacing ?? 16;
    return AbsorbPointer(
      absorbing: _loading,
      child: Column(
        children: [
          Text(localization.confirmAccountCreation),
          if (_error != null) ...[
            SizedBox(
              height: spacing,
            ),
            Text(
              localization.errorConfirm,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_error is Response)
              Text(
                (_error as Response).body,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
          ],
          SizedBox(
            height: _error == null ? spacing : spacing * 0.5,
          ),
          _loading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : ElevatedButton(
                  onPressed: _confirmAccount,
                  child: Text(localization.actionConfirm),
                )
        ],
      ),
    );
  }

  Future<void> _confirmAccount() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final client = ApptiveGridUserManagement.maybeOf(context)!.client;

    final confirmResponse = await client
        ?.confirmAccount(
      confirmationUri: widget.confirmationUri.replace(scheme: 'https'),
    )
        .catchError((error) {
      setState(() {
        _loading = false;
        _error = error;
      });
      return error;
    });

    if (confirmResponse != null && confirmResponse.statusCode < 400) {
      final loggedIn = await client?.loginAfterConfirmation() ?? false;
      widget.confirmAccount.call(loggedIn);
    }
  }
}
