import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key, this.requestRegistration, this.onLogin})
      : super(key: key);

  final void Function()? requestRegistration;

  final void Function()? onLogin;

  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final spacing =
        ApptiveGridUserManagementContent.maybeOf(context)?.spacing ?? 16;
    return AbsorbPointer(
      absorbing: _loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: localization.hintEmail,
            ),
          ),
          SizedBox(
            height: spacing,
          ),
          PasswordFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: localization.hintPassword,
            ),
          ),
          SizedBox(
            height: spacing,
          ),
          !_loading
              ? Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(localization.actionLogin),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
          if (widget.requestRegistration != null) ...[
            SizedBox(
              height: spacing,
            ),
            Center(
              child: TextButton(
                onPressed: widget.requestRegistration,
                child: Text(localization.actionRegister),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });
    final client = ApptiveGridUserManagement.maybeOf(context)!.client;
    client
        ?.login(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .catchError((error) {
      setState(() {
        _loading = false;
        debugPrint('Error while Logging in ${error.toString()}');
      });
      return error;
    }).then((response) {
      if (response.statusCode < 400) {
        widget.onLogin?.call();
      }
    });
  }
}
