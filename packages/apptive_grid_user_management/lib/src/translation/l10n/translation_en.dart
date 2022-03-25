// ignore_for_file: public_member_api_docs, prefer_single_quotes
// coverage:ignore-file

import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';

class ApptiveGridUserManagementLocalizedTranslation
    extends ApptiveGridUserManagementTranslation {
  const ApptiveGridUserManagementLocalizedTranslation() : super();
  @override
  String get actionLogin => "Login";
  @override
  String get actionRegister => "Register";
  @override
  String get hintEmail => "Email Address";
  @override
  String get hintPassword => "Password";
  @override
  String get hintFirstName => "First Name";
  @override
  String get hintLastName => "Last Name";
  @override
  String get hintConfirmPassword => "Confirm Password";
  @override
  String get validateErrorEmailFormat => "Not a valid email address";
  @override
  String get validateErrorEmailEmpty => "Email may not be empty";
  @override
  String get validateErrorFirstNameEmpty => "First Name may not be empty";
  @override
  String get validateErrorLastNameEmpty => "Last Name may not be empty";
  @override
  String get validateErrorPasswordsNotMatching => "Passwords do not match";
  @override
  String get registerWaitingForConfirmation =>
      "All Set!\nCheck your Email for a link to verify your account.";
  @override
  String get confirmAccountCreation => "Confirm your account by clicking below";
  @override
  String get actionConfirm => "Confirm";
  @override
  String get errorLogin => "Error during login. Please try again.";
  @override
  String get errorRegister => "Error during registration. Please try again.";
  @override
  String get errorConfirm => "Error during confirmation. Please try again.";
  @override
  String get forgotPassword => "Forgot password?";
  @override
  String get forgotPasswordMessage =>
      "We can send you a link to reset your password.";
  @override
  String get actionResetPassword => "Reset";
  @override
  String get actionCancel => "Cancel";
  @override
  String get actionOk => "OK";
  @override
  String requestNewPasswordSuccess(String email) =>
      "We have send a link to reset your password to $email.";
  @override
  String get resetPasswordMessage => "Reset Password";
  @override
  String get hintNewPassword => "New password";
  @override
  String get actionPasswordChange => "Reset";
  @override
  String get resetPasswordSuccess => "Your password was reset successfully.";
}
