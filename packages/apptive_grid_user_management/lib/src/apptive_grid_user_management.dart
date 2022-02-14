import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_user_management/src/confirm_account.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

class ApptiveGridUserManagement extends StatefulWidget {
  const ApptiveGridUserManagement({
    Key? key,
    required this.group,
    required this.clientId,
    this.redirectScheme,
    this.child,
    required this.confirmAccountPrompt,
    required this.onAccountConfirmed,
    this.onChangeEnvironment,
  })  : _client = null,
        super(key: key);

  final String group;
  final String clientId;
  final String? redirectScheme;
  final Widget? child;

  final Future<void> Function(ApptiveGridEnvironment environment)?
      onChangeEnvironment;
  final void Function(Widget confirmationWidget) confirmAccountPrompt;
  final void Function(bool loggedIn) onAccountConfirmed;

  final ApptiveGridUserManagementClient? _client;

  @visibleForTesting
  const ApptiveGridUserManagement.withClient({
    Key? key,
    required this.group,
    required this.clientId,
    this.redirectScheme,
    this.child,
    required this.confirmAccountPrompt,
    required this.onAccountConfirmed,
    this.onChangeEnvironment,
    required ApptiveGridUserManagementClient client,
  })  : _client = client,
        super(key: key);

  @override
  State<ApptiveGridUserManagement> createState() =>
      _ApptiveGridUserManagementState();

  static _ApptiveGridUserManagementState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_ApptiveGridUserManagementState>();
  }
}

class _ApptiveGridUserManagementState extends State<ApptiveGridUserManagement> {
  ApptiveGridUserManagementClient? _userManagementClient;

  StreamSubscription? _deepLinkSubscription;

  final Completer<bool> _initialConfirmationChecker = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userManagementClient = widget._client ??
        ApptiveGridUserManagementClient(
          group: widget.group,
          clientId: widget.clientId,
          redirectSchema: widget.redirectScheme,
          apptiveGridClient: ApptiveGrid.getClient(context),
        );

    uni_links.getInitialUri().then((uri) async {
      final isConfirmation = await _requestConfirmation(uri);
      _initialConfirmationChecker.complete(isConfirmation);
      return uri;
    });
    _deepLinkSubscription =
        uni_links.uriLinkStream.listen(_requestConfirmation);
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGridUserManagementLocalization(
      child: widget.child ?? const SizedBox(),
    );
  }

  ApptiveGridUserManagementClient? get client => _userManagementClient;

  Future<bool> _requestConfirmation(Uri? uri) async {
    final isConfirmation = _isConfirmationLink(uri);
    if (isConfirmation) {
      assert(uri != null);
      final environment = ApptiveGridEnvironment.values.firstWhere(
        (element) => Uri.parse(element.url).host == uri!.host,
        orElse: () => ApptiveGridEnvironment.production,
      );
      await widget.onChangeEnvironment?.call(environment);

      widget.confirmAccountPrompt(
        ApptiveGridUserManagementLocalization(
          child: ConfirmAccount(
            confirmationUri: uri!,
            confirmAccount: widget.onAccountConfirmed,
          ),
        ),
      );
    }
    return isConfirmation;
  }

  bool _isConfirmationLink(Uri? uri) {
    return uri != null &&
        uri.host.endsWith('apptivegrid.de') &&
        uri.pathSegments.contains('auth') &&
        uri.pathSegments.contains('confirm') &&
        uri.pathSegments.contains(widget.group);
  }

  Future<bool> initialSetup() => _initialConfirmationChecker.future;
}
