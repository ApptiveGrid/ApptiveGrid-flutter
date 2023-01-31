import 'dart:async';

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'package:apptive_grid_user_management/src/loading_notifier.dart';

/// A Widget to give the option to delete an Account
class DeleteAccount extends StatefulWidget {
  const DeleteAccount._({
    super.key,
    required Widget child,
    required this.onAccountDeleted,
  }) : _child = child;

  /// Wrap [child] in a Gesture Detector that on tap will show a confirmation dialog to delete the user's account
  /// Note that any Pointer Events will be absorbed by this widget and custom gestures are not possible with [child]
  /// [onAccountDeleted] will be called if the user's account was deleted successfully
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

  /// A [ListTile] that on tap will show a confirmation dialog to delete the user's account
  /// [onAccountDeleted] will be called if the user's account was deleted successfully
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
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        },
      ),
    );
  }

  /// A [TextButton] that on tap will show a confirmation dialog to delete the user's account
  /// [onAccountDeleted] will be called if the user's account was deleted successfully
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        },
      ),
    );
  }

  final Widget _child;

  /// A callback invoked when the user's account was deleted
  final void Function() onAccountDeleted;

  @override
  State<DeleteAccount> createState() => DeleteAccountState();
}

/// The State for [DeleteAccount]
class DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return widget._child;
  }

  /// Shows an [AlertDialog] to have the user confirm that they want their account deleted
  void showConfirmationDialog(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context);
    final client = ApptiveGridUserManagement.maybeOf(context)?.client;
    final loadingKey = GlobalKey<_LoadingStateWidgetState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return _LoadingStateWidget(
          key: loadingKey,
          child: Builder(
            builder: (context) {
              final error = _LoadingStateWidget.error(context);
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
                    if (error != null)
                      Text(
                        error is http.Response
                            ? '${error.statusCode}: ${error.body}'
                            : '${localization?.errorUnknown}\n${error!}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                actions: <Widget>[
                  if (!_LoadingStateWidget.isLoading(context))
                    TextButton(
                      child: Text(localization?.actionCancel ?? 'Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  _LoadingTextButton(
                    loadingKey: loadingKey,
                    onPressed: () async {
                      final deleted = await client
                          ?.deleteAccount()
                          .onError((error, stackTrace) {
                        loadingKey.currentState?.error = error;
                        loadingKey.currentState?.loading = false;
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
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
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
  final GlobalKey<_LoadingStateWidgetState> loadingKey;
  final FutureOr<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (_LoadingStateWidget.isLoading(context)) {
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
