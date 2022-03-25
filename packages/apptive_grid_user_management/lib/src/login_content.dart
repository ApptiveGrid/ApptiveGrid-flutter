import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/request_reset_password_content.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

typedef RequestPasswordResetCallback = void Function(
  Widget resetPasswordContent,
  GlobalKey<RequestResetPasswordContentState> requestPasswordState,
);

/// A Widget to show Login Controls
class LoginContent extends StatefulWidget {
  /// Creates a new LoginContent Widget to display inputs for a user to log in
  const LoginContent({
    Key? key,
    this.requestRegistration,
    this.onLogin,
    this.requestResetPassword,
  }) : super(key: key);

  /// Callback invoked when the user wants to switch to registering
  /// If this is `null` no option to switch to registration is shown
  final void Function()? requestRegistration;

  /// Callback invoked after the user logged successfully
  final void Function()? onLogin;

  /// Show a custom Dialog/Widget when the User requests a new password
  final RequestPasswordResetCallback? requestResetPassword;

  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  dynamic _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final spacing =
        ApptiveGridUserManagementContent.maybeOf(context)?.spacing ?? 16;
    return AbsorbPointer(
      absorbing: _loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          EmailFormField(
            controller: _emailController,
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
          Center(
            child: TextButton(
              child: Text(
                localization.forgotPassword,
                style: textTheme.bodyText1?.copyWith(
                  decoration: TextDecoration.underline,
                  color: textTheme.bodyText2?.color,
                ),
              ),
              onPressed: () {
                _requestNewPassword();
              },
            ),
          ),
          if (_error != null) ...[
            SizedBox(
              height: spacing,
            ),
            Text(
              localization.errorLogin,
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
      _error = null;
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
        _error = error;
      });
      return error;
    }).then((response) {
      if (response.statusCode < 400) {
        widget.onLogin?.call();
      }
    });
  }

  void _requestNewPassword() {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final contentKey = GlobalKey<RequestResetPasswordContentState>();
    final content = RequestResetPasswordContent(key: contentKey);

    if (widget.requestResetPassword != null) {
      widget.requestResetPassword!.call(content, contentKey);
    } else {
      final dialogKey = GlobalKey();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (_, setState) => AlertDialog(
              key: dialogKey,
              title: Text(localization.forgotPassword),
              content: content,
              actions: contentKey.currentState?.success == true
                  ? [
                      TextButton(
                        onPressed: Navigator.of(dialogContext).pop,
                        child: Text(localization.actionOk),
                      ),
                    ]
                  : [
                      TextButton(
                        onPressed: Navigator.of(dialogContext).pop,
                        child: Text(localization.actionCancel),
                      ),
                      // Use Builder to make sure the state of the content is non-null to enable the button
                      Builder(
                        builder: (context) => TextButton(
                          onPressed: () async {
                            await contentKey.currentState?.requestNewPassword();
                            setState.call(() {});
                          },
                          child: Text(localization.actionResetPassword),
                        ),
                      )
                    ],
            ),
          );
        },
      );
    }
  }
}
