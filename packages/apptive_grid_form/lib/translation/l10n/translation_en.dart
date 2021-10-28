// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_form/apptive_grid_form.dart';

class ApptiveGridLocalizedTranslation extends ApptiveGridTranslation {
  const ApptiveGridLocalizedTranslation() : super();
   @override
   String get actionSend => "Submit";
   @override
   String get additionalAnswer => "Submit more answers";
   @override
   String get backToForm => "Back to form";
   @override
   String get loadingGrid => "Loading Grid";
   @override
   String get selectEntry => "Choose Entry";
   @override
   String fieldIsRequired(String fieldName) => "$fieldName must not be empty";
   @override
   String get sendSuccess => "Thank You!";
   @override
   String get savedForLater => "The form was saved and will be send at the next opportunity";
   @override
   String get errorTitle => "Oops! - Error";
}