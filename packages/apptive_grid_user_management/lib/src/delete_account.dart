import 'dart:async';

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/loading_notifier.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteAccount extends StatefulWidget {
  const DeleteAccount._({
    super.key,
    required Widget child,
    required this.onAccountDeleted,
  }) : _child = child;

  factory DeleteAccount({
    required Widget child,
    required void Function() onAccountDeleted,
  }) {
    final key = GlobalKey<DeleteAccountState>();
    return DeleteAccount._(
      key: key,
      onAccountDeleted: onAccountDeleted,
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              key.currentState?.showConfirmationDialog(context);
            },
            child: AbsorbPointer(child: child),
          );
        },
      ),
    );
  }

  factory DeleteAccount.listTile({
    required void Function() onAccountDeleted,
  }) {
    final key = GlobalKey<DeleteAccountState>();
    return DeleteAccount._(
      key: key,
      onAccountDeleted: onAccountDeleted,
      child: Builder(
        builder: (context) {
          return ListTile(
            onTap: () => key.currentState?.showConfirmationDialog(context),
            title: Text(
              ApptiveGridUserManagementLocalization.of(context)!.deleteAccount,
            ),
          );
        },
      ),
    );
  }

  factory DeleteAccount.textButton({
    required void Function() onAccountDeleted,
  }) {
    final key = GlobalKey<DeleteAccountState>();
    return DeleteAccount._(
      key: key,
      onAccountDeleted: onAccountDeleted,
      child: Builder(
        builder: (context) {
          return TextButton(
            onPressed: () => key.currentState?.showConfirmationDialog(context),
            child: Text(
              ApptiveGridUserManagementLocalization.of(context)!.deleteAccount,
            ),
          );
        },
      ),
    );
  }

  final Widget _child;
  final void Function() onAccountDeleted;

  @override
  State<DeleteAccount> createState() => DeleteAccountState();
}

class DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return widget._child;
  }

  void showConfirmationDialog(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context);
    final client = ApptiveGridUserManagement.maybeOf(context)?.client;
    final loadingey = GlobalKey<LoadingStateWidgetState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return LoadingStateWidget(
          key: loadingey,
          child: Builder(
            builder: (context) {
              return AlertDialog(
                title: Text(localization?.deleteAccount ?? 'Delete Account'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      localization?.deleteAccountConfirmation ??
                          'Are you sure you want to delete your account?\n This can not be undone.',
                    ),
                    if (LoadingStateWidget.error(context) != null)
                      Text(
                        LoadingStateWidget.error(context) is http.Response
                            ? '${LoadingStateWidget.error(context).statusCode}: ${LoadingStateWidget.error(context).body}'
                            : '${localization?.errorUnknown}\n${LoadingStateWidget.error(context)!}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                actions: <Widget>[
                  if (!LoadingStateWidget.isLoading(context))
                    TextButton(
                      child: Text(localization?.actionCancel ?? 'Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  _LoadingTextButton(
                    loadingKey: loadingey,
                    onPressed: () async {
                      final deleted = await client
                          ?.deleteAccount()
                          .onError((error, stackTrace) {
                        loadingey.currentState?.error = error;
                        loadingey.currentState?.loading = false;
                        return false;
                      });
                      if (deleted == true) {
                        widget.onAccountDeleted();
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text(
                      localization?.actionDelete ?? 'Delete',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _LoadingTextButton extends StatelessWidget {
  const _LoadingTextButton({
    required this.child,
    required this.loadingKey,
    required this.onPressed,
  });

  final Widget child;
  final GlobalKey<LoadingStateWidgetState> loadingKey;
  final FutureOr<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (LoadingStateWidget.isLoading(context)) {
      return const TextButton(
        onPressed: null,
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return TextButton(
        onPressed: () async {
          loadingKey.currentState?.loading = true;
          await onPressed();
          loadingKey.currentState?.loading = false;
        },
        child: child,
      );
    }
  }
}
