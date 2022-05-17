part of apptive_grid_form_widgets;

class _CrossReferenceDropdownButtonFormField<T extends DataEntity>
    extends StatefulWidget {
  const _CrossReferenceDropdownButtonFormField({
    Key? key,
    required this.component,
    required this.selectedItemBuilder,
    required this.onSelected,
    this.isSelected,
  })  : assert(
          T == CrossReferenceDataEntity || T == MultiCrossReferenceDataEntity,
        ),
        super(key: key);

  final FormComponent<T> component;

  final Widget Function(T?) selectedItemBuilder;

  final void Function(
    CrossReferenceDataEntity entity,
    bool selected,
    _CrossReferenceDropdownButtonFormFieldState<T> state,
  ) onSelected;

  final bool Function(EntityUri)? isSelected;

  @override
  _CrossReferenceDropdownButtonFormFieldState<T> createState() =>
      _CrossReferenceDropdownButtonFormFieldState<T>();
}

class _CrossReferenceDropdownButtonFormFieldState<T extends DataEntity>
    extends State<_CrossReferenceDropdownButtonFormField<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Grid? _grid;
  dynamic _error;

  final LinkedScrollControllerGroup _scrollControllerGroup =
      LinkedScrollControllerGroup();
  final _controllers = <String, ScrollController>{};
  ScrollController? _headerController;

  final _filterController = FilterController();

  late final GridUri _gridUri;

  final _overlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (T == CrossReferenceDataEntity) {
      _gridUri = (widget.component.data as CrossReferenceDataEntity).gridUri;
    } else if (T == MultiCrossReferenceDataEntity) {
      _gridUri =
          (widget.component.data as MultiCrossReferenceDataEntity).gridUri;
    }
  }

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
        .loadGrid(gridUri: _gridUri)
        .then((value) {
      for (final row in (value.rows ?? [])) {
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

  void closeOverlay() {
    if (_overlayKey.currentContext != null) {
      Navigator.pop(_overlayKey.currentContext!);
    }
  }

  void requestRebuild() {
    setState(() {
      (_overlayKey.currentState as FormFieldState?)
          ?.didChange(widget.component.data.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButtonFormField<dynamic>(
      key: _overlayKey,
      isExpanded: true,
      items: _items(),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.95,
      onChanged: (_) {},
      onTap: () {
        _filterController.query = '';
      },
      validator: (value) {
        if (widget.component.required &&
            ((T == CrossReferenceDataEntity &&
                    (widget.component.data as CrossReferenceDataEntity?)
                            ?.entityUri ==
                        null) ||
                (T == MultiCrossReferenceDataEntity &&
                    (widget.component.data as MultiCrossReferenceDataEntity?)
                            ?.value
                            ?.isEmpty ==
                        true))) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      selectedItemBuilder: _selectedItems,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: widget.component.baseDecoration.copyWith(
        errorText: _error?.toString(),
      ),
    );
  }

  List<DropdownMenuItem<dynamic>>? _items() {
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
          fields: _grid!.fields ?? [],
          controller: _headerController,
        ),
      );

      final list = DropdownMenuItem<dynamic>(
        value: widget.component.data.value,
        enabled: false,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: _grid!.rows?.length ?? 0,
          itemBuilder: (context, index) {
            final row = _grid!.rows![index];
            String path = _gridUri.uri.path;
            final viewsIndex = path.indexOf('/views');
            if (viewsIndex > 0) {
              path = path.substring(0, viewsIndex);
            }
            final entityUri = EntityUri.fromUri(
              '$path/entities/${row.id}',
            );
            return _RowMenuItem(
              key: ValueKey(widget.component.fieldId + row.id),
              grid: _grid!,
              row: row,
              controller: _controllers[row.id],
              initiallySelected: widget.isSelected?.call(entityUri) ?? false,
              onSelectionChanged: (selected) {
                final displayValue = row.entries.first.data.value;
                final entity = CrossReferenceDataEntity(
                  value: displayValue,
                  gridUri: _gridUri,
                  entityUri: entityUri,
                );
                widget.onSelected(entity, selected, this);
              },
              filterController: _filterController,
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
        widget.selectedItemBuilder(widget.component.data),
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
            ?.where((row) => row.matchesFilter(widget.filterController?.query))
            .toList()
            .indexOf(widget.row) ??
        0;
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
