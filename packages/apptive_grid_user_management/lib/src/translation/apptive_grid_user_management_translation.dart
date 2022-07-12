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

  /// Message shown to show that the user received an email to confirm they want to activate this app for their account
  String registerConfirmAddToGroup({
    required String email,
    required String app,
  });

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

  /// Option on login content
  String get forgotPassword;

  /// Message shown in the dialog to reset the password
  String get forgotPasswordMessage;

  /// Action prompt to reset the password;
  String get actionResetPassword;

  /// Action to cancel something
  String get actionCancel;

  /// Confirm that a message is understood
  String get actionOk;

  /// Confirmation Message after a link to reset a password has been send
  String requestResetPasswordSuccess(String email);

  /// Hint/Title to reset the password
  String get resetPasswordMessage;

  /// Hint for the FormField to set a New Password
  String get hintNewPassword;

  /// Action to reset a password
  String get actionPasswordReset;

  /// Message that the password was reset successfully
  String get resetPasswordSuccess;

  /// Message that there has been an unknown error
  String get errorUnknown;

  /// Message that there has been an error while resetting the password
  String get errorReset;

  /// Action to go back
  String get actionBack;

  /// Displayed when the user has an ApptiveGrid Account which is not yet added to the group for this app
  String joinGroup(String app);

  /// Action to join this group
  String get actionJoinGroup;

  /// Message to delete an Account
  String get deleteAccount;

  /// Message shown to users to ask to confirm the deletion of their account. Moting, that this can not be undone
  String get deleteAccountConfirmation;

  /// Action to delete something
  String get actionDelete;
}
