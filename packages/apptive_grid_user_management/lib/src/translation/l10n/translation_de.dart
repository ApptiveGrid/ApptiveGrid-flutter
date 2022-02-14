// ignore_for_file: public_member_api_docs, prefer_single_quotes
// coverage:ignore-file

import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';

class ApptiveGridUserManagementLocalizedTranslation
    extends ApptiveGridUserManagementTranslation {
  const ApptiveGridUserManagementLocalizedTranslation() : super();
  @override
  String get actionLogin => "Login";
  @override
  String get actionRegister => "Registrieren";
  @override
  String get hintEmail => "E-Mail Adresse";
  @override
  String get hintPassword => "Passwort";
  @override
  String get hintFirstName => "Vorname";
  @override
  String get hintLastName => "Nachname";
  @override
  String get hintConfirmPassword => "Passwort bestätigen";
  @override
  String get validateErrorEmailFormat => "Keine gültige E-Mail Adresse";
  @override
  String get validateErrorEmailEmpty => "E-Mail darf nicht leer sein";
  @override
  String get validateErrorFirstNameEmpty => "Vorname darf nicht leer sein";
  @override
  String get validateErrorLastNameEmpty => "Nachname darf nicht leer sein";
  @override
  String get validateErrorPasswordsNotMatching =>
      "Passwörter stimmen nicht überein";
  @override
  String get registerWaitingForConfirmation =>
      "Alles klar!\nWir haben dir eine Mail geschickt, um den Account zu bestätigen.";
  @override
  String get confirmAccountCreation => "Bestätige deinen Account";
  @override
  String get actionConfirm => "Bestätigen";
}
