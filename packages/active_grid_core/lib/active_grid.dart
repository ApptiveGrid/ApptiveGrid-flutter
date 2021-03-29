import 'package:active_grid_core/active_grid_options.dart';
import 'package:active_grid_core/active_grid_network.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A Base Widget needed to add general ActiveGrid functionality to a Flutter App
///
/// This is used to look up things like the [ActiveGridClient] for other ActiveGrid Widgets.
/// It uses [Provider] to distribute dependencies to other ActiveGrid Widgets
class ActiveGrid extends StatefulWidget {
  /// Creates Active Grid
  const ActiveGrid(
      {Key? key, this.child, this.options = const ActiveGridOptions()})
      : client = null,
        super(key: key);

  /// Creates ActiveGrid with an defined ActiveGridClient
  ///
  /// Used testing to Provide a MockedClient
  @visibleForTesting
  ActiveGrid.withClient({required ActiveGridClient client, this.child, this.options = const ActiveGridOptions()})
      : client = client;

  /// Widget that should be wrapped. Normally this is something like [MaterialApp]
  final Widget? child;

  /// Configuration options for ActiveGrid
  final ActiveGridOptions options;

  /// [ActiveGridClient] to use
  ///
  /// Used for supplying a Mocked Client for testing
  @visibleForTesting
  final ActiveGridClient? client;

  @override
  _ActiveGridState createState() => _ActiveGridState();

  /// Get direct Access to [ActiveGridClient]
  ///
  /// uses [Provider] to return the client
  static ActiveGridClient getClient(BuildContext context,
      {bool listen = true}) {
    return Provider.of<ActiveGridClient>(context, listen: listen);
  }
}

class _ActiveGridState extends State<ActiveGrid> {
  late ActiveGridClient _client;

  @override
  void initState() {
    super.initState();
    _client = widget.client ??
        ActiveGridClient(
            environment: widget.options.environment,
            authentication: widget.options.authentication);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ActiveGridClient>.value(
      value: _client,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }
}
