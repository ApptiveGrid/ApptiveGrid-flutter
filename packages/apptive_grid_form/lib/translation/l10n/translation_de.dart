// ignore_for_file: public_member_api_docs
// coverage:ignore-file

import 'package:apptive_grid_form/apptive_grid_form.dart';

class ApptiveGridLocalizedTranslation extends ApptiveGridTranslation {
  const ApptiveGridLocalizedTranslation() : super();
  @override
  String get actionSend => "Einsenden";
  @override
  String get additionalAnswer => "Weitere Antwort senden";
  @override
  String get backToForm => "Zurück zum Formular";
  @override
  String get loadingGrid => "Grid wird geladen";
  @override
  String get selectEntry => "Eintrag auswählen";
  @override
  String fieldIsRequired(String fieldName) => "$fieldName darf nicht leer sein";
  @override
  String get sendSuccess => "Vielen Dank!";
  @override
  String get savedForLater =>
      "Das Formular wurde gespeichert und wird bei der nächsten Gelegenheit gesendet.";
  @override
  String get errorTitle => "Oops! - Fehler";
  @override
  String get crossRefSearch => "Suchen";
  @override
  String get dateTimeFieldDate => "Datum";
  @override
  String get dateTimeFieldTime => "Zeit";
  @override
  String get checkboxRequired => "Pflichtfeld";
  @override
  String get addAttachment => "Datei hochladen";
}
