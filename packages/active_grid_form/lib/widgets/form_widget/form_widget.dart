part of active_grid_form_widgets;

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [DataType] is found
Widget fromModel(FormComponent component) {
  switch (component.data.runtimeType) {
    case StringDataEntity:
      return TextFormWidget(
        component: component,
      );
    case DateTimeDataEntity:
      return DateTimeFormWidget(
        component: component,
      );
    case DateDataEntity:
      return DateFormWidget(
        component: component,
      );
    case IntegerDataEntity:
      return NumberFormWidget(
        component: component,
      );
    case BooleanDataEntity:
      return CheckBoxFormWidget(
        component: component,
      );
    case EnumDataEntity:
      return EnumFormWidget(
        component: component,
      );
    default:
      throw ArgumentError(
          'No Widget found for component $component. Please make sure you are you using the latest version of this package?');
  }
}
