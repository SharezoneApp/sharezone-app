// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:date/weektype.dart';
import 'package:equatable/equatable.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/sharezone_rewrapped/sharezone_rewrapped_repository.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';

class SharezoneRewrappedController {
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;
  final SharezoneRewrappedRepository repository;

  const SharezoneRewrappedController({
    required this.repository,
    required this.crashAnalytics,
    required this.analytics,
  });

  Future<SharezoneRewrappedValues> getValues() async {
    try {
      final courses = repository.getCourses();
      final courseIds = courses.map((course) => CourseId(course.id)).toList();

      final (
        lessons,
        totalAmountOfHomeworks,
        totalAmountOfExams,
        homeworkTopThreeCourses,
        examTopThreeCourses,
      ) = await (
        repository.getLessons(),
        repository.getTotalAmountOfHomeworks(),
        repository.getTotalAmountOfExams(),
        _getHomeworkTopThreeCourses(courseIds),
        _getExamTopThreeCourses(courseIds),
      ).wait;

      final totalAmountOfLessonHours = _getTotalAmountOfLessonHours(lessons);
      final lessonHoursTopThreeCourses =
          _getLessonHoursTopThreeCourses(courseIds, lessons);

      _logGenerationAnalytics();

      return SharezoneRewrappedValues(
        totalAmountOfLessonHours: totalAmountOfLessonHours,
        amountOfLessonHoursTopThreeCourses:
            lessonHoursTopThreeCourses.withCourseName(courses),
        totalAmountOfHomeworks: totalAmountOfHomeworks ?? 0,
        amountOfHomeworksTopThreeCourses:
            homeworkTopThreeCourses.withCourseName(courses),
        totalAmountOfExams: totalAmountOfExams ?? 0,
        amountOfExamsTopThreeCourses:
            examTopThreeCourses.withCourseName(courses),
      );
    } catch (e, s) {
      crashAnalytics.recordError(
          'Failed to get values for SharezoneRewrapped: $e', s);
      rethrow;
    }
  }

  void _logGenerationAnalytics() {
    analytics.log(NamedAnalyticsEvent(name: 'sz_rewrapped_generated'));
  }

  /// Calculates the amount of lesson hours per course per school year.
  ///
  /// The amount of lesson hours is calculated by summing up the duration of all
  /// lessons per course.
  ///
  /// We assume that a student has 40 school weeks per year. Source:
  /// https://www.perplexity.ai/search/Wie-viele-Schulwochen-PKOcR28uRe2vga9SuurUcA#0
  List<(CourseId, int)> _getAmountOfLessonHoursPerCourse(List<Lesson> lessons) {
    final lessonMinutesPerCourse = <CourseId, int>{};
    for (final lesson in lessons) {
      final courseId = CourseId(lesson.groupID);
      int lessonMinutes = lesson.endTime.differenceInMinutes(lesson.startTime);

      if (lesson.weektype != WeekType.always) {
        // When the lesson is only every second week, we only count half of the
        // lesson minutes.
        //
        // This calculation will break if support a,b,c or a,b,c,d week types.
        lessonMinutes = lessonMinutes ~/ 2;
      }

      lessonMinutesPerCourse[courseId] =
          (lessonMinutesPerCourse[courseId] ?? 0) + lessonMinutes;
    }

    return lessonMinutesPerCourse.entries
        // Divide by 60 to get the amount of hours.
        .map((entry) => (entry.key, entry.value ~/ 60))
        .toList();
  }

  int _getTotalAmountOfLessonHours(List<Lesson> lessons) {
    final perCourses = _getAmountOfLessonHoursPerCourse(lessons);
    return perCourses.map((entry) => entry.$2).fold(0, (a, b) => a + b);
  }

  List<(CourseId, int)> _getLessonHoursTopThreeCourses(
      List<CourseId> courseIds, List<Lesson> lessons) {
    final perCourses = _getAmountOfLessonHoursPerCourse(lessons);
    final sorted = perCourses.toList()..sort((a, b) => b.$2.compareTo(a.$2));
    return sorted.take(3).toList();
  }

  Future<List<(CourseId, int)>> _getHomeworkTopThreeCourses(
      List<CourseId> courseIds) async {
    return _getTopThreeCourses(
      courseIds,
      (courseId) => repository.getAmountOfHomeworksFor(courseId: courseId),
    );
  }

  // get top exam courses
  Future<List<(CourseId, int)>> _getExamTopThreeCourses(
      List<CourseId> courseIds) async {
    return _getTopThreeCourses(
      courseIds,
      (courseId) => repository.getAmountOfExamsFor(courseId: courseId),
    );
  }

  Future<List<(CourseId, int)>> _getTopThreeCourses(
    List<CourseId> courseIds,
    Future<int?> Function(CourseId) getAmount,
  ) async {
    final amounts = await Future.wait(courseIds.map((courseId) {
      return getAmount(courseId);
    }));
    final amountsSorted = amounts
        .asMap()
        .entries
        .map((entry) => MapEntry(courseIds[entry.key], entry.value))
        .toList();
    amountsSorted.sort((a, b) => (b.value ?? 0).compareTo(a.value ?? 0));
    final topThreeCourses = amountsSorted.take(3).toList();
    return topThreeCourses
        .map((entry) => (entry.key, entry.value ?? 0))
        .toList();
  }
}

extension on List<(CourseId, int)> {
  List<(CourseId, CourseName, int)> withCourseName(List<Course> courses) {
    return map((entry) {
      final course =
          courses.firstWhere((course) => course.id == entry.$1.value);
      return (entry.$1, course.name, entry.$2);
    }).toList();
  }
}

class SharezoneRewrappedValues extends Equatable {
  final int totalAmountOfLessonHours;
  final List<(CourseId, CourseName, int)> amountOfLessonHoursTopThreeCourses;
  final int totalAmountOfHomeworks;
  final List<(CourseId, CourseName, int)> amountOfHomeworksTopThreeCourses;
  final int totalAmountOfExams;
  final List<(CourseId, CourseName, int)> amountOfExamsTopThreeCourses;

  const SharezoneRewrappedValues({
    required this.totalAmountOfLessonHours,
    required this.amountOfLessonHoursTopThreeCourses,
    required this.totalAmountOfHomeworks,
    required this.amountOfHomeworksTopThreeCourses,
    required this.totalAmountOfExams,
    required this.amountOfExamsTopThreeCourses,
  });

  @override
  List<Object?> get props => [
        totalAmountOfLessonHours,
        amountOfLessonHoursTopThreeCourses,
        totalAmountOfHomeworks,
        amountOfHomeworksTopThreeCourses,
        totalAmountOfExams,
        amountOfExamsTopThreeCourses,
      ];
}
