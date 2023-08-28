// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'dashboard_bloc.dart';

/// Return the index of the lesson that is
/// a. currently taking place [LessonTimeStatus.isNow]
/// b. the next lesson if there is no lesson taking place right now
///    (no lesson has [LessonTimeStatus.isNow])
///
/// If no lesson has started yet it will return 0 (first lesson).
/// If every lesson has already passed it will throw [AllLessonsAreOverException].
///
/// Example:
/// We have the lessons [maths, english, german].
/// If english is currently taking place ([LessonView.timeStatus] ==
/// [LessonTimeStatus.isNow]) this function will return 1.
int getCurrentLessonIndex(List<LessonView> lessons) {
  // School hasn't begun yet.
  if (lessons
      .every((lesson) => lesson.timeStatus == LessonTimeStatus.isYetToCome)) {
    return 0;
  }

  // School is over.
  if (lessons.every(
      (lesson) => lesson.timeStatus == LessonTimeStatus.hasAlreadyTakenPlace))
    throw AllLessonsAreOverException();

  // If a lesson is currently taking place return its index.
  for (int i = 0; i < lessons.length; i++) {
    if (lessons[i].timeStatus == LessonTimeStatus.isNow) return i;
  }

  // If no lesson is currently taking place (e.g. lunch break) we return the
  // index of the next lesson to come.
  if (lessons.length >= 2) {
    for (int i = 1; i < lessons.length; i++) {
      if (lessons[i - 1].timeStatus == LessonTimeStatus.hasAlreadyTakenPlace &&
          lessons[i].timeStatus == LessonTimeStatus.isYetToCome) return i;
    }
  }

  return 0;
}

class AllLessonsAreOverException implements Exception {}
