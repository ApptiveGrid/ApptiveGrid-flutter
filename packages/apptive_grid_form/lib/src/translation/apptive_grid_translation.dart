import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Abstract class containing all Strings for ApptiveGrid
abstract class ApptiveGridTranslation {
  /// Super const constructor
  const ApptiveGridTranslation();

  /// Label for [FormAction] Buttons
  String get actionSend;

  /// Displayed when a [FormData] was send to the server successfully
  String get sendSuccess;

  /// Message displayed when the form was saved to the [ApptiveGridCache]
  String get savedForLater;

  /// Title displayed when there has been an error
  String get errorTitle;

  /// Message providing the User to send an additional answer
  String get additionalAnswer;

  /// Message in the error State to allow users to go back to the form
  String get backToForm;

  /// Message indicating that a [Grid] is loading in a [CrossReferenceFormWidget]
  String get loadingGrid;

  /// Prompts the User to select an Entry from a [Grid]
  String get selectEntry;

  /// Indicates that a Field with [fieldName] must be filled in order to send a form
  String fieldIsRequired(String fieldName);

  /// Search Hint for Cross Reference Search
  String get crossRefSearch;

  /// Label of date section in a DateTime Picker
  String get dateTimeFieldDate;

  /// Label of time section in a DateTime Picker
  String get dateTimeFieldTime;

  /// Message if a [CheckboxFormWidget] is required
  String get checkboxRequired;

  /// Action to add an Attachment
  String get addAttachment;

  /// Hint in Location Search Field
  String get searchLocation;

  /// Message displayed when no matching Location Search result is found for a search input
  String get searchLocationNoResult;

  /// Prompt to add Attachments from Image Gallery
  String get attachmentSourceGallery;

  /// Prompt to take a picture with the camera to use as an attachment
  String get attachmentSourceCamera;

  /// Prompt to get files to use as attachments
  String get attachmentSourceFiles;

  /// Hint that no user was found in list of collaborators that matches [query]
  String searchUserNoResult(String query);

  /// Message that [processed] out of [total] attachments have been processed for a form submission
  String progressProcessAttachment({
    required int processed,
    required int total,
  });

  /// Message that the form is being submitted
  String get progressSubmitForm;

  /// Hint that the provided email is not valid
  String get invalidEmail;

  /// Label to clear an input
  String get clear;

  /// Label to save changes
  String get save;

  /// Prompt to sign in the field
  String get signHere;

  /// Hint that a phonenumber need to start with a country code
  String get missingCountryCode;

  /// Label for the next page button
  String get pageNext;

  /// Label for the page back button
  String get pageBack;

  /// Label for the first address line of an [AddressFormWidget]
  String get addressLine1Label;

  /// Label for the second address line of an [AddressFormWidget]
  String get addressLine2Label;

  /// Label for the city field of an [AddressFormWidget]
  String get addressCityLabel;

  /// Label for the postal code field of an [AddressFormWidget]
  String get addressPostCodeLabel;

  /// Label for the state field of an [AddressFormWidget]
  String get addressStateLabel;

  /// Label for the country field of an [AddressFormWidget]
  String get addressCountryLabel;

  /// Label for the Button that geocodes the entered address of an [AddressFormWidget]
  String get determinePosition;

  /// Message displayed when geocoding the entered address of an [AddressFormWidget] failed
  String get addressGeocodingFailed;

  /// Header for a group of resources of the same [DataResourceMetaType] in a [ResourceFormWidget]
  String resourceGroupLabel(DataResourceMetaType metaType);

  /// Label of the button that records a video in an [AttachmentFormWidget] with `typeOverride: videoRecorder`
  String get recordVideo;
}
