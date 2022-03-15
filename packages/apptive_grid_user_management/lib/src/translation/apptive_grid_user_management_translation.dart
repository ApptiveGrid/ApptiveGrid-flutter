/// Translations used for ApptiveGridUserManagement
abstract class ApptiveGridUserManagementTranslation {
  /// `const` constructor to be used for children
  const ApptiveGridUserManagementTranslation();

  /// Action prompt to login
  String get actionLogin;

  /// Action prompt to register
  String get actionRegister;

  /// Hint in email input fields
  String get hintEmail;

  /// Hint in password input fields
  String get hintPassword;

  /// Hint for first name input field
  String get hintFirstName;

  /// Hint for last name input field
  String get hintLastName;

  /// Hint for confirm password input field
  String get hintConfirmPassword;

  /// Message shown when the email input is not a valid email address during registration
  String get validateErrorEmailFormat;

  /// Message shown when the email is empty during registration
  String get validateErrorEmailEmpty;

  /// Message shown when the first name is empty during registration
  String get validateErrorFirstNameEmpty;

  /// Message shown when the last name is empty during registration
  String get validateErrorLastNameEmpty;

  /// Message shown when password confirmation does not match the password
  String get validateErrorPasswordsNotMatching;

  /// Message shown after registration to indicate the user that they should confirm their account via the link in an email
  String get registerWaitingForConfirmation;

  /// Message to explain that users need to confirm their account
  String get confirmAccountCreation;

  /// Action prompt to confirm the account
  String get actionConfirm;

  /// Message when an error occurred during login
  String get errorLogin;

  /// Message when an error occurred during registration
  String get errorRegister;

  /// Message when an error occurred during confirmation
  String get errorConfirm;
}