part of apptive_grid_form_widgets;

/// FormComponent Widget to display a FormComponent<[MultiCrossReferenceDataEntity>]
class MultiCrossReferenceFormWidget extends StatelessWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const MultiCrossReferenceFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<MultiCrossReferenceDataEntity> component;

  @override
  Widget build(BuildContext context) {
    return _CrossReferenceDropdownButtonFormField<
        MultiCrossReferenceDataEntity>(
      component: component,
      selectedItemBuilder: (data) => Text(
        data!.value!.map((e) => e.value ?? '').join(', '),
      ),
      isSelected: (entityUri) => component.data.value!
          .map((entity) => entity.entityUri)
          .contains(entityUri),
      onSelected: (entity, selected, state) {
        if (selected) {
          component.data.value!.add(
            entity,
          );
        } else {
          component.data.value!.removeWhere(
            (element) => element.entityUri == entity.entityUri,
          );
        }
        state.requestRebuild();
      },
    );
  }
}
