library active_grid_grid_builder;

import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/active_grid_model.dart';
import 'package:flutter/material.dart';

export 'package:active_grid_core/active_grid_core.dart';

part 'grid_snapshot.dart';

class ActiveGridGridBuilder extends StatefulWidget {
  const ActiveGridGridBuilder(
      {Key key,
      @required this.user,
      @required this.space,
      @required this.grid,
      @required this.builder})
      : super(key: key);

  final String user;
  final String space;
  final String grid;
  final Widget Function(BuildContext, GridSnapshot) builder;

  @override
  ActiveGridGridBuilderState createState() => ActiveGridGridBuilderState();
}

class ActiveGridGridBuilderState extends State<ActiveGridGridBuilder> {
  GridSnapshot _snapshot = GridSnapshot();

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
              _snapshot = GridSnapshot(data: value);
            }))
        .catchError((error) => setState(() {
              _snapshot = GridSnapshot(error: error);
            }));
  }
}
