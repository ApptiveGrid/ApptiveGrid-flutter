library active_grid_grid_builder;

import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/active_grid_model.dart';
import 'package:flutter/material.dart';

export 'package:active_grid_core/active_grid_core.dart';

/// Builder for building Widgets that use [Grid] as the Data Source
class ActiveGridGridBuilder extends StatefulWidget {
  ///
  const ActiveGridGridBuilder({
    Key key,
    @required this.user,
    @required this.space,
    @required this.grid,
    this.initialData,
    @required this.builder,
  }) : super(key: key);

  final String user;
  final String space;
  final String grid;
  final Grid initialData;
  final Widget Function(BuildContext, AsyncSnapshot<Grid>) builder;

  @override
  ActiveGridGridBuilderState createState() => ActiveGridGridBuilderState();
}

class ActiveGridGridBuilderState extends State<ActiveGridGridBuilder> {
  AsyncSnapshot<Grid> _snapshot;

  @override
  void initState() {
    _snapshot =
        AsyncSnapshot<Grid>.withData(ConnectionState.none, widget.initialData);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reload(listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }

  Future<void> reload({bool listen = false}) {
    return ActiveGrid.getClient(context, listen: listen)
        .loadGrid(user: widget.user, space: widget.space, grid: widget.grid)
        .then((value) => setState(() {
              _snapshot = AsyncSnapshot.withData(ConnectionState.done, value);
            }))
        .catchError((error) => setState(() {
              _snapshot = AsyncSnapshot.withError(ConnectionState.none, error);
            }));
  }
}
