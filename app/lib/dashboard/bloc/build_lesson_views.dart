// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'dashboard_bloc.dart';

List<LessonView> _buildSortedViews(LessonDataSnapshot lessonsSnapshot) {
  GroupInfo? groupInfoOf(Lesson lesson) =>
      lessonsSnapshot.groupInfos[lesson.groupID];

  final lessons = lessonsSnapshot.lessons;
  _sortLessonsByStartTime(lessons);

  final views = [
    for (final lesson in lessons)
      _buildLessonView(lesson, groupInfo: groupInfoOf(lesson))
  ];

  return views;
}

LessonView _buildLessonView(Lesson lesson, {GroupInfo? groupInfo}) {
  final timeline = _getTimeStatus(lesson.startTime, lesson.endTime);
  return LessonView(
    start: lesson.startTime.toString(),
    end: lesson.endTime.toString(),
    lesson: lesson,
    room: lesson.place,
    design: groupInfo?.design ?? Design.standard(),
    abbreviation: groupInfo?.abbreviation ?? "",
    timeStatus: timeline,
    percentTimePassed:
        _getPercentTimePassed(lesson.startTime, lesson.endTime, timeline),
    periodNumber: lesson.periodNumber.toString(),
  );
}

/// Berechnet, wie viel Prozent der Stunden schon vorbei sind.
double _getPercentTimePassed(Time start, Time end, LessonTimeStatus timeline) {
  if (timeline == LessonTimeStatus.isYetToCome) {
    return 0.0;
  } else if (timeline == LessonTimeStatus.hasAlreadyTakenPlace) {
    return 1.0;
  }

  final currentTime = Time.now();
  final lengthInMinutes = end.totalMinutes - start.totalMinutes;
  final passedMinutes = currentTime.totalMinutes - start.totalMinutes;
  return (100 * passedMinutes / lengthInMinutes) / 100;
}

/// Berechnet, ob die Schulstunde in der Vergangenheit stattgefunden hat, jetzt oder
/// in der Zukunft stattfindet.
LessonTimeStatus _getTimeStatus(Time start, Time end) {
  final currentTime = Time.now();
  if (currentTime.isAfter(end) || currentTime == end) {
    return LessonTimeStatus.hasAlreadyTakenPlace;
  } else if (currentTime.isBefore(start)) {
    return LessonTimeStatus.isYetToCome;
  }
  return LessonTimeStatus.isNow;
}

void _sortLessonsByStartTime(List<Lesson> lessons) =>
    lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
