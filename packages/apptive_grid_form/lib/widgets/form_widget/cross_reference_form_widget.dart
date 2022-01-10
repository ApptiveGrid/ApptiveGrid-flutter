part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [CrossReferenceFormComponent]
class CrossReferenceFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CrossReferenceFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final CrossReferenceFormComponent component;

  @override
  _CrossReferenceFormWidgetState createState() =>
      _CrossReferenceFormWidgetState();
}

class _CrossReferenceFormWidgetState extends State<CrossReferenceFormWidget> {
  Grid? _grid;
  dynamic _error;

  final LinkedScrollControllerGroup _scrollControllerGroup =
      LinkedScrollControllerGroup();
  final _controllers = <String, ScrollController>{};
  ScrollController? _headerController;

  final _filterController = FilterController();

  final _dropdownKey = GlobalKey();

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
    return DropdownButtonFormField<CrossReferenceDataEntity?>(
      key: _dropdownKey,
      isExpanded: true,
      items: _items(),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.95,
      onChanged: (_) {},
      onTap: () {
        _filterController.query = '';
      },
      validator: (value) {
        if (widget.component.required && (value != null)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      selectedItemBuilder: _selectedItems,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        helperMaxLines: 100,
        labelText: widget.component.options.label ?? widget.component.property,
        errorText: _error?.toString(),
      ),
    );
  }

  List<DropdownMenuItem<CrossReferenceDataEntity?>>? _items() {
    if (_error != null || _grid == null) {
      return null;
    } else {
      final localization = ApptiveGridLocalization.of(context)!;
      final searchBox = DropdownMenuItem(
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
              _filterController.query = input;
            },
          ),
        ),
      );

      final headerRow = DropdownMenuItem(
        enabled: false,
        value: null,
        child: HeaderRowWidget(
          fields: _grid!.fields,
          controller: _headerController,
        ),
      );

      final list = DropdownMenuItem<CrossReferenceDataEntity?>(
        value: widget.component.data,
        enabled: false,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: _grid!.rows.length,
          itemBuilder: (context, index) {
            final row = _grid!.rows[index];
            final gridUri = widget.component.data.gridUri;
            final entityUri = EntityUri(
              user: gridUri.user,
              space: gridUri.space,
              grid: gridUri.grid,
              entity: row.id,
            );
            return _RowMenuItem(
              key: ValueKey(widget.component.fieldId + row.id),
              grid: _grid!,
              row: row,
              controller: _controllers[row.id],
              initiallySelected: widget.component.data.entityUri == entityUri,
              filterController: _filterController,
              onSelectionChanged: (_) {
                setState(() {
                  widget.component.data.value =
                      row.entries.first.data.value;
                  widget.component.data.entityUri = entityUri;
                });
                if (_dropdownKey.currentContext != null) {
                  Navigator.pop(_dropdownKey.currentContext!);
                }
              },
            );
          },
        ),
      );
      return [searchBox, headerRow, list];
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
        Text(
          widget.component.data.value?.toString() ?? '',
        ),
      ];
    }
  }
}

class _RowMenuItem extends StatefulWidget {
  const _RowMenuItem({
    Key? key,
    required this.grid,
    required this.row,
    this.controller,
    this.initiallySelected = false,
    this.onSelectionChanged,
    this.filterController,
  }) : super(key: key);

  final Grid grid;
  final GridRow row;
  final ScrollController? controller;
  final FilterController? filterController;

  final bool initiallySelected;
  final void Function(bool)? onSelectionChanged;

  @override
  _RowMenuItemState createState() => _RowMenuItemState();
}

class _RowMenuItemState extends State<_RowMenuItem> {
  late bool _selected;

  late final FilterListener _listener;

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected;
    _listener = () {
      setState(() {
        // Set State to update color
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
    final index = widget.grid.rows
        .where((row) => row.matchesFilter(widget.filterController?.query))
        .toList()
        .indexOf(widget.row);
    return GridRowWidget(
      row: widget.row,
      scrollController: widget.controller,
      selected: _selected,
      onSelectionChanged: widget.onSelectionChanged != null
          ? (selected) {
              widget.onSelectionChanged?.call(selected);
              setState(() {
                _selected = selected;
              });
            }
          : null,
      color:
          index % 2 != 0 ? Theme.of(context).hintColor.withOpacity(0.04) : null,
      filterController: widget.filterController,
    );
  }
}

extension _GridRowX on GridRow {
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
