part of apptive_grid_form_widgets;

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [DataType] is found
Widget fromModel(FormComponent component) {
  switch (component.field.type) {
    case DataType.text:
      return TextFormWidget(
        component: component.cast<StringDataEntity>(),
      );
    case DataType.dateTime:
      return DateTimeFormWidget(
        component: component.cast<DateTimeDataEntity>(),
      );
    case DataType.date:
      return DateFormWidget(
        component: component.cast<DateDataEntity>(),
      );
    case DataType.integer:
      return IntegerFormWidget(
        component: component.cast<IntegerDataEntity>(),
      );
    case DataType.decimal:
      return DecimalFormWidget(
        component: component.cast<DecimalDataEntity>(),
      );
    case DataType.checkbox:
      return CheckBoxFormWidget(
        component: component.cast<BooleanDataEntity>(),
      );
    case DataType.singleSelect:
      return EnumFormWidget(
        component: component.cast<EnumDataEntity>(),
      );
    case DataType.crossReference:
      return CrossReferenceFormWidget(
        component: component.cast<CrossReferenceDataEntity>(),
      );
    case DataType.attachment:
      return AttachmentFormWidget(
        component: component.cast<AttachmentDataEntity>(),
      );
    case DataType.enumCollection:
      return EnumCollectionFormWidget(
        component: component.cast<EnumCollectionDataEntity>(),
      );
    case DataType.geolocation:
      return GeolocationFormWidget(
        component: component.cast<GeolocationDataEntity>(),
      );
    case DataType.multiCrossReference:
      return MultiCrossReferenceFormWidget(
        component: component.cast<MultiCrossReferenceDataEntity>(),
      );
    // ignore: deprecated_member_use
    case DataType.userReference:
    // ignore: no_duplicate_case_values
    case DataType.createdBy:
      return const CreatedByFormWidget();
    case DataType.user:
      return UserFormWidget(
        component: component.cast<UserDataEntity>(),
      );
  }
}
