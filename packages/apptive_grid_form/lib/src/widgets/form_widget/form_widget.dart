import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/email_form_widget.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/phone_number_form_widget.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/signature_form_widget.dart';
import 'package:flutter/material.dart';

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
    case DataType.createdBy:
      return const CreatedByFormWidget();
    case DataType.user:
      return UserFormWidget(
        component: component.cast<UserDataEntity>(),
      );
    case DataType.currency:
      return CurrencyFormWidget(
        component: component.cast<CurrencyDataEntity>(),
      );
    case DataType.uri:
      return UriFormWidget(
        component: component.cast<UriDataEntity>(),
      );
    case DataType.email:
      return EmailFormWidget(
        component: component.cast<EmailDataEntity>(),
      );
    case DataType.phoneNumber:
      return PhoneNumberFormWidget(
        component: component.cast<PhoneNumberDataEntity>(),
      );
    case DataType.signature:
      return SignatureFormWidget(
        component: component.cast<SignatureDataEntity>(),
      );
  }
}
