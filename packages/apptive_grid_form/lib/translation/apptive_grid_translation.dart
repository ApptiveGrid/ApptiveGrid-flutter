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

  String get searchLocation;

  String get searchLocationNoResult;
}
