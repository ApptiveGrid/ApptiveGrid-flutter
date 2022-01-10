part of apptive_grid_form_widgets;

/// Widget to display a [GridRow]
/// Multiple of these in a Vertical Layout will display a full Grid
class GridRowWidget extends StatefulWidget {
  /// Creates a new RowWidget
  const GridRowWidget({
    Key? key,
    required this.row,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.scrollController,
    this.selected = false,
    this.onSelectionChanged,
    this.filterController,
  }) : super(key: key);

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

  final bool selected;

  final void Function(bool)? onSelectionChanged;

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

class FilterController {
  final Set<FilterListener> _listeners = {};

  String? _query;

  String? get query => _query;

  set query(String? query) {
    _query = query;
    _notifyListeners();
  }

  void addListener(FilterListener listener) => _listeners.add(listener);

  void removeListener(FilterListener listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

typedef FilterListener = void Function();

/// Widget to display a Header Row for a [Grid] given the grids [fields]
class HeaderRowWidget extends StatelessWidget {
  /// Creates a new RowWidget
  const HeaderRowWidget({
    Key? key,
    required this.fields,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
  }) : super(key: key);

  /// Fields that should be displayed
  final List<GridField> fields;

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
      labels: fields.map((e) => e.name).toList(),
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
    Key? key,
    required this.labels,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
  }) : super(key: key);

  final List<String?> labels;
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

extension GridRowX on GridRow {
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
