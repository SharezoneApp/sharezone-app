// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:quiver/core.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_common/validators.dart';

part 'handle_error_message.dart';

class IncorrectSharecode implements Exception {
  static const code = "IncorrectSharecode";

  @override
  String toString() => code;
}

class SameNameAsBefore implements Exception {
  static const code = "SameNameAsBefore";

  @override
  String toString() => code;
}

class IncorrectPeriods implements Exception {
  static const code = "IncorrectPeriods";

  @override
  String toString() => code;
}

class MissingReportInformation implements Exception {
  static const code = "MissingReportInformation";

  @override
  String toString() => code;
}

class IncorrectDataException implements Exception {
  @override
  String toString() {
    return "IncorrectDataException";
  }
}

class InvalidTitleException implements Exception {
  @override
  String toString() {
    return "InvalidTitleException";
  }
}

class InvalidCourseException implements Exception {
  @override
  String toString() {
    return "InvalidCourseException";
  }
}

class InvalidGroupKeyException implements Exception {
  @override
  String toString() {
    return "InvalidGroupKeyException";
  }
}

class NoGoogleSignAccountSelected implements Exception {
  @override
  String toString() {
    return "NoGoogleSignAccountSelected";
  }
}

class NoInternetAccess implements Exception {
  @override
  String toString() {
    return "NoInternetAccess";
  }
}

class EmailIsMissingException implements Exception {
  @override
  String toString() {
    return "EmailIsMissingException";
  }
}

class PasswordIsMissingException implements Exception {
  @override
  String toString() {
    return "PasswordIsMissingException";
  }
}

class SubjectIsMissingException implements Exception {
  @override
  String toString() {
    return "SubjectIsMissingException";
  }
}

class NameIsMissingException implements Exception {
  static const code = "NameIsMissingException";

  @override
  String toString() {
    return code;
  }
}

class InvalidPeriodException implements Exception {
  @override
  String toString() {
    return "InvalidPeriodException";
  }
}

class InvalidStartTimeException implements Exception {
  @override
  String toString() {
    return "InvalidStartTimeException";
  }
}

class StartTimeEndTimeIsEqualException implements Exception {
  @override
  String toString() {
    return "StartTimeEndTimeIsEqualException";
  }
}

class InvalidEndTimeException implements Exception {
  @override
  String toString() {
    return "InvalidEndTimeException";
  }
}

class InvalidDateException implements Exception {
  @override
  String toString() {
    return "InvalidDateException";
  }
}

class EndTimeIsBeforeStartTimeException implements Exception {
  @override
  String toString() {
    return "EndTimeIsBeforeStartTimeException";
  }
}

class StartTimeIsBeforeStartTimeOfNextLessonException implements Exception {
  @override
  String toString() {
    return "StartTimeIsBeforeEndTimeOfNextLessonException";
  }
}

class StartTimeIsBeforeEndTimeOfPreviousLessonException implements Exception {
  @override
  String toString() => "StartTimeIsBeforeEndTimeOfPreviousLessonException";
}

class EndTimeIsBeforeEndTimeOfPreviousLessonException implements Exception {
  @override
  String toString() => "EndTimeIsBeforeEndTimeOfPreviousLessonException";
}

class EndTimeIsBeforeStartTimeOfNextLessonException implements Exception {
  @override
  String toString() => "EndTimeIsBeforeStartTimeOfNextLessonException";
}

class InvalidWeekDayException implements Exception {
  @override
  String toString() => "InvalidWeekDayException";
}

class EmptyNameException implements Exception {
  static const code = "EmptyNameException";

  @override
  String toString() => code;
}

class SameNameException implements Exception {
  static const code = "SameNameException";

  @override
  String toString() => code;
}

class InvalidInputException implements Exception {
  static const code = "InvalidInputException";

  @override
  String toString() => code;
}

/// Exeption thrown when trying to deserialize a [FirestoreDocument] into a another
/// class, e.g. deserializing a [FirestoreDocument] into a [Homework].
class DeserializeFirestoreDocException implements Exception {
  /// Message to describe the deserializing Exeption.
  /// Should include the type that the [documentToDeserialize] should have been
  /// deserialized to.
  final String? message;

  /// The document that should have been deserialized.
  final DocumentSnapshot<Map<String, dynamic>>? documentToDeserialize;

  StackTrace? stackTrace;

  DeserializeFirestoreDocException([
    this.documentToDeserialize,
    this.message,
    this.stackTrace,
  ]) {
    stackTrace ??= StackTrace.current;
  }

  @override
  String toString() {
    String report = "Exception: thrown while trying to deserialize a document.";
    if (message != null && message != "") report += "\n Message: $message";
    if (documentToDeserialize != null) {
      report +=
          "\n.toString() of the document that should have been deserialized:\n${documentToDeserialize?.toString()}";
      report += "\n Fields of Document:\n";
      List<String> listOfContent = [];
      try {
        listOfContent.add("\nDocument ID: ${documentToDeserialize!.id}");
        documentToDeserialize?.data()?.forEach((string, dyn) {
          listOfContent.add("\n$string: ${dyn.runtimeType}: ${dyn.toString()}");
        });
        report += listOfContent.toString();
      } catch (e) {
        log("Error while reading document data.");
      }
    }
    return report;
  }

  @override
  bool operator ==(other) {
    if (identical(other, this)) return true;
    if (other is! DeserializeFirestoreDocException) return false;
    return message == other.message &&
        documentToDeserialize == other.documentToDeserialize;
  }

  @override
  int get hashCode => hash3(message, documentToDeserialize, stackTrace);
}

InternalException mapExceptionIntoInternalException(Exception e) {
  if (e.toString().contains("credential-already-in-use")) {
    return FirebaseCredentialAlreadyInUseException();
  } else if (e.toString().contains("email-already-in-use")) {
    return FirebaseEmailAlreadyInUseException();
  }
  return UnknownInternalException(e);
}

/// Eine [InternalException] ist dafür da, dass später in der UI einfach
/// interalExepetion.message() aufgerufen werden kann und die passende
/// Fehlermeldung ausgegeben wird.
abstract class InternalException implements Exception {
  String message(SharezoneLocalizations l10n);
}

class UnknownInternalException implements InternalException {
  final Exception exception;

  UnknownInternalException(this.exception);

  @override
  String message(SharezoneLocalizations l10n) => exception.toString();
}

abstract class FirebaseException implements InternalException {
  /// Fehlername der Exception, wie z.B. "ERROR_CREDENTIAL_ALREADY_IN_USE"
  String get code;
}

class FirebaseCredentialAlreadyInUseException implements FirebaseException {
  @override
  String get code => "credential-already-in-use";

  @override
  String message(SharezoneLocalizations l10n) =>
      l10n.commonErrorCredentialAlreadyInUse;
}

class FirebaseEmailAlreadyInUseException implements FirebaseException {
  @override
  String get code => "email-already-in-use";

  @override
  String message(SharezoneLocalizations l10n) =>
      l10n.commonErrorEmailAlreadyInUse;
}
