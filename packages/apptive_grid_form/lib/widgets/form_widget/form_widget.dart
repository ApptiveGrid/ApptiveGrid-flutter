part of apptive_grid_form_widgets;

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [DataType] is found
Widget fromModel(FormComponent component) {
  switch (component.data.runtimeType) {
    case StringDataEntity:
      return TextFormWidget(
        component: component as StringFormComponent,
      );
    case DateTimeDataEntity:
      return DateTimeFormWidget(
        component: component as DateTimeFormComponent,
      );
    case DateDataEntity:
      return DateFormWidget(
        component: component as DateFormComponent,
      );
    case IntegerDataEntity:
      return IntegerFormWidget(
        component: component as IntegerFormComponent,
      );
    case DecimalDataEntity:
      return DecimalFormWidget(
        component: component as DecimalFormComponent,
      );
    case BooleanDataEntity:
      return CheckBoxFormWidget(
        component: component as BooleanFormComponent,
      );
    case EnumDataEntity:
      return EnumFormWidget(
        component: component as EnumFormComponent,
      );
    case CrossReferenceDataEntity:
      return CrossReferenceFormWidget(
        component: component as CrossReferenceFormComponent,
      );
    case AttachmentDataEntity:
      return AttachmentFormWidget(
        component: component as AttachmentFormComponent,
      );
    case EnumCollectionDataEntity:
      return EnumCollectionFormWidget(
        component: component as EnumCollectionFormComponent,
      );
    case GeolocationDataEntity:
      return GeolocationFormWidget(
        component: component as GeolocationFormComponent,
      );
    case MultiCrossReferenceDataEntity:
      return MultiCrossReferenceFormWidget(
        component: component as MultiCrossReferenceFormComponent,
      );
    case UserReferenceDataEntity:
      return const UserReferenceFormWidget();
    default:
      throw ArgumentError(
        'No Widget found for component $component. Please make sure you are you using the latest version of this package?',
      );
  }
}
