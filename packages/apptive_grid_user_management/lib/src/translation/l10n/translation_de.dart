// ignore_for_file: public_member_api_docs, prefer_single_quotes
// coverage:ignore-file

import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';

class ApptiveGridUserManagementLocalizedTranslation
    extends ApptiveGridUserManagementTranslation {
  const ApptiveGridUserManagementLocalizedTranslation() : super();
  @override
  String get actionLogin => 'Login';
  @override
  String get actionRegister => 'Registrieren';
  @override
  String get hintEmail => 'E-Mail Adresse';
  @override
  String get hintPassword => 'Passwort';
  @override
  String get hintFirstName => 'Vorname';
  @override
  String get hintLastName => 'Nachname';
  @override
  String get hintConfirmPassword => 'Passwort bestätigen';
  @override
  String get validateErrorEmailFormat => 'Keine gültige E-Mail Adresse';
  @override
  String get validateErrorEmailEmpty => 'E-Mail darf nicht leer sein';
  @override
  String get validateErrorFirstNameEmpty => 'Vorname darf nicht leer sein';
  @override
  String get validateErrorLastNameEmpty => 'Nachname darf nicht leer sein';
  @override
  String get validateErrorPasswordsNotMatching =>
      'Passwörter stimmen nicht überein';
  @override
  String get registerWaitingForConfirmation =>
      'Alles klar!\nWir haben dir eine Mail geschickt, um den Account zu bestätigen.';
  @override
  String get confirmAccountCreation => 'Bestätige deinen Account';
  @override
  String get actionConfirm => 'Bestätigen';
  @override
  String get errorLogin =>
      'Beim Login ist ein Fehler aufgetreten. Bitte versuche es erneut.';
  @override
  String get errorRegister =>
      'Bei der Registrierung ist ein Fehler aufgetreten. Bitte versuche es erneut.';
  @override
  String get errorConfirm =>
      'Beim Bestätigen des Accounts ist ein Fehler aufgetreten. Bitte versuche es erneut.';
  @override
  String get forgotPassword => 'Passwort vergessen?';
  @override
  String get forgotPasswordMessage =>
      'Wir können dir einen Link schicken, mit dem du dein Passwort zurücksetzen kannst.';
  @override
  String get actionResetPassword => 'Zurücksetzen';
  @override
  String get actionCancel => 'Abbrechen';
  @override
  String get actionOk => 'OK';
  @override
  String requestResetPasswordSuccess(String email) =>
      'Wir haben einen Link zum Zurücksetzen an $email gesendet.';
  @override
  String get resetPasswordMessage => 'Passwort zurücksetzen';
  @override
  String get hintNewPassword => 'Neues Passwort';
  @override
  String get actionPasswordReset => 'Zurücksetzen';
  @override
  String get resetPasswordSuccess =>
      'Dein Passwort wurde erfolgreich zurückgesetzt';
  @override
  String get errorUnknown =>
      'Leider ist ein Fehler aufgetreten. Bitte versuche es erneut.';
  @override
  String get errorReset =>
      'Passwort konnte nicht zurückgesetzt werden. Bitte versuche es erneut.';
  @override
  String registerConfirmAddToGroup({
    required String email,
    required String app,
  }) =>
      'Es existiert bereits ein Account mit der Adresse $email.\nWir haben dir einen Link geschickt, mit dem du bestätigen kannst, dass du den Account für "$app" freischalten möchtest.\nDein Passwort wurde nicht geändert.';
  @override
  String get actionBack => 'Zurück';
  @override
  String joinGroup(String app) =>
      'Dein Account ist noch nicht für $app freigeschaltet.\nWillst du deinen Account jetzt freischalten?';
  @override
  String get actionJoinGroup => 'Freischalten';
  @override
  String get deleteAccount => 'Account löschen';
  @override
  String get deleteAccountConfirmation =>
      'Bist du sicher, dass du deinen Account löschen möchtest?\nDies kann nicht rückgängig gemacht werden.';
  @override
  String get actionDelete => 'Löschen';
}
