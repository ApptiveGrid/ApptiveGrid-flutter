import 'package:active_grid_core/active_grid_options.dart';
import 'package:active_grid_core/active_grid_network.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ActiveGrid extends StatefulWidget {
  final Widget child;
  final ActiveGridOptions options;

  const ActiveGrid(
      {Key key, this.child, this.options = const ActiveGridOptions()})
      : super(key: key);

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
