import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:apptive_grid_user_management/src/register_content.dart';
import 'package:flutter/material.dart';

class ApptiveGridUserManagementContent extends StatefulWidget {
  const ApptiveGridUserManagementContent({
    Key? key,
    this.initialContentType = ContentType.register,
    this.onLogin,
    this.spacing = 16.0,
  }) : super(key: key);

  final ContentType initialContentType;

  final void Function()? onLogin;

  final double spacing;

  @override
  _ApptiveGridUserManagementContentState createState() =>
      _ApptiveGridUserManagementContentState();

  static _ApptiveGridUserManagementContentState? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_ApptiveGridUserManagementContentState>();
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

  double get spacing => widget.spacing;
}

enum ContentType { login, register }
