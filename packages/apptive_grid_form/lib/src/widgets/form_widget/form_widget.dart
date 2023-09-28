import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [DataType] is found
Widget fromModel(FormComponent component, {bool enabled = true}) {
  switch (component.field.type) {
    case DataType.text:
      return TextFormWidget(
        component: component.cast<StringDataEntity>(),
        enabled: enabled,
      );
    case DataType.dateTime:
      return DateTimeFormWidget(
        component: component.cast<DateTimeDataEntity>(),
        enabled: enabled,
      );
    case DataType.date:
      return DateFormWidget(
        component: component.cast<DateDataEntity>(),
        enabled: enabled,
      );
    case DataType.integer:
      return IntegerFormWidget(
        component: component.cast<IntegerDataEntity>(),
        enabled: enabled,
      );
    case DataType.decimal:
      return DecimalFormWidget(
        component: component.cast<DecimalDataEntity>(),
        enabled: enabled,
      );
    case DataType.checkbox:
      return CheckBoxFormWidget(
        component: component.cast<BooleanDataEntity>(),
        enabled: enabled,
      );
    case DataType.singleSelect:
      return EnumFormWidget(
        component: component.cast<EnumDataEntity>(),
        enabled: enabled,
      );
    case DataType.crossReference:
      return CrossReferenceFormWidget(
        component: component.cast<CrossReferenceDataEntity>(),
        enabled: enabled,
      );
    case DataType.attachment:
      return AttachmentFormWidget(
        component: component.cast<AttachmentDataEntity>(),
        enabled: enabled,
      );
    case DataType.enumCollection:
      return EnumCollectionFormWidget(
        component: component.cast<EnumCollectionDataEntity>(),
        enabled: enabled,
      );
    case DataType.geolocation:
      return GeolocationFormWidget(
        component: component.cast<GeolocationDataEntity>(),
        enabled: enabled,
      );
    case DataType.multiCrossReference:
      return MultiCrossReferenceFormWidget(
        component: component.cast<MultiCrossReferenceDataEntity>(),
        enabled: enabled,
      );
    case DataType.user:
      return UserFormWidget(
        component: component.cast<UserDataEntity>(),
        enabled: enabled,
      );
    case DataType.currency:
      return CurrencyFormWidget(
        component: component.cast<CurrencyDataEntity>(),
        enabled: enabled,
      );
    case DataType.uri:
      return UriFormWidget(
        component: component.cast<UriDataEntity>(),
        enabled: enabled,
      );
    case DataType.email:
      return EmailFormWidget(
        component: component.cast<EmailDataEntity>(),
        enabled: enabled,
      );
    case DataType.phoneNumber:
      return PhoneNumberFormWidget(
        component: component.cast<PhoneNumberDataEntity>(),
        enabled: enabled,
      );
    case DataType.signature:
      return SignatureFormWidget(
        component: component.cast<SignatureDataEntity>(),
        enabled: enabled,
      );
    case DataType.createdBy:
    case DataType.createdAt:
    case DataType.lookUp:
    case DataType.reducedLookUp:
    case DataType.formula:
      return const EmptyFormWidget();
  }
}
