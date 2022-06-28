part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [FormComponent<MultiCrossReferenceDataEntity>]
class MultiCrossReferenceFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const MultiCrossReferenceFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<MultiCrossReferenceDataEntity> component;

  @override
  State<MultiCrossReferenceFormWidget> createState() =>
      _MultiCrossReferenceFormWidgetState();
}

class _MultiCrossReferenceFormWidgetState
    extends State<MultiCrossReferenceFormWidget> {
  late final _SelectedRowsNotifier _selectedNotifier;

  @override
  void initState() {
    super.initState();
    _selectedNotifier = _SelectedRowsNotifier(
      widget.component.data.value?.map((e) => e.entityUri).toList() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _CrossReferenceDropdownButtonFormField<
        MultiCrossReferenceDataEntity>(
      component: widget.component,
      selectedItemBuilder: (data) => Text(
        data!.value!.map((e) => e.value ?? '').join(', '),
      ),
      selectedNotifier: _selectedNotifier,
      onSelected: (entity, selected, state) {
        if (selected) {
          widget.component.data.value!.add(
            entity,
          );
        } else {
          widget.component.data.value!.removeWhere(
            (element) => element.entityUri == entity.entityUri,
          );
        }
        _selectedNotifier.entities =
            widget.component.data.value?.map((e) => e.entityUri).toList() ?? [];
      },
    );
  }
}
