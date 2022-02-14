import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_user_management/src/confirm_account.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

/// Adds the ability to add ApptiveGridUserManagement to an App
/// This should live near an [ApptiveGrid] Widget
class ApptiveGridUserManagement extends StatefulWidget {
  /// Creates a new ApptiveGridUserManagement Widget
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

  /// Creates a new ApptiveGridUserManagement Widget with a custom [client]
  /// Used for Testing
  @visibleForTesting
  const ApptiveGridUserManagement.withClient({
    Key? key,
    required this.group,
    this.clientId = 'app',
    this.redirectScheme,
    this.child,
    required this.confirmAccountPrompt,
    required this.onAccountConfirmed,
    this.onChangeEnvironment,
    required ApptiveGridUserManagementClient client,
  })  : _client = client,
        super(key: key);

  /// User Group the users should be added to
  final String group;

  /// The Client Id
  final String clientId;

  /// The redirect Scheme that should be used in the Confirmation Link in the email
  /// if this is not provided the email will contain a https://app.apptivegrid.de/ link
  /// If you want to use the https Links (support for iOS Universal Linking) contact ApptiveGrid to get your App added
  /// info@apptivegrid.de
  final String? redirectScheme;

  /// The Widget that should be shown beneath
  final Widget? child;

  /// Callback to change the [environment] of ApptiveGrid
  /// This is called when opening the App with a Confirmation Link which might have a different environment than the rest of the app
  final Future<void> Function(ApptiveGridEnvironment environment)?
      onChangeEnvironment;

  /// Notifies that the app has been opened to confirm a user Account
  /// The user should be redirected to a Widget/Page containing the [confirmationWidget]
  final void Function(Widget confirmationWidget) confirmAccountPrompt;

  /// Callback when the User successfully confirmed their account
  final void Function(bool loggedIn) onAccountConfirmed;

  final ApptiveGridUserManagementClient? _client;

  @override
  State<ApptiveGridUserManagement> createState() =>
      _ApptiveGridUserManagementState();

  /// Returns the closest nullable [_ApptiveGridUserManagementState]
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

  /// Wait until the initial setup is completed. Used for checking if the app was started with a confirmation Link
  /// Useful for custom splash screens
  Future<bool> initialSetup() => _initialConfirmationChecker.future;
}
