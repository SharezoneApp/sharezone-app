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
String? handleErrorMessage({
  required SharezoneLocalizations l10n,
  required Object? error,
  required StackTrace stackTrace,
}) {
  if (error == null) return null;

  if (error is TextValidationException && error.message != null) {
    return error.message;
  }

  final errorString = error.toString();

  if (error is IncorrectDataException ||
      errorString == IncorrectDataException().toString()) {
    return l10n.commonErrorIncorrectData;
  } else if (error is EmailIsMissingException ||
      errorString == EmailIsMissingException().toString()) {
    return l10n.commonErrorEmailMissing;
  } else if (error is PasswordIsMissingException ||
      errorString == PasswordIsMissingException().toString()) {
    return l10n.commonErrorPasswordMissing;
  } else if (error is NoGoogleSignAccountSelected ||
      errorString == NoGoogleSignAccountSelected().toString()) {
    return l10n.commonErrorNoGoogleAccountSelected;
  } else if (error is NoInternetAccess ||
      errorString == NoInternetAccess().toString()) {
    return l10n.commonErrorNoInternetAccess;
  } else if (errorString == "NewPasswordIsMissingException") {
    return l10n.commonErrorNewPasswordMissing;
  } else if (errorString.contains("wrong-password")) {
    return l10n.commonErrorWrongPassword;
  } else if (error is SubjectIsMissingException ||
      errorString == SubjectIsMissingException().toString()) {
    return l10n.commonErrorCourseSubjectMissing;
  } else if (error is InvalidTitleException ||
      errorString == InvalidTitleException().toString()) {
    return l10n.blackboardErrorTitleMissing;
  } else if (error is InvalidCourseException ||
      errorString == InvalidCourseException().toString()) {
    return l10n.blackboardErrorCourseMissing;
  } else if (error is InvalidStartTimeException ||
      errorString == InvalidStartTimeException().toString()) {
    return l10n.timetableErrorStartTimeMissing;
  } else if (error is MissingReportInformation ||
      errorString == MissingReportInformation.code) {
    return l10n.reportMissingInformation;
  } else if (error is NameIsMissingException ||
      errorString == NameIsMissingException.code) {
    return l10n.commonErrorNameTooShort;
  } else if (error is EmptyNameException ||
      errorString == EmptyNameException.code) {
    return l10n.commonErrorNameMissing;
  } else if (error is SameNameAsBefore ||
      errorString == SameNameAsBefore.code) {
    return l10n.commonErrorSameNameAsBefore;
  } else if (error is InvalidInputException ||
      errorString == InvalidInputException.code) {
    return l10n.commonErrorInvalidInput;
  } else if (error is SameNameException ||
      errorString == SameNameException.code) {
    return l10n.commonErrorNameUnchanged;
  } else if (error is IncorrectPeriods ||
      errorString == IncorrectPeriods.code) {
    return l10n.timetableErrorInvalidPeriodsOverlap;
  } else if (error is InvalidEndTimeException ||
      errorString == InvalidEndTimeException().toString()) {
    return l10n.timetableErrorEndTimeMissing;
  } else if (error is EndTimeIsBeforeStartTimeException ||
      errorString == EndTimeIsBeforeStartTimeException().toString()) {
    return l10n.timetableErrorEndTimeBeforeStartTime;
  } else if (error is StartTimeIsBeforeStartTimeOfNextLessonException ||
      errorString ==
          StartTimeIsBeforeStartTimeOfNextLessonException().toString()) {
    return l10n.timetableErrorStartTimeBeforeNextLessonStart;
  } else if (error is StartTimeEndTimeIsEqualException ||
      errorString == StartTimeEndTimeIsEqualException().toString()) {
    return l10n.timetableErrorStartTimeEqualsEndTime;
  } else if (error is StartTimeIsBeforeEndTimeOfPreviousLessonException ||
      errorString ==
          StartTimeIsBeforeEndTimeOfPreviousLessonException().toString()) {
    return l10n.timetableErrorStartTimeBeforePreviousLessonEnd;
  } else if (error is EndTimeIsBeforeStartTimeOfNextLessonException ||
      errorString ==
          EndTimeIsBeforeStartTimeOfNextLessonException().toString()) {
    return l10n.timetableErrorEndTimeBeforeNextLessonStart;
  } else if (error is EndTimeIsBeforeEndTimeOfPreviousLessonException ||
      errorString ==
          EndTimeIsBeforeEndTimeOfPreviousLessonException().toString()) {
    return l10n.timetableErrorEndTimeBeforePreviousLessonEnd;
  } else if (error is InvalidWeekDayException ||
      errorString == InvalidWeekDayException().toString()) {
    return l10n.timetableErrorWeekdayMissing;
  } else if (error is InvalidDateException ||
      errorString == InvalidDateException().toString()) {
    return l10n.commonErrorDateMissing;
  } else if (errorString == "InvalidTitleSubject") {
    return l10n.commonErrorTitleMissing;
  } else if (errorString.contains("invalid-email")) {
    return l10n.commonErrorEmailInvalidFormat;
  } else if (errorString.contains("email-already-in-use")) {
    return l10n.commonErrorEmailAlreadyInUse;
  } else if (errorString.contains("user-disabled")) {
    return l10n.commonErrorUserDisabled;
  } else if (errorString.contains("too-many-requests")) {
    return l10n.commonErrorTooManyRequests;
  } else if (errorString.contains("user-not-found")) {
    return l10n.commonErrorUserNotFound;
  } else if (errorString.contains("network-request-failed")) {
    return l10n.commonErrorNetworkRequestFailed;
  } else if (errorString.contains("weak-password")) {
    return l10n.commonErrorWeakPassword;
  } else if (errorString.contains(
    "sign_in_failed, com.google.GlDSignIn, keychain error",
  )) {
    // See https://github.com/SharezoneApp/sharezone-app/issues/1724
    return l10n.commonErrorKeychainSignInFailed;
  } else if (error is IncorrectSharecode ||
      errorString == IncorrectSharecode.code) {
    return l10n.commonErrorIncorrectSharecode;
  }

  recordError(error, stackTrace);
  return l10n.commonErrorUnknown(errorString);
}

void recordError(Object e, StackTrace s) =>
    getCrashAnalytics().recordError(e.toString(), s);
