// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'api_errors.dart';

/// [s]: StrackTrace wird ebenfalls übergeben, damit bei einem unbekannten
/// Fehler dieser direkt mit dem StackTrace gemeldet werde kann.
String? handleErrorMessage(String? error, StackTrace s) {
  if (error != null) {
    if (error == IncorrectDataException().toString()) {
      return "Bitte gib die Daten korrekt an!";
    } else if (error == "EmailIsMissingException") {
      return "Bitte gib deine E-Mail an.";
    } else if (error == "PasswordIsMissingException") {
      return "Bitte gib dein Passwort an.";
    } else if (error == "NoGoogleSignAccountSelected") {
      return "Bitte wähle einen Account aus.";
    } else if (error == "NoInternetAccess") {
      return "Dein Gerät hat leider keinen Zugang zum Internet...";
    } else if (error == "NewPasswordIsMissingException") {
      return "Oh, du hast vergessen dein neues Passwort einzugeben 😬";
    } else if (error.contains("wrong-password")) {
      return "Das eingegebene Passwort ist falsch.";
    } else if (error == "SubjectIsMissingException") {
      return course_validators.CourseValidators.emptySubjectUserMessage;
    } else if (error == "InvalidTitleException") {
      return blackboard_validators.BlackboardValidators.emptyTitleUserMessage;
    } else if (error == "InvalidCourseException") {
      return blackboard_validators.BlackboardValidators.emptyCourseUserMessage;
    } else if (error == "InvalidStartTimeException") {
      return "Bitte gibt eine Startzeit an!";
    } else if (error == MissingReportInformation().toString()) {
      return MissingReportInformation().toString();
      // } else if (error == MissingFiles().toString()) {
      //   return MissingFiles().toString();
    } else if (error == NameIsMissingException().toString()) {
      return NameIsMissingException().toString();
    } else if (error == EmptyNameException().toString()) {
      return EmptyNameException().toString();
    } else if (error == SameNameAsBefore().toString()) {
      return SameNameAsBefore().toString();
    } else if (error == InvalidInputException().toString()) {
      return InvalidInputException().toString();
    } else if (error == SameNameException().toString()) {
      return SameNameException().toString();
    } else if (error == IncorrectPeriods().toString()) {
      return IncorrectPeriods().toString();
    } else if (error == "InvalidEndTimeException") {
      return "Bitte gibt eine Endzeit an!";
    } else if (error == EndTimeIsBeforeStartTimeException().toString()) {
      return "Die Endzeit der Stunde ist vor der Startzeit!";
    } else if (error ==
        StartTimeIsBeforeStartTimeOfNextLessonException().toString()) {
      return "Die Startzeit ist vor der Startzeit der nächsten Stunde!";
    } else if (error == StartTimeEndTimeIsEqualException().toString()) {
      return "Die Startzeit und die Endzeit darf nicht gleich sein!";
    } else if (error ==
        StartTimeIsBeforeEndTimeOfPreviousLessonException().toString()) {
      return "Die Startzeit ist vor der Endzeit der vorherigen Stunde!";
    } else if (error ==
        EndTimeIsBeforeStartTimeOfNextLessonException().toString()) {
      return "Die Endzeit ist vor der Startzeit der nächsten Stunde!";
    } else if (error ==
        EndTimeIsBeforeEndTimeOfPreviousLessonException().toString()) {
      return "Die Endzeit ist vor der Endzeit der vorherigen Stunde!";
    } else if (error == "InvalidWeekDayException") {
      return "Bitte gib einen Wochentag an!";
    } else if (error == "InvalidDateException") {
      return "Bitte gib ein Datum an!";
    } else if (error == "InvalidTitleSubject") {
      return "Bitte gib einen Titel an!";
    } else if (error.contains("invalid-email")) {
      return "Die E-Mail hat ein ungültiges Format.";
    } else if (error.contains("email-already-in-use")) {
      return "Diese E-Mail Adresse wird bereits von einem anderen Nutzer verwendet.";
    } else if (error.contains("user-disabled")) {
      return "Dieser Account wurde von einem Administrator deaktiviert";
    } else if (error.contains("too-many-requests")) {
      return "Wir haben alle Anfragen von diesem Gerät aufgrund ungewöhnlicher Aktivitäten blockiert. Versuchen Sie es später noch einmal.";
    } else if (error.contains("user-not-found")) {
      return "Es wurde kein Nutzer mit dieser E-Mail Adresse gefunden...";
    } else if (error.contains("network-request-failed")) {
      return "Es gab einen Netzwerkfehler, weil keine stabile Internetverbindung besteht.";
    } else if (error.contains("weak-password")) {
      return "Dieses Passwort ist zu schwach. Bitte wähle eine stärkeres Passwort.";
    }

    recordError(error, s);
    return "Es ist ein unbekannter Fehler ($error) aufgetreten! Bitte kontaktiere den Support.";
  }
  return null;
}

void recordError(String e, StackTrace s) =>
    getCrashAnalytics().recordError(e, s);
