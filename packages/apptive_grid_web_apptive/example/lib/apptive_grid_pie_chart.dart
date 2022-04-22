// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_web_apptive/apptive_grid_web_apptive.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ApptiveGridPieChart extends StatefulWidget {
  const ApptiveGridPieChart({Key? key, required this.grid}) : super(key: key);

  final Grid grid;

  @override
  _ApptiveGridPieChartState createState() => _ApptiveGridPieChartState();
}

class _ApptiveGridPieChartState extends State<ApptiveGridPieChart> {
  GridField? _field;
  late bool _needsSelection;
  late bool _isValid;

  @override
  void initState() {
    super.initState();

    _setUp();
  }

  void _setUp() {
    final enumFields = widget.grid.fields
            ?.where((element) => element.type == DataType.singleSelect)
            .toList() ??
        [];
    if (enumFields.isNotEmpty) {
      _isValid = true;
      _needsSelection = enumFields.length > 1;
      if (!_needsSelection) {
        _field = enumFields[0];
      }
    } else {
      _isValid = false;
    }
  }

  @override
  void didUpdateWidget(covariant ApptiveGridPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      final newFieldIds = widget.grid.fields?.map((e) => e.id);
      if ((newFieldIds ?? []).contains(_field?.id)) {
        _field = widget.grid.fields!
            .firstWhere((element) => element.id == _field?.id);
      } else {
        if (_field != null && !(newFieldIds ?? []).contains(_field?.id)) {
          _field = null;
        }
        _setUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      return Center(
        child: Text('You need a Column with a SingleSelect'),
      );
    } else {
      return ListView(
        shrinkWrap: true,
        children: [
          if (_needsSelection)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FieldSelector(
                label: 'Data',
                onSelected: (value) {
                  setState(() {
                    _field = value;
                  });
                },
                grid: widget.grid,
                value: _field,
                validator: (field) => field.type == DataType.singleSelect,
              ),
            ),
          if (_field != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _field!.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PieChart(
                    dataMap: _calculateDataMap(),
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }
  }

  Map<String, double> _calculateDataMap() {
    final rows = widget.grid.rows;

    final enumValues = (rows?[0]
            .entries
            .firstWhere((element) => element.field.id == _field?.id)
            .data as EnumDataEntity)
        .options;

    return Map.fromEntries(
      enumValues.map(
        (value) => MapEntry(
          value,
          (rows ?? [])
              .where(
                (row) =>
                    (row.entries
                            .firstWhere((entry) => entry.field.id == _field?.id)
                            .data as EnumDataEntity)
                        .value ==
                    value,
              )
              .length
              .toDouble(),
        ),
      ),
    );
  }
}

class FieldSelector extends StatefulWidget {
  const FieldSelector({
    Key? key,
    required this.label,
    required this.onSelected,
    required this.grid,
    this.value,
    required this.validator,
  }) : super(key: key);

  final String label;
  final Grid grid;
  final Function(GridField?) onSelected;
  final GridField? value;
  final bool Function(GridField) validator;

  @override
  _FieldSelectorState createState() => _FieldSelectorState();
}

class _FieldSelectorState extends State<FieldSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Text(widget.label),
        ),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<GridField?>(
            value: widget.value,
            validator: (value) {
              if (value == null) {
                return 'Select a Column that should be displayed in the pie chart.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorMaxLines: 3,
            ),
            autovalidateMode: AutovalidateMode.always,
            onChanged: widget.onSelected,
            items: widget.grid.fields
                ?.where(widget.validator)
                .map<DropdownMenuItem<GridField>>(
                  (e) => DropdownMenuItem<GridField>(
                    value: e,
                    child: Text(e.name),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
