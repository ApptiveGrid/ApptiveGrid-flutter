import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

/// Widget to display a [GridRow]
/// Multiple of these in a Vertical Layout will display a full Grid
class GridRowWidget extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: onSelectionChanged != null
          ? () => onSelectionChanged!.call(!selected)
          : null,
      child: DecoratedBox(
        decoration: selected
            ? BoxDecoration(
                color: selectedColor.withOpacity(0.3),
              )
            : const BoxDecoration(),
        child: _GridRow(
          id: row.id,
          labels: row.entries.map((e) => e.data.value?.toString()).toList(),
          cellSize: cellSize,
          textStyle: textStyle,
          color: color,
          padding: padding,
          controller: scrollController,
        ),
      ),
    );
  }
}

/// Widget to display a Header Row for a [grid]
class HeaderRowWidget extends StatelessWidget {
  /// Creates a new RowWidget
  const HeaderRowWidget({
    super.key,
    required this.grid,
    this.cellSize = const Size(150, 50),
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
  });

  /// Grid this shows the headers for
  final Grid? grid;

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
            color: theme.primaryTextTheme.displayLarge!.color,
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
