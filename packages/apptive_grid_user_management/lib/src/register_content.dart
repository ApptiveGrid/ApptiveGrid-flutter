import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/password_check.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:password_rule_check/password_rule_check.dart';

/// A Widget to show Registration Controls
class RegisterContent extends StatefulWidget {
  /// Creates a new RegisterContent Widget to display inputs for a user to register a new account
  const RegisterContent({Key? key, this.requestLogin}) : super(key: key);

  /// Callback invoked when the user wants to switch to registering
  /// If this is `null` no option to switch to registration is shown
  final void Function()? requestLogin;

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _ruleCheckKey = GlobalKey<PasswordRuleCheckState>();

  late _RegisterContentStep _step;

  dynamic _error;

  @override
  void initState() {
    super.initState();
    _step = _RegisterContentStep.waitingForInput;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    if (_step != _RegisterContentStep.waitForConfirmation) {
      final spacing =
          ApptiveGridUserManagementContent.maybeOf(context)?.widget.spacing ??
              16;
      return AbsorbPointer(
        absorbing: _step == _RegisterContentStep.loading,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                autofillHints: const [AutofillHints.givenName],
                decoration:
                    InputDecoration(hintText: localization.hintFirstName),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorFirstNameEmpty;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: spacing,
              ),
              TextFormField(
                controller: _lastNameController,
                autofillHints: const [AutofillHints.familyName],
                decoration:
                    InputDecoration(hintText: localization.hintLastName),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorLastNameEmpty;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: spacing,
              ),
              EmailFormField(
                controller: _emailController,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorEmailEmpty;
                  } else if (RegExp(
                        r'(?!.*\.\.)(^[^\.][^@\s]+@[^@\s]+\.[^@\s\.]+$)',
                      ).firstMatch(input) ==
                      null) {
                    return localization.validateErrorEmailFormat;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: spacing,
              ),
              PasswordFormField(
                key: _passwordFormKey,
                controller: _passwordController,
                autofillHints: const [AutofillHints.newPassword],
                decoration: InputDecoration(
                  hintText: localization.hintPassword,
                  errorStyle: const TextStyle(fontSize: 0),
                ),
                validator: (_) {
                  if (_ruleCheckKey.currentState?.validate() == false) {
                    return '';
                  }
                  return null;
                },
              ),
              PasswordCheck(
                controller: _passwordController,
                validationKey: _ruleCheckKey,
              ),
              SizedBox(
                height: spacing,
              ),
              PasswordFormField(
                controller: _confirmPasswordController,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  hintText: localization.hintConfirmPassword,
                ),
                validator: (input) {
                  if (input != _passwordController.text) {
                    return localization.validateErrorPasswordsNotMatching;
                  }
                  return null;
                },
              ),
              if (_error != null) ...[
                SizedBox(
                  height: spacing,
                ),
                Text(
                  localization.errorRegister,
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
              _step != _RegisterContentStep.loading
                  ? Center(
                      child: ElevatedButton(
                        onPressed: _register,
                        child: Text(localization.actionRegister),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
              if (widget.requestLogin != null) ...[
                SizedBox(
                  height: spacing,
                ),
                Center(
                  child: TextButton(
                    onPressed: widget.requestLogin,
                    child: Text(localization.actionLogin),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text(localization.registerWaitingForConfirmation));
    }
  }

  void _register() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _step = _RegisterContentStep.loading;
        _error = null;
      });
      final client = ApptiveGridUserManagement.maybeOf(context)!.client;
      client
          ?.register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      )
          .catchError((error) {
        setState(() {
          _step = _RegisterContentStep.waitingForInput;
          _error = error;
        });
        return error;
      }).then((response) {
        if (response.statusCode < 400) {
          setState(() {
            _step = _RegisterContentStep.waitForConfirmation;
          });
        }
      });
    }
  }
}

enum _RegisterContentStep {
  waitingForInput,
  loading,
  waitForConfirmation,
}
