// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:design/design.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/dashboard/bloc/dashboard_bloc.dart';
import 'package:sharezone/dashboard/timetable/lesson_view.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:time/time.dart';

void main() {
  LessonView getLessonViewWithTimeStatus(LessonTimeStatus timeline) {
    return LessonView(
      start: "8:00",
      end: "9:00",
      room: "100",
      abbreviation: "D",
      design: Design.standard(),
      lesson: Lesson(
        lessonID: "1",
        groupID: "1",
        groupType: GroupType.course,
        startDate: null,
        endDate: null,
        startTime: const Time.parse("8:00"),
        endTime: const Time.parse("9:00"),
        periodNumber: 1,
        weekday: WeekDay.monday,
        weektype: WeekType.always,
        teacher: "teacher",
        place: "100",
      ),
      timeStatus: timeline,
      percentTimePassed: 0,
      periodNumber: null,
    );
  }

  group('validate getCurrentLessonIndex()', () {
    test('school has not started yet', () {
      final onlyYetToComeViews = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(onlyYetToComeViews), 0);
    });

    test('school is over', () {
      final schoolIsOver = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
      ];
      expect(() => getCurrentLessonIndex(schoolIsOver),
          throwsA(predicate((dynamic e) => e is AllLessonsAreOverException)));
    });

    test('first lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 0);
    });

    test('first lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 0);
    });

    test('second lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 1);
    });

    test('free lesson / break now, so pick the next lesson', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 1);
    });

    test('acceptance test', () {
      final lessons = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(lessons), 3);
    });
  });
}
