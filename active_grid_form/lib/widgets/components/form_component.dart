part of active_grid_form_widgets;

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [model.FormType] is found
Widget fromModel(model.FormComponent component) {
  switch (component.type) {
    case model.FormType.text:
      return FormComponentText(
        component: component,
      );
    case model.FormType.dateTime:
      return FormComponentDateTime(
        component: component,
      );
    case model.FormType.date:
      return FormComponentDate(
        component: component,
      );
    case model.FormType.integer:
      return FormComponentNumber(
        component: component,
      );
    case model.FormType.checkbox:
      return FormComponentCheckBox(
        component: component,
      );
    default:
      throw ArgumentError('No Widget found for component $component. Please make sure you are you using the latest version of this package?');
  }
}
