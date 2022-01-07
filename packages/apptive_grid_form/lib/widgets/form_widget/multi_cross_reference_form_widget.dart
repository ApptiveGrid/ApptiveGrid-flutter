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

  final _filterController = FilterController();

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
    return GridRowDropdownButtonFormField<List<CrossReferenceDataEntity>?>(
      isExpanded: true,
      items: _items(),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.95,
      onChanged: (_) {},
      onTap: () {
        _filterController.query = '';
      },
      validator: (value) {
        if (widget.component.required && (value == null || value.isEmpty)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      selectedItemBuilder: _selectedItems,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        helperMaxLines: 100,
        labelText: widget.component.options.label ?? widget.component.property,
        errorText: _error?.toString(),
      ),
    );
  }

  List<GridRowDropdownMenuItem<List<CrossReferenceDataEntity>?>>? _items() {
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
              _filterController.query = input;
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

      final list = GridRowDropdownMenuItem(
        value: widget.component.data.value,
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
              final displayValue = row.entries.first.data.value.toString();
              return _RowMenuItem(
                key: ValueKey(widget.component.fieldId + row.id),
                grid: _grid!,
                row: row,
                controller: _controllers[row.id],
                initiallySelected: widget.component.data.value!
                    .map((entity) => entity.entityUri)
                    .contains(entityUri),
                onSelectionChanged: (selected) {
                  setState(() {
                    if (selected) {
                      widget.component.data.value!.add(
                        CrossReferenceDataEntity(
                          value: displayValue,
                          gridUri: widget.component.data.gridUri,
                          entityUri: entityUri,
                        ),
                      );
                    } else {
                      widget.component.data.value!.removeWhere(
                          (element) => element.entityUri == entityUri);
                    }
                  });
                },
                filterController: _filterController,
              );
            }),
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
          widget.component.data.value!.map((e) => e.value ?? '').join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ];
    }
  }
}
