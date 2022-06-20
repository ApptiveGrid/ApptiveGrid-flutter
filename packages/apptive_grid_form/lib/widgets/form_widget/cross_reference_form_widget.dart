part of apptive_grid_form_widgets;

/// FormComponent Widget to display a FormComponent<[CrossReferenceDataEntity>]
class CrossReferenceFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CrossReferenceFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<CrossReferenceDataEntity> component;

  @override
  State<CrossReferenceFormWidget> createState() =>
      _CrossReferenceFormWidgetState();
}

class _CrossReferenceFormWidgetState extends State<CrossReferenceFormWidget> {
  late final _SelectedRowsNotifier _selectedNotifier;

  @override
  void initState() {
    super.initState();
    _selectedNotifier =
        _SelectedRowsNotifier([widget.component.data.entityUri]);
  }

  @override
  Widget build(BuildContext context) {
    return _CrossReferenceDropdownButtonFormField<CrossReferenceDataEntity>(
      component: widget.component,
      selectedItemBuilder: (data) => Text(
        data?.value?.toString() ?? '',
      ),
      selectedNotifier: _selectedNotifier,
      onSelected: (entity, selected, state) {
        widget.component.data.value = entity.value;
        widget.component.data.entityUri = entity.entityUri;
        _selectedNotifier.entities = [widget.component.data.entityUri];
        state.closeOverlay();
      },
    );
  }
}
