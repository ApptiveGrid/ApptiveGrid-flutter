part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [CrossReferenceFormComponent]
class CrossReferenceFormWidget extends StatelessWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CrossReferenceFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final CrossReferenceFormComponent component;

  @override
  Widget build(BuildContext context) {
    return _CrossReferenceDropdownButtonFormField<CrossReferenceDataEntity>(
      component: component,
      selectedItemBuilder: (data) => Text(
        data?.value?.toString() ?? '',
      ),
      isSelected: (entityUri) => component.data.entityUri == entityUri,
      onSelected: (entity, selected, state) {
        component.data = entity;
        state.closeOverlay();
        state.requestRebuild();
      },
    );
  }
}
