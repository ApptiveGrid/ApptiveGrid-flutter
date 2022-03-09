import 'package:apptive_grid_core/apptive_grid_options.dart';
import 'package:apptive_grid_core/apptive_grid_network.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A Base Widget needed to add general ApptiveGrid functionality to a Flutter App
///
/// This is used to look up things like the [ApptiveGridClient] for other ApptiveGrid Widgets.
/// It uses [Provider] to distribute dependencies to other ApptiveGrid Widgets
class ApptiveGrid extends StatefulWidget {
  /// Creates ApptiveGrid
  const ApptiveGrid({
    Key? key,
    this.child,
    this.options = const ApptiveGridOptions(),
  })  : client = null,
        super(key: key);

  /// Creates ApptiveGrid with a shared defined ApptiveGridClient
  const ApptiveGrid.withClient({
    Key? key,
    required this.client,
    this.child,
    this.options = const ApptiveGridOptions(),
  }) : super(key: key);

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
  _ApptiveGridState createState() => _ApptiveGridState();

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
        _client.options = widget.options;
        _client.updateEnvironment(widget.options.environment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApptiveGridClient>.value(
          value: _client,
        ),
        Provider.value(value: widget.options),
      ],
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }
}
