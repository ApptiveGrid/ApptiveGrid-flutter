part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [MultiCrossReferenceFormComponent]
class MultiCrossReferenceFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const MultiCrossReferenceFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final MultiCrossReferenceFormComponent component;

  @override
  _MultiCrossReferenceFormWidgetState createState() =>
      _MultiCrossReferenceFormWidgetState();
}

class _MultiCrossReferenceFormWidgetState
    extends State<MultiCrossReferenceFormWidget> {
  Grid? _grid;
  dynamic _error;

  final LinkedScrollControllerGroup _scrollControllerGroup =
      LinkedScrollControllerGroup();
  final _controllers = <String, ScrollController>{};
  ScrollController? _headerController;
  final _keys = <String, GlobalKey<_RowMenuItemState>>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_grid == null && _error == null) {
      _loadGrid();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _headerController?.dispose();
    _headerController = null;
    super.dispose();
  }

  void _loadGrid() {
    setState(() {
      _error = null;
      _grid = null;
    });
    ApptiveGrid.getClient(context, listen: false)
        .loadGrid(gridUri: widget.component.data.gridUri)
        .then((value) {
      for (final row in value.rows) {
        _controllers[row.id]?.dispose();
        _controllers[row.id] = _scrollControllerGroup.addAndGet();

        _keys[row.id] ??= GlobalKey();
      }
      _headerController?.dispose();
      _headerController = _scrollControllerGroup.addAndGet();
      setState(() {
        _error = null;
        _grid = value;
      });
    }).catchError((error) {
      setState(() {
        _error = error;
        _grid = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridRowDropdownButtonFormField<GridRowDropdownDataItem?>(
      isExpanded: true,
      items: _items(),
      onChanged: (newValue) {
        if (newValue?.entityUri != null) {
          setState(() {
            widget.component.data.value = [
              CrossReferenceDataEntity(
                value: newValue?.displayValue,
                gridUri: widget.component.data.gridUri,
                entityUri: newValue?.entityUri,
              )
            ];
          });
        }
      },
      validator: (value) {
        if (widget.component.required &&
            (value?.entityUri == null || value?.displayValue == null)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      selectedItemBuilder: _selectedItems,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value != null &&
              widget.component.data.value!.isNotEmpty
          ? GridRowDropdownDataItem(
              entityUri: widget.component.data.value!.first.entityUri,
              displayValue: widget.component.data.value!.first.value,
            )
          : null,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        helperMaxLines: 100,
        labelText: widget.component.options.label ?? widget.component.property,
        errorText: _error?.toString(),
      ),
    );
  }

  List<GridRowDropdownMenuItem<GridRowDropdownDataItem?>>? _items() {
    if (_error != null || _grid == null) {
      return null;
    } else {
      final localization = ApptiveGridLocalization.of(context)!;
      final searchBox = GridRowDropdownMenuItem(
        enabled: false,
        value: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              icon: const Icon(Icons.search),
              hintText: localization.crossRefSearch,
              border: InputBorder.none,
            ),
            onChanged: (input) {
              for (final key in _keys.values) {
                key.currentState?.updateFilter(input);
              }
            },
          ),
        ),
      );

      final headerRow = GridRowDropdownMenuItem(
        enabled: false,
        value: null,
        child: HeaderRowWidget(
          fields: _grid!.fields,
          controller: _headerController,
        ),
      );

      final items = _grid!.rows.map((row) {
        final gridUri = widget.component.data.gridUri;
        final entityUri = EntityUri(
          user: gridUri.user,
          space: gridUri.space,
          grid: gridUri.grid,
          entity: row.id,
        );
        return GridRowDropdownMenuItem(
          value: GridRowDropdownDataItem(
            entityUri: entityUri,
            displayValue: row.entries.first.data.value.toString(),
          ),
          child: _RowMenuItem(
            key: _keys[row.id],
            grid: _grid!,
            row: row,
            controller: _controllers[row.id],
          ),
        );
      }).toList();
      return [searchBox, headerRow, ...items];
    }
  }

  List<Widget> _selectedItems(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;
    if (_error != null) {
      return [
        const Center(
          child: Text('ERROR'),
        )
      ];
    } else if (_grid == null) {
      return [
        Center(
          child: Text(localization.loadingGrid),
        )
      ];
    } else {
      final pleaseSelect = Text(localization.selectEntry);
      return [
        ...[pleaseSelect, pleaseSelect],
        ..._grid!.rows
            .map(
              (row) => Text(
                row.entries.first.data.value?.toString() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
            .toList()
      ];
    }
  }
}
