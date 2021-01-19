part of active_grid_form_widgets;

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [model.DataType] is found
Widget fromModel(model.FormComponent component) {
  switch (component.type) {
    case model.DataType.text:
      return FormComponentText(
        component: component,
      );
    case model.DataType.dateTime:
      return FormComponentDateTime(
        component: component,
      );
    case model.DataType.date:
      return FormComponentDate(
        component: component,
      );
    case model.DataType.integer:
      return FormComponentNumber(
        component: component,
      );
    case model.DataType.checkbox:
      return FormComponentCheckBox(
        component: component,
      );
    default:
      throw ArgumentError(
          'No Widget found for component $component. Please make sure you are you using the latest version of this package?');
  }
}
