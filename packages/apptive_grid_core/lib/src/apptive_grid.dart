import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A Base Widget needed to add general ApptiveGrid functionality to a Flutter App
///
/// This is used to look up things like the [ApptiveGridClient] for other ApptiveGrid Widgets.
/// It uses [Provider] to distribute dependencies to other ApptiveGrid Widgets
class ApptiveGrid extends StatefulWidget {
  /// Creates ApptiveGrid
  const ApptiveGrid({
    super.key,
    this.child,
    this.options = const ApptiveGridOptions(),
  }) : client = null;

  /// Creates ApptiveGrid with a shared defined ApptiveGridClient
  const ApptiveGrid.withClient({
    super.key,
    required this.client,
    this.child,
    this.options = const ApptiveGridOptions(),
  });

  /// Widget that should be wrapped. Normally this is something like [MaterialApp]
  final Widget? child;

  /// Configuration options for ApptiveGrid
  final ApptiveGridOptions options;

  /// [ApptiveGridClient] to use
  ///
  /// Used for supplying a Mocked Client for testing
  @visibleForTesting
  final ApptiveGridClient? client;

  @override
  State<ApptiveGrid> createState() => _ApptiveGridState();

  /// Get direct Access to [ApptiveGridClient]
  ///
  /// uses [Provider] to return the client
  static ApptiveGridClient getClient(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<ApptiveGridClient>(context, listen: listen);
  }

  /// Returns the [ApptiveGridOptions] associated with this [ApptiveGrid] widget
  ///
  /// uses [Provider] to return the options
  static ApptiveGridOptions getOptions(BuildContext context) {
    return Provider.of<ApptiveGridClient>(context, listen: false).options;
  }
}

class _ApptiveGridState extends State<ApptiveGrid> {
  late ApptiveGridClient _client;

  @override
  void initState() {
    super.initState();
    _client = widget.client ??
        ApptiveGridClient(
          options: widget.options,
        );
    _client.sendPendingActions();
  }

  @override
  void didUpdateWidget(covariant ApptiveGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) {
      setState(() {
        _client.setOptions(widget.options);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApptiveGridClient>.value(
          value: _client,
        ),
        Provider.value(value: widget.options),
      ],
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (widget.client == null) {
      _client.dispose();
    }
    super.dispose();
  }
}
