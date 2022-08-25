import 'dart:convert';
import 'dart:math';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:apptive_grid_form/src/widgets/grid/grid_row.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

/// A [DropdownButtonFormField] to select CrossReference Values
class CrossReferenceDropdownButtonFormField<T extends DataEntity>
    extends StatefulWidget {
  /// Creates a new [CrossReferenceDropdownButtonFormField]
  const CrossReferenceDropdownButtonFormField({
    super.key,
    required this.component,
    required this.selectedItemBuilder,
    required this.onSelected,
    required this.selectedNotifier,
  }) : assert(
          T == CrossReferenceDataEntity || T == MultiCrossReferenceDataEntity,
        );

  /// The [FormComponent] this Widget should reflect
  final FormComponent<T> component;

  /// The [DropdownMenuItem] builder for the selected item
  final Widget Function(T?) selectedItemBuilder;

  /// A Function called when a entity was selected
  final void Function(
    CrossReferenceDataEntity entity,
    bool selected,
    CrossReferenceDropdownButtonFormFieldState<T> state,
  ) onSelected;

  /// A [Notifier] to notify when the selected entity changed
  final SelectedRowsNotifier selectedNotifier;

  @override
  CrossReferenceDropdownButtonFormFieldState<T> createState() =>
      CrossReferenceDropdownButtonFormFieldState<T>();
}

/// The [State] of a [CrossReferenceDropdownButtonFormField] used to close the overlay after [onSelected] was called
class CrossReferenceDropdownButtonFormFieldState<T extends DataEntity>
    extends State<CrossReferenceDropdownButtonFormField<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Grid? _grid;
  dynamic _error;

  final LinkedScrollControllerGroup _scrollControllerGroup =
      LinkedScrollControllerGroup();
  final _controllers = <String, ScrollController>{};
  ScrollController? _headerController;

  final _filterController = TextEditingController();

  late final Uri _gridUri;

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
      controller.dispose(); // coverage:ignore-line
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
        .loadGrid(uri: _gridUri, loadEntities: false)
        .then((value) {
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

  /// Closes the Dropdown overlay
  void closeOverlay() {
    if (_overlayKey.currentContext != null) {
      Navigator.pop(_overlayKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButtonFormField<dynamic>(
      key: _overlayKey,
      isExpanded: true,
      items: _items(),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.95,
      onChanged: (_) {}, // coverage:ignore-line
      onTap: () {
        _filterController.text = '';
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
      value: () {
        if (widget.component.data.value == null ||
            (widget.component.data.value is Iterable &&
                widget.component.data.value.isEmpty) ||
            (widget.component.data.value is String &&
                widget.component.data.value.isEmpty)) {
          return null;
        } else {
          return widget.component.data.value;
        }
      }.call(),
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
        value: 'SEARCH',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _filterController,
            decoration: InputDecoration(
              icon: const Icon(Icons.search),
              hintText: localization.crossRefSearch,
            ),
          ),
        ),
      );

      final headerRow = DropdownMenuItem(
        enabled: false,
        value: 'HEADER',
        child: HeaderRowWidget(
          grid: _grid,
          controller: _headerController,
        ),
      );

      late final DropdownMenuItem list;
      if (_grid != null) {
        list = DropdownMenuItem<dynamic>(
          value: widget.component.data.value ?? '',
          enabled: false,
          child: _CrossReferenceSelectionGrid(
            controller: _filterController,
            scrollControllerGroup: _scrollControllerGroup,
            grid: _grid!,
            selectedNotifier: widget.selectedNotifier,
            onSelected: (row, selected) {
              final displayValue = row.entries
                  .cast<GridEntry?>()
                  .firstWhere(
                    (element) =>
                        element?.field.type != DataType.crossReference &&
                        element?.field.type != DataType.multiCrossReference,
                    orElse: () => null,
                  )
                  ?.data
                  .value
                  ?.toString();
              final entity = CrossReferenceDataEntity(
                value: displayValue,
                gridUri: _gridUri,
                entityUri: row.links[ApptiveLinkType.self]?.uri,
              );
              widget.onSelected(entity, selected, this);
              setState(() {});
            },
          ),
        );
      }
      return [searchBox, headerRow, if (_grid != null) list];
    }
  }

  List<Widget> _selectedItems(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;

    if (widget.component.data.value == null ||
        (widget.component.data.value is Iterable &&
            widget.component.data.value.isEmpty) ||
        (widget.component.data.value is String &&
            widget.component.data.value.isEmpty)) {
      return [];
    }
    final pleaseSelect = Text(localization.selectEntry);
    return [
      ...[pleaseSelect, pleaseSelect],
      widget.selectedItemBuilder(widget.component.data),
    ];
  }
}

class _CrossReferenceSelectionGrid extends StatefulWidget {
  const _CrossReferenceSelectionGrid({
    required this.controller,
    required this.scrollControllerGroup,
    required this.grid,
    required this.selectedNotifier,
    required this.onSelected,
  });

  final TextEditingController controller;
  final LinkedScrollControllerGroup scrollControllerGroup;
  final Grid grid;
  final SelectedRowsNotifier selectedNotifier;
  final Function(GridRow, bool) onSelected;

  @override
  State<_CrossReferenceSelectionGrid> createState() =>
      _CrossReferenceSelectionGridState();
}

class _CrossReferenceSelectionGridState
    extends State<_CrossReferenceSelectionGrid> {
  late ApptiveGridClient _client;
  List<GridRow>? _rows;
  final Map<String, ScrollController> _scrollControllers = {};
  dynamic _error;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_loadRows);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
    if (_rows == null) {
      _loadRows();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_loadRows);
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadRows() async {
    setState(() {
      _error = null;
    });

    final entitiesLink = widget.grid.links[ApptiveLinkType.query];
    if (entitiesLink != null && widget.grid.fields != null) {
      final query = widget.controller.text;
      final rows = await _client
          .performApptiveLink<List<GridRow>>(
        link: entitiesLink,
        queryParameters: {
          if (query.isNotEmpty) 'matching': query,
        },
        parseResponse: (response) async {
          final entities = jsonDecode(response.body)['entities'] as List;
          final newRows = <GridRow>[];
          for (final entity in entities) {
            final entries = <GridEntry>[];
            final fields = entity['fields'] as List;
            for (int fieldIndex = 0;
                fieldIndex <
                    min(
                      widget.grid.fields!.length,
                      fields.length,
                    );
                fieldIndex++) {
              final field = widget.grid.fields![fieldIndex];
              final dataEntity = DataEntity.fromJson(
                json: fields[fieldIndex],
                field: field,
              );
              entries.add(
                GridEntry(
                  field,
                  dataEntity,
                ),
              );
            }
            final row = GridRow(
              id: entity['_id'],
              entries: entries,
              links: linkMapFromJson(entity['_links']),
            );
            newRows.add(row);
            if (_scrollControllers[row.id] == null) {
              _scrollControllers[row.id] =
                  widget.scrollControllerGroup.addAndGet();
            }
          }
          return newRows;
        },
      )
          .catchError((error) {
        if (mounted) {
          setState(() {
            _error = error;
            _rows = null;
          });
        }
      });
      if (mounted) {
        setState(() {
          _rows = rows;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _rows = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_error != null) {
      return Text(
        _error is http.Response ? _error.body : _error!.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }
    if (_rows == null) {
      return const LinearProgressIndicator();
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: _rows?.length ?? 0,
      itemBuilder: (context, index) {
        final row = _rows![index];
        return _RowMenuItem(
          row: row,
          selectedNotifier: widget.selectedNotifier,
          onSelectionChanged: widget.onSelected,
          controller: _scrollControllers[row.id],
          color: index % 2 != 0
              ? Theme.of(context).hintColor.withOpacity(0.04)
              : null,
        );
      },
    );
  }
}

class _RowMenuItem extends StatefulWidget {
  const _RowMenuItem({
    required this.row,
    required this.selectedNotifier,
    this.onSelectionChanged,
    required this.color,
    this.controller,
  });

  final GridRow row;
  final ScrollController? controller;
  final SelectedRowsNotifier selectedNotifier;

  final void Function(GridRow, bool)? onSelectionChanged;
  final Color? color;

  @override
  State<_RowMenuItem> createState() => _RowMenuItemState();
}

class _RowMenuItemState extends State<_RowMenuItem> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedNotifier.entities
        .contains(widget.row.links[ApptiveLinkType.self]?.uri ?? Uri());
    widget.selectedNotifier.addListener(_updateSelected);
  }

  @override
  void dispose() {
    widget.selectedNotifier.removeListener(_updateSelected);
    super.dispose();
  }

  void _updateSelected() {
    setState(() {
      _selected = widget.selectedNotifier.entities
          .contains(widget.row.links[ApptiveLinkType.self]?.uri ?? Uri());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridRowWidget(
      row: widget.row,
      scrollController: widget.controller,
      selected: _selected,
      onSelectionChanged: (selected) {
        widget.onSelectionChanged?.call(widget.row, selected);
      },
      color: widget.color,
    );
  }
}

/// A Notifier that handles the selection of rows.
class SelectedRowsNotifier extends ChangeNotifier {
  /// Creates a new [SelectedRowsNotifier] with the currently selected [entities]
  SelectedRowsNotifier(List<Uri?> entities) : _entities = entities;

  List<Uri?> _entities;

  /// Returns the currently selected [entities].
  List<Uri?> get entities => _entities;

  /// Sets the currently selected [entities].
  set entities(List<Uri?> entities) {
    _entities = entities;
    notifyListeners();
  }
}
