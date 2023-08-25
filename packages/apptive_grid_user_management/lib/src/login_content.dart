import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/password_form_field.dart';
import 'package:apptive_grid_user_management/src/request_reset_password_content.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

/// Callback to build custom UIs for requesting a reset Link
/// [resetPasswordContent] is the UI with Messaging and the textfield to display
/// with the [RequestResetPasswordContentState] state acquired through the [requestPasswordKey] you can trigger the reset
/// Note that the email that is used gets the input from a field in [resetPasswordContent]
/// If you need a more custom experience you need to build your own ui and call [ApptiveGridUserManagementClient.requestResetPassword] yourself
typedef RequestPasswordResetCallback = void Function(
  Widget resetPasswordContent,
  GlobalKey<RequestResetPasswordContentState> requestPasswordKey,
);

/// A Widget to show Login Controls
class LoginContent extends StatefulWidget {
  /// Creates a new LoginContent Widget to display inputs for a user to log in
  const LoginContent({
    super.key,
    this.requestRegistration,
    this.onLogin,
    this.requestResetPassword,
    this.appName,
  });

  /// Callback invoked when the user wants to switch to registering
  /// If this is `null` no option to switch to registration is shown
  final void Function()? requestRegistration;

  /// Callback invoked after the user logged successfully
  final void Function()? onLogin;

  /// Show a custom Dialog/Widget when the User requests a new password
  final RequestPasswordResetCallback? requestResetPassword;

  /// The name to display when showing users info if their account is already connected to this app. Defaults to [ApptiveGridUserManagementClient.group]
  final String? appName;

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  ApptiveGridUserManagementClient? _client;

  _LoginContentStep _step = _LoginContentStep.waitForInput;
  bool _loading = false;

  dynamic _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGridUserManagement.maybeOf(context)?.client;
  }

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
        ApptiveGridUserManagementContent.maybeOf(context)?.widget.spacing ?? 16;
    return AbsorbPointer(
      absorbing: _loading,
      child: Builder(
        builder: (context) {
          switch (_step) {
            case _LoginContentStep.waitForInput:
              return AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmailFormField(
                      controller: _emailController,
                      autofillHints: const [AutofillHints.username],
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    PasswordFormField(
                      controller: _passwordController,
                      autofillHints: const [AutofillHints.password],
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
                          style: textTheme.bodyLarge?.copyWith(
                            decoration: TextDecoration.underline,
                            color: textTheme.bodyMedium?.color,
                          ),
                        ),
                        onPressed: () {
                          _requestResetPassword();
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
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_error is Response)
                        Text(
                          (_error as Response).body,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
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
                    ],
                  ],
                ),
              );
            case _LoginContentStep.joinGroup:
              final appName = widget.appName ?? _client?.group ?? '';
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(localization.joinGroup(appName)),
                  if (_error != null) ...[
                    SizedBox(
                      height: spacing,
                    ),
                    Text(
                      localization.errorUnknown,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_error is Response)
                      Text(
                        (_error as Response).body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                  Center(
                    child: !_loading
                        ? Center(
                            child: ElevatedButton(
                              onPressed: _joinGroup,
                              child: Text(localization.actionJoinGroup),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                  ),
                  Center(
                    child: TextButton(
                      child: Text(localization.actionBack),
                      onPressed: () {
                        setState(() {
                          _step = _LoginContentStep.waitForInput;
                        });
                      },
                    ),
                  ),
                ],
              );
            case _LoginContentStep.waitForConfirmation:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(localization.registerWaitingForConfirmation),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _emailController.clear();
                        _passwordController.clear();
                        setState(() {
                          _step = _LoginContentStep.waitForInput;
                        });
                      },
                      child: Text(localization.actionBack),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    _client
        ?.login(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .catchError((error) {
      setState(() {
        _loading = false;
        if (error is Response && error.statusCode == 403) {
          _step = _LoginContentStep.joinGroup;
        } else {
          _error = error;
          _step = _LoginContentStep.waitForInput;
        }
      });
      return error;
    }).then((response) {
      if (response.statusCode < 400) {
        widget.onLogin?.call();
      }
    });
  }

  Future<void> _joinGroup() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    _client
        ?.register(
      firstName: '',
      lastName: '',
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
        setState(() {
          _loading = false;
          _step = _LoginContentStep.waitForConfirmation;
        });
      }
    });
  }

  void _requestResetPassword() {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    final contentKey = GlobalKey<RequestResetPasswordContentState>();

    final customTranslations =
        ApptiveGridUserManagement.maybeOf(context)?.widget.customTranslations ??
            {}; // coverage:ignore-line

    if (widget.requestResetPassword != null) {
      final content = ApptiveGridUserManagementLocalization(
        customTranslations: customTranslations,
        child: RequestResetPasswordContent(
          key: contentKey,
        ),
      );
      widget.requestResetPassword!.call(content, contentKey);
    } else {
      final content = ApptiveGridUserManagementLocalization(
        customTranslations: customTranslations,
        child: RequestResetPasswordContent(
          key: contentKey,
          // Provide function to get the client from the dialog
          getClient: () => ApptiveGridUserManagement.maybeOf(context)?.client,
        ),
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (_, setState) => AlertDialog(
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
                      TextButton(
                        onPressed: () async {
                          await contentKey.currentState?.requestResetPassword();
                          setState.call(() {});
                        },
                        child: Text(localization.actionResetPassword),
                      ),
                    ],
            ),
          );
        },
      );
    }
  }
}

enum _LoginContentStep {
  waitForInput,
  joinGroup,
  waitForConfirmation,
}
