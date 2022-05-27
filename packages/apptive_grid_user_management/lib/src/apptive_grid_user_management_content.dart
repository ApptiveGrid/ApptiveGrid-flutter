import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:apptive_grid_user_management/src/register_content.dart';
import 'package:flutter/material.dart';

/// Widget to show UserManagement Content to the User
class ApptiveGridUserManagementContent extends StatefulWidget {
  /// Creates a Content Widget to show the user Content
  const ApptiveGridUserManagementContent({
    Key? key,
    this.initialContentType = ContentType.register,
    this.onLogin,
    this.spacing = 16.0,
    this.requestResetPassword,
  }) : super(key: key);

  /// The initial [ContentType] that should be displayed
  final ContentType initialContentType;

  /// Callback invoked when the user logged in successfully
  final void Function()? onLogin;

  /// Custom spacing between items
  final double spacing;

  /// Called with [resetPasswordContent] and [resetPasswordKey] to be able to build custom UIs to request a new Password
  final RequestPasswordResetCallback? requestResetPassword;

  @override
  State<ApptiveGridUserManagementContent> createState() =>
      _ApptiveGridUserManagementContentState();

  /// Returns the closest nullable [_ApptiveGridUserManagementContentState]
  static State<ApptiveGridUserManagementContent>? maybeOf(
    BuildContext context,
  ) {
    return context
        .findAncestorStateOfType<State<ApptiveGridUserManagementContent>>();
  }
}

class _ApptiveGridUserManagementContentState
    extends State<ApptiveGridUserManagementContent> {
  late ContentType _contentType;

  @override
  void initState() {
    super.initState();
    _contentType = widget.initialContentType;
  }

  @override
  Widget build(BuildContext context) {
    switch (_contentType) {
      case ContentType.login:
        return LoginContent(
          requestRegistration: () {
            setState(() {
              _contentType = ContentType.register;
            });
          },
          requestResetPassword: widget.requestResetPassword,
          onLogin: widget.onLogin,
        );
      case ContentType.register:
        return RegisterContent(
          requestLogin: () {
            setState(() {
              _contentType = ContentType.login;
            });
          },
        );
    }
  }
}

/// The different Content Types the user can see
enum ContentType {
  /// Content to login as an existing User
  login,

  /// Content to register as a new user
  register,
}
