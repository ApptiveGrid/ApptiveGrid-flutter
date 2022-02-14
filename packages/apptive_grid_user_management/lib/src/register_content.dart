import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:password_rule_check/password_rule_check.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({Key? key, this.requestLogin}) : super(key: key);

  final void Function()? requestLogin;

  @override
  _RegisterContentState createState() => _RegisterContentState();
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

  @override
  void initState() {
    super.initState();
    _step = _RegisterContentStep.waitingForInput;
  }

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    if (_step != _RegisterContentStep.waitForConfirmation) {
      final spacing =
          ApptiveGridUserManagementContent.maybeOf(context)?.spacing ?? 16;
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
                decoration:
                    InputDecoration(hintText: localization.hintFirstName),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorFirstNameEmpty;
                  }
                },
              ),
              SizedBox(
                height: spacing,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration:
                    InputDecoration(hintText: localization.hintLastName),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorLastNameEmpty;
                  }
                },
              ),
              SizedBox(
                height: spacing,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: localization.hintEmail,
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return localization.validateErrorEmailEmpty;
                  } else if (RegExp(
                        r'(?!.*\.\.)(^[^\.][^@\s]+@[^@\s]+\.[^@\s\.]+$)',
                      ).firstMatch(input) ==
                      null) {
                    return localization.validateErrorEmailFormat;
                  }
                },
              ),
              SizedBox(
                height: spacing,
              ),
              PasswordFormField(
                key: _passwordFormKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: localization.hintPassword,
                  errorStyle: const TextStyle(fontSize: 0),
                ),
                validator: (_) {
                  if (_ruleCheckKey.currentState?.validate() == false) {
                    return '';
                  }
                },
              ),
              PasswordRuleCheck(
                key: _ruleCheckKey,
                controller: _passwordController,
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
                  if (input != _passwordController.text) {
                    return localization.validateErrorPasswordsNotMatching;
                  }
                },
              ),
              SizedBox(
                height: spacing,
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
      debugPrint(
        'Register(${_emailController.text}|${_passwordController.text}',
      );
      setState(() {
        _step = _RegisterContentStep.loading;
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
          debugPrint('Error while Registering ${error.toString()}');
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
