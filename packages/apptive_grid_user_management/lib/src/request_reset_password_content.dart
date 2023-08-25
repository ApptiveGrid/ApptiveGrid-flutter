import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/email_form_field.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Content to show if the user forgot their password
///
/// Shows Messaging on what is happening and provides a Input field to provide an email
class RequestResetPasswordContent extends StatefulWidget {
  /// Creates a new ResetPasswordContent Widget
  const RequestResetPasswordContent({super.key, this.getClient});

  /// Function to get a [ApptiveGridUserManagementClient]
  ///
  /// Needed for the default behaviour of the forgot passwort button in [LoginContent] to get access to the Client from a dialog
  final ApptiveGridUserManagementClient? Function()? getClient;

  @override
  RequestResetPasswordContentState createState() =>
      RequestResetPasswordContentState();
}

/// State for [RequestResetPasswordContent]
class RequestResetPasswordContentState
    extends State<RequestResetPasswordContent> {
  bool _loading = false;

  bool _success = false;

  /// returns `true` if the email was send
  bool get success => _success;

  dynamic _error;
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;

    final spacing =
        ApptiveGridUserManagementContent.maybeOf(context)?.widget.spacing ?? 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _loading
          ? [
              const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ]
          : _success
              ? [
                  Center(
                    child: Builder(
                      builder: (context) {
                        final baseString =
                            localization.requestResetPasswordSuccess(
                          _textEditingController.text,
                        );
                        final mail = _textEditingController.text;
                        final beforeMail =
                            baseString.substring(0, baseString.indexOf(mail));
                        final afterMail = baseString.substring(
                          baseString.lastIndexOf(mail) + mail.length,
                        );
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: beforeMail),
                              TextSpan(
                                text: mail,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: afterMail),
                            ],
                            //style: baseStyle,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ]
              : [
                  Text(
                    localization.forgotPasswordMessage,
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKey,
                    child: EmailFormField(
                      controller: _textEditingController,
                      autofillHints: const [AutofillHints.username],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.validateErrorEmailEmpty;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
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
                    if (_error is http.Response)
                      Text(
                        (_error as http.Response).body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ],
    );
  }

  /// Requests that there is a reset link send to the user
  ///
  /// If there already is a request running or there has been a mail send already then this call will return
  /// If the email is null or empty there will be a hint to the user and no request will be made
  Future<void> requestResetPassword() async {
    if (_loading || _success) {
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final emailSet = _formKey.currentState?.validate();
    if (emailSet != true) {
      // Non Valid email
      setState(() {
        _loading = false;
      });
      return;
    }
    final client = widget.getClient?.call() ??
        ApptiveGridUserManagement.maybeOf(context)?.client;
    final response = await client
        ?.requestResetPassword(email: _textEditingController.text)
        .catchError((error) {
      _error = error;
      if (error is http.Response) {
        return error;
      } else {
        return http.Response(error.toString(), 400);
      }
    });

    setState(() {
      _loading = false;
      _success = response != null && _error == null;
    });
    return;
  }
}
