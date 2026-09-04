// ignore_for_file: public_member_api_docs
// coverage:ignore-file

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
  String get savedForLater =>
      "The form was saved and will be sent at the next opportunity";
  @override
  String get errorTitle => "Oops! - Error";
  @override
  String get crossRefSearch => "Search";
  @override
  String get dateTimeFieldDate => "Date";
  @override
  String get dateTimeFieldTime => "Time";
  @override
  String get checkboxRequired => "Required";
  @override
  String get addAttachment => "Add attachment";
  @override
  String get searchLocation => "Search location";
  @override
  String get searchLocationNoResult => "No results";
  @override
  String get attachmentSourceGallery => "Choose existing";
  @override
  String get attachmentSourceCamera => "Take Photo or Video";
  @override
  String get attachmentSourceFiles => "Select files";
  @override
  String searchUserNoResult(String query) =>
      'No Users found that match "$query"';
  @override
  String progressProcessAttachment({
    required int processed,
    required int total,
  }) =>
      'Processing Attachments [$processed/$total]';
  @override
  String get progressSubmitForm => "Submitting Form";
  @override
  String get invalidEmail => "Invalid email";
  @override
  String get clear => "Clear";
  @override
  String get save => "Save";
  @override
  String get signHere => "Sign here";
  @override
  String get missingCountryCode => "International code is required (e.g. +49)";
  @override
  String get pageNext => "Next";
  @override
  String get pageBack => "Back";
  @override
  String get addressLine1Label => "Address Line 1";
  @override
  String get addressLine2Label => "Address Line 2";
  @override
  String get addressCityLabel => "City";
  @override
  String get addressPostCodeLabel => "Post Code";
  @override
  String get addressStateLabel => "State";
  @override
  String get addressCountryLabel => "Country";
  @override
  String get determinePosition => "Determine position";
  @override
  String get addressGeocodingFailed =>
      "Position could not be determined automatically";
}
