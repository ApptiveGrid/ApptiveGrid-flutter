import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';

/// Returns a corresponding Widget for a specific [component]
///
/// Throws an [ArgumentError] if no Widget for a specific [DataType] is found
Widget fromModel(FormComponent component, {bool enabled = true}) =>
    switch (component.field.type) {
      DataType.text =>
        TextFormWidget(component: component.cast<StringDataEntity>()),
      DataType.dateTime => DateTimeFormWidget(
          component: component.cast<DateTimeDataEntity>(),
        ),
      DataType.date =>
        DateFormWidget(component: component.cast<DateDataEntity>()),
      DataType.integer =>
        IntegerFormWidget(component: component.cast<IntegerDataEntity>()),
      DataType.decimal =>
        DecimalFormWidget(component: component.cast<DecimalDataEntity>()),
      DataType.checkbox =>
        CheckBoxFormWidget(component: component.cast<BooleanDataEntity>()),
      DataType.singleSelect =>
        EnumFormWidget(component: component.cast<EnumDataEntity>()),
      DataType.crossReference => CrossReferenceFormWidget(
          component: component.cast<CrossReferenceDataEntity>(),
        ),
      DataType.attachment => AttachmentFormWidget(
          component: component.cast<AttachmentDataEntity>(),
        ),
      DataType.enumCollection => EnumCollectionFormWidget(
          component: component.cast<EnumCollectionDataEntity>(),
        ),
      DataType.geolocation => GeolocationFormWidget(
          component: component.cast<GeolocationDataEntity>(),
        ),
      DataType.multiCrossReference => MultiCrossReferenceFormWidget(
          component: component.cast<MultiCrossReferenceDataEntity>(),
        ),
      DataType.user =>
        UserFormWidget(component: component.cast<UserDataEntity>()),
      DataType.currency => CurrencyFormWidget(
          component: component.cast<CurrencyDataEntity>(),
        ),
      DataType.uri => UriFormWidget(component: component.cast<UriDataEntity>()),
      DataType.email =>
        EmailFormWidget(component: component.cast<EmailDataEntity>()),
      DataType.phoneNumber => PhoneNumberFormWidget(
          component: component.cast<PhoneNumberDataEntity>(),
        ),
      DataType.signature => SignatureFormWidget(
          component: component.cast<SignatureDataEntity>(),
        ),
      DataType.createdBy ||
      DataType.createdAt ||
      DataType.lookUp ||
      DataType.reducedLookUp ||
      DataType.formula =>
        const EmptyFormWidget(),
    };
