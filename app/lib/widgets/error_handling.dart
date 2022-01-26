// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Zum schnelleren Handeln und Anzeigen von Fehlermeldungen
///
/// Fehlermeldungen können falls ein [GlobalKey<ScaffoldState>]
/// übergen wird mithilfe einer Snackbar direkt dem benutzer angezeigt werden.
///
/// Die Dauer der Anzeige wird für alle Fehlermeldungen mit {snackBarErrorDuration] festgelegt.
///
/// Die [Map] [errorMessageInGerman] legt für Englische Fehlermeldungen, z.B. von einer
/// Erstellung eines Useraccounts die deutschen Gegenstücke fest.
class ErrorHandling {
  static final Duration snackBarErrorDuration = Duration(seconds: 4);

  // General
  static const String generalDatabaseError =
      "Fehler beim Arbeiten/Verbinden mit der Datenbank.";
  static const String generaltimeoutMessage =
      "Timeout, bist du mit dem Internet verbunden?";
  static const String generalConnectionError =
      "Fehler aufgetreten - Bist du mit dem Internet verbunden?";
  static const String generalErrorMessage = "Ein Fehler ist aufgetreten.";
  static const String generalErrorTryAgainMessage =
      "Ein Fehler ist aufgetreten. Versuche es später nocheinmal.";
  // specific Exceptions

  // FirebaseAuth.instance.CreateUserWithEmailAndPassword
  static const String authNetworkError =
      "Ein Netzwerkfehler ist aufgetreten, überprüfe dein Internet!";
  static const String authEmailAlreadyInUse =
      "Diese Email wird bereits benutzt!";
  static const String authInvalidEmail = "Ungültige Email.";
  static const String authOperationNotAllowed =
      "Einloggen mit Password & Email wurde deaktiviert - Support anschreiben.";
  static const String authWeakPassword = "Zu schwaches Passwort.";

  // Firebase setData

  static const Map<String, String> errorMessageInGerman = {
    "The email address is already in use by another account.":
        authEmailAlreadyInUse,
    "The email address is badly formatted.": authInvalidEmail,
    "The given password is invalid. [ Password should be at least 6 characters ]":
        authWeakPassword,
    "A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
        authNetworkError
  };

  // CourseErrors
  static const String courseCreationFailed =
      "Kurs konnte nicht erstellt werden.";

  static void debugPrintErrorAndStackTrace(Object error, Object stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }

  static void handleGeneralError(Object error, Object stackTrace,
      [GlobalKey<ScaffoldState> scaffoldState]) {
    if (scaffoldState != null)
//      showSnack(generalErrorMessage, snackBarErrorDuration, context);
      debugPrintErrorAndStackTrace(error, stackTrace);
  }

  static void handleGeneralErrorTryAgain(Object error, Object stackTrace,
      [GlobalKey<ScaffoldState> scaffoldState]) {
    if (scaffoldState != null)
//      showSnack(
//          generalErrorTryAgainMessage, snackBarErrorDuration, scaffoldState);
      debugPrintErrorAndStackTrace(error, stackTrace);
  }

  static void handleGeneralDatabseError(Object error, Object stackTrace,
      [GlobalKey<ScaffoldState> scaffoldState]) {
    if (scaffoldState != null)
//      showSnack(generalDatabaseError, snackBarErrorDuration, scaffoldState);
      debugPrintErrorAndStackTrace(error, stackTrace);
  }

  static void handleCreateUserWithEmailAndPasswordPlatformException(
      PlatformException platformException, Object stackTrace,
      [GlobalKey<ScaffoldState> scaffoldState]) {
    debugPrint("ErrorHandling PlatformException (Code/Details/Message):");
    debugPrint(platformException.code);
    debugPrint(platformException.details.toString());
    debugPrint(platformException.message);
    debugPrint("");
    String errorText;
    errorText = errorMessageInGerman[platformException.message] ??
        platformException.message;
    debugPrint("errorText: $errorText");
    if (scaffoldState != null)
//      showSnack(errorText, snackBarErrorDuration, scaffoldState);
      debugPrintErrorAndStackTrace(platformException, stackTrace);
  }

  static void handleTimeout([GlobalKey<ScaffoldState> scaffoldState]) {
    debugPrint("ERROR: Timeout");
    if (scaffoldState != null) debugPrint(generaltimeoutMessage);
//      showSnack(generaltimeoutMessage, snackBarErrorDuration, scaffoldState);
  }
}
