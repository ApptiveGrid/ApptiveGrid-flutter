import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/cross_reference/cross_reference_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [FormComponent<CrossReferenceDataEntity>]
class CrossReferenceFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CrossReferenceFormWidget({
    super.key,
    required this.component,
    this.enabled = true,
  });

  /// Component this Widget should reflect
  final FormComponent<CrossReferenceDataEntity> component;

  /// Flag whether the widget is enabled
  final bool enabled;

  @override
  State<CrossReferenceFormWidget> createState() =>
      _CrossReferenceFormWidgetState();
}

class _CrossReferenceFormWidgetState extends State<CrossReferenceFormWidget> {
  late final SelectedRowsNotifier _selectedNotifier;

  @override
  void initState() {
    super.initState();
    _selectedNotifier = SelectedRowsNotifier([widget.component.data.entityUri]);
  }

  @override
  Widget build(BuildContext context) {
    return CrossReferenceDropdownButtonFormField<CrossReferenceDataEntity>(
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
      enabled: widget.enabled,
    );
  }
}
