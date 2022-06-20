part of apptive_grid_form_widgets;

/// Widget to display a [GridRow]
/// Multiple of these in a Vertical Layout will display a full Grid
class GridRowWidget extends StatefulWidget {
  /// Creates a new RowWidget
  const GridRowWidget({
    super.key,
    required this.row,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.scrollController,
    this.selected = false,
    this.onSelectionChanged,
    this.filterController,
  });

  /// Row to be displayed
  final GridRow row;

  /// Size of the cell. [cellSize.width] will be used as the width of each cell [cellSize.height] will be used as the height of the complete row
  /// defaults to Size(150, 50)
  final Size cellSize;

  /// Text Style for the entries
  final TextStyle? textStyle;

  /// Background color of the row
  final Color? color;

  /// Padding of the row.
  /// defaults to a horizontal Padding of 16
  final EdgeInsets padding;

  /// ScrollController handling the horizontal scroll of the row
  /// It is recommended that this controller is part of a [LinkedScrollControllerGroup] to sync scrolling across the whole grid representation
  final ScrollController? scrollController;

  /// Determines if the current row is selected.
  /// If it is selected there will be a Overlay in the App Primary Color on this Widget
  final bool selected;

  /// Called when the Row is clicked.
  /// Will be called with ![selected]
  final void Function(bool)? onSelectionChanged;

  /// The FilterController that determines if this row should be shown
  final FilterController? filterController;

  @override
  State<GridRowWidget> createState() => _GridRowWidgetState();
}

class _GridRowWidgetState extends State<GridRowWidget> {
  late final FilterListener _listener;

  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = widget.row.matchesFilter(widget.filterController?.query);
    _listener = () {
      final visible = widget.row.matchesFilter(widget.filterController?.query);
      setState(() {
        _visible = visible;
      });
    };
    widget.filterController?.addListener(_listener);
  }

  @override
  void dispose() {
    widget.filterController?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return const SizedBox();
    }
    final selectedColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: widget.onSelectionChanged != null
          ? () => widget.onSelectionChanged!.call(!widget.selected)
          : null,
      child: DecoratedBox(
        decoration: widget.selected
            ? BoxDecoration(
                color: selectedColor.withOpacity(0.3),
              )
            : const BoxDecoration(),
        child: _GridRow(
          id: widget.row.id,
          labels:
              widget.row.entries.map((e) => e.data.value?.toString()).toList(),
          cellSize: widget.cellSize,
          textStyle: widget.textStyle,
          color: widget.color,
          padding: widget.padding,
          controller: widget.scrollController,
        ),
      ),
    );
  }
}

/// Controller to notify [FilterListener]s when a Filter changed so that [GridRowWidget]s can be shown/hidden
class FilterController {
  final Set<FilterListener> _listeners = {};

  String? _query;

  /// Returns the current filter query
  String? get query => _query;

  /// Setting the query will notify all registered [FilterListener]s
  set query(String? query) {
    _query = query;
    _notifyListeners();
  }

  /// Adds a [FilterListener]
  void addListener(FilterListener listener) => _listeners.add(listener);

  /// Removes a [FilterListener]
  void removeListener(FilterListener listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// Listener invoked when [FilterController.query] changes
typedef FilterListener = void Function();

/// Widget to display a Header Row for a [grid]
class HeaderRowWidget extends StatelessWidget {
  /// Creates a new RowWidget
  const HeaderRowWidget({
    super.key,
    required this.grid,
    @Deprecated('Fields are accessed through grid') List<GridField>? fields,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
  });

  /// Grid this shows the headers for
  final Grid? grid;

  /// Fields that should be displayed
  @Deprecated('Fields are accessed through [grid]')
  List<GridField> get fields => grid?.fields ?? [];

  /// Size of the cell. [cellSize.width] will be used as the width of each cell [cellSize.height] will be used as the height of the complete row
  /// defaults to Size(150, 50)
  final Size cellSize;

  /// Text Style for the entries
  /// Defaults to [FontWeight.bold] and a text color visible on the primaryColor of the App Theme
  final TextStyle? textStyle;

  /// Background color of the row
  /// Defaults to the primaryColor of the App Theme
  final Color? color;

  /// Padding of the row.
  /// defaults to a horizontal Padding of 16
  final EdgeInsets padding;

  /// ScrollController handling the horizontal scroll of the row
  /// It is recommended that this controller is part of a [LinkedScrollControllerGroup] to sync scrolling across the whole grid representation
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _GridRow(
      id: grid?.id ?? 'grid',
      labels: grid?.fields?.map((e) => e.name).toList() ?? [],
      cellSize: cellSize,
      textStyle: textStyle ??
          TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryTextTheme.headline1!.color,
          ),
      color: color ?? theme.primaryColor,
      padding: padding,
      controller: controller,
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.labels,
    required this.id,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
  });

  final List<String?> labels;
  final String id;
  final Size cellSize;
  final TextStyle? textStyle;
  final Color? color;
  final EdgeInsets padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cellSize.height,
      padding: padding,
      color: color,
      child: SingleChildScrollView(
        key: ValueKey(id),
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: labels
              .map(
                (label) => SizedBox(
                  width: cellSize.width,
                  child: Text(
                    label ?? '',
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Extension for [GridRow]
extension GridRowX on GridRow {
  /// Checks if a [GridRow] matches a given [filter]
  /// This will check if there is a [GridEntry] where the corresponding [DataEntity.schemaValue] contains [filter].
  /// This check is performed case insensitive
  bool matchesFilter(String? filter) {
    if (filter == null || filter.isEmpty) return true;

    final filterResult = entries.where(
      (entry) =>
          entry.data.schemaValue
              ?.toString()
              .toLowerCase()
              .contains(filter.toLowerCase()) ??
          false,
    );
    return filterResult.isNotEmpty;
  }
}
