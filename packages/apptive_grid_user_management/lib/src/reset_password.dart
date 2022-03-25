import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password_rule_check/password_rule_check.dart';

/// Widget to reset the users password
class ResetPassword extends StatefulWidget {
  /// Creates a Widget that allows users to reset their password
  const ResetPassword({
    Key? key,
    required this.resetUri,
    required this.onReset,
  }) : super(key: key);

  /// Uri the Reset Call should be made against
  final Uri resetUri;

  /// Callback invoked after the user accnowledge that their password was reset successfully
  /// [loggedIn] indicates if the user was logged in automatically after confirmation
  final void Function(bool loggedIn) onReset;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _loading = false;
  bool _success = false;
  dynamic _error;

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _newPasswordFormKey = GlobalKey<FormFieldState>();
  final _ruleCheckKey = GlobalKey<PasswordRuleCheckState>();

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final spacing =
        ApptiveGridUserManagementContent.maybeOf(context)?.spacing ?? 16;
    return AbsorbPointer(
      absorbing: _loading,
      child: Form(
        key: _formKey,
        child: Column(
          children: _success
              ? [
                  Text(localization.resetPasswordSuccess),
                  _loading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: _confirmReset,
                            child: Text(localization.actionLogin),
                          ),
                        )
                ]
              : [
                  PasswordFormField(
                    key: _newPasswordFormKey,
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      hintText: localization.hintNewPassword,
                      errorStyle: const TextStyle(fontSize: 0),
                    ),
                    validator: (_) {
                      if (_ruleCheckKey.currentState?.validate() == false) {
                        return '';
                      }
                      return null;
                    },
                    readOnly: _loading,
                  ),
                  PasswordRuleCheck(
                    key: _ruleCheckKey,
                    controller: _newPasswordController,
                    ruleSet: PasswordRuleSet(
                      minLength: 8,
                      digits: 1,
                      specialCharacters: 1,
                      lowercase: 1,
                      uppercase: 1,
                    ),
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  PasswordFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: localization.hintConfirmPassword,
                    ),
                    validator: (input) {
                      if (input != _newPasswordController.text) {
                        return localization.validateErrorPasswordsNotMatching;
                      }
                      return null;
                    },
                    readOnly: _loading,
                  ),
                  if (_error != null) ...[
                    SizedBox(
                      height: spacing,
                    ),
                    Text(
                      localization.errorReset,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_error is http.Response)
                      Text(
                        (_error as http.Response).body,
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
                      : Center(
                          child: ElevatedButton(
                            onPressed: _resetPassword,
                            child: Text(localization.actionResetPassword),
                          ),
                        )
                ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    setState(() {
      _loading = true;
      _success = false;
      _error = null;
    });
    http.Response? resetResponse;

    if (_formKey.currentState?.validate() ?? false) {
      final client = ApptiveGridUserManagement.maybeOf(context)!.client;

      resetResponse = await client
          ?.resetPassword(
        resetUri: widget.resetUri.replace(scheme: 'https'),
        newPassword: _newPasswordController.text,
      )
          .catchError((error) {
        _error = error;
        if (error is http.Response) {
          return error;
        } else {
          return http.Response(error.toString(), 400);
        }
      });
    }

    setState(() {
      _loading = false;
      _success = resetResponse != null &&
          resetResponse.statusCode < 400 &&
          _error == null;
    });
  }

  Future<void> _confirmReset() async {
    setState(() {
      _loading = true;
    });

    final client = ApptiveGridUserManagement.maybeOf(context)!.client;
    final loggedIn = await client?.loginAfterConfirmation() ?? false;
    widget.onReset.call(loggedIn);
  }
}
