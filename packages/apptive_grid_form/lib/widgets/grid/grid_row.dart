part of apptive_grid_form_widgets;

/// Widget to display a [GridRow]
/// Multiple of these in a Vertical Layout will display a full Grid
class GridRowWidget extends StatelessWidget {
  /// Creates a new RowWidget
  const GridRowWidget({
    Key? key,
    required this.row,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
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
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return _GridRow(
      labels: row.entries.map((e) => e.data.value?.toString()).toList(),
      cellSize: cellSize,
      textStyle: textStyle,
      color: color,
      padding: padding,
      controller: controller,
    );
  }
}

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
