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
      {Key key, this.child, this.options = const ActiveGridOptions()})
      : super(key: key);

  /// Widget that should be wrapped. Normally this is something like [MaterialApp]
  final Widget child;

  /// Configuration options for ActiveGrid
  final ActiveGridOptions options;

  @override
  _ActiveGridState createState() => _ActiveGridState();
}

class _ActiveGridState extends State<ActiveGrid> {
  ActiveGridClient _client;

  @override
  void initState() {
    super.initState();
    _client = ActiveGridClient(environment: widget.options.environment);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
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
