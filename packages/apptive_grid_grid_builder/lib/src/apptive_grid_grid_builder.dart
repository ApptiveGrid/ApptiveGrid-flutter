import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Builder for building Widgets that use [Grid] as the Data Source
class ApptiveGridGridBuilder extends StatefulWidget {
  /// Creates a Builder Widget
  const ApptiveGridGridBuilder({
    super.key,
    required this.uri,
    this.initialData,
    this.sorting,
    this.filter,
    required this.builder,
  });

  /// Uri of the grid that should be used
  final Uri uri;

  /// Initial [Grid] data that should be shown
  final Grid? initialData;

  /// Callback that is used to build the widget
  final Widget Function(BuildContext, AsyncSnapshot<Grid?>) builder;

  /// List of [ApptiveGridSorting] that should be applied
  final List<ApptiveGridSorting>? sorting;

  /// [ApptiveGridFilter] that should be used to filter entities
  final ApptiveGridFilter? filter;

  @override
  ApptiveGridGridBuilderState createState() => ApptiveGridGridBuilderState();
}

/// State of a [ApptiveGridGridBuilder] Widget
class ApptiveGridGridBuilderState extends State<ApptiveGridGridBuilder> {
  late AsyncSnapshot<Grid?> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot =
        AsyncSnapshot<Grid?>.withData(ConnectionState.none, widget.initialData);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reload(listen: true);
  }

  @override
  void didUpdateWidget(covariant ApptiveGridGridBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.sorting, widget.sorting) ||
        oldWidget.filter != widget.filter ||
        oldWidget.uri != widget.uri) {
      reload(listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }

  /// Call this to reload the data.
  ///
  /// For example used when doing pull to refresh
  Future<void> reload({
    bool listen = false,
  }) {
    return ApptiveGrid.getClient(context, listen: listen)
        .loadGrid(
          uri: widget.uri,
          sorting: widget.sorting,
          filter: widget.filter,
        )
        .then(
          (value) => setState(() {
            _snapshot = AsyncSnapshot.withData(ConnectionState.done, value);
          }),
        )
        .catchError(
          (error) => setState(() {
            _snapshot = AsyncSnapshot.withError(ConnectionState.none, error);
          }),
        );
  }
}
