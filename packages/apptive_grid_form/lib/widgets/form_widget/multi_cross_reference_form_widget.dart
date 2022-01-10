part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [MultiCrossReferenceFormComponent]
class MultiCrossReferenceFormWidget extends StatelessWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const MultiCrossReferenceFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final MultiCrossReferenceFormComponent component;

  @override
  Widget build(BuildContext context) {
    return CrossReferenceDropdownButtonFormField<MultiCrossReferenceDataEntity>(
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
