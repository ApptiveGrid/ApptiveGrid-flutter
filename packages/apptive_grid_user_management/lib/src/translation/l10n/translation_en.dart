// ignore_for_file: public_member_api_docs, prefer_single_quotes
// coverage:ignore-file

import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';

class ApptiveGridUserManagementLocalizedTranslation
    extends ApptiveGridUserManagementTranslation {
  const ApptiveGridUserManagementLocalizedTranslation() : super();
  @override
  String get actionLogin => 'Login';
  @override
  String get actionRegister => 'Register';
  @override
  String get hintEmail => 'Email Address';
  @override
  String get hintPassword => 'Password';
  @override
  String get hintFirstName => 'First Name';
  @override
  String get hintLastName => 'Last Name';
  @override
  String get hintConfirmPassword => 'Confirm Password';
  @override
  String get validateErrorEmailFormat => 'Not a valid email address';
  @override
  String get validateErrorEmailEmpty => 'Email may not be empty';
  @override
  String get validateErrorFirstNameEmpty => 'First Name may not be empty';
  @override
  String get validateErrorLastNameEmpty => 'Last Name may not be empty';
  @override
  String get validateErrorPasswordsNotMatching => 'Passwords do not match';
  @override
  String get registerWaitingForConfirmation =>
      'All Set!\nCheck your Email for a link to verify your account.';
  @override
  String get confirmAccountCreation => 'Confirm your account by clicking below';
  @override
  String get actionConfirm => 'Confirm';
  @override
  String get errorLogin => 'Error during login. Please try again.';
  @override
  String get errorRegister => 'Error during registration. Please try again.';
  @override
  String get errorConfirm => 'Error during confirmation. Please try again.';
  @override
  String get forgotPassword => 'Forgot password?';
  @override
  String get forgotPasswordMessage =>
      'We can send you a link to reset your password.';
  @override
  String get actionResetPassword => 'Reset';
  @override
  String get actionCancel => 'Cancel';
  @override
  String get actionOk => 'OK';
  @override
  String requestResetPasswordSuccess(String email) =>
      'We have send a link to reset your password to $email.';
  @override
  String get resetPasswordMessage => 'Reset Password';
  @override
  String get hintNewPassword => 'New password';
  @override
  String get actionPasswordReset => 'Reset';
  @override
  String get resetPasswordSuccess => 'Your password was reset successfully.';
  @override
  String get errorUnknown => 'An error occurred. Please try again.';
  @override
  String get errorReset => 'Password could not be set. Please try again.';
  @override
  String registerConfirmAddToGroup({
    required String email,
    required String app,
  }) =>
      'There already exists an account for $email.\nWe have send you a link to confirm that you want to activate the account for "$app".\nYour password has not been changed.';
  @override
  String get actionBack => 'Back';
  @override
  String joinGroup(String app) =>
      'Your account is not yet activated for $app.\nDo you want to activate it now?';
  @override
  String get actionJoinGroup => 'Activate';
  @override
  String get deleteAccount => 'Delete Account';
  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account?\nThis can not be undone.';
  @override
  String get actionDelete => 'Delete';
}
