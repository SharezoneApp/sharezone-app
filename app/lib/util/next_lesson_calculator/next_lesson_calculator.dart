// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:holidays/holidays.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class NextLessonCalculator {
  final TimetableGateway _timetableGateway;
  final UserGateway _userGateway;
  final HolidayService _holidayManager;

  NextLessonCalculator({
    required TimetableGateway timetableGateway,
    required UserGateway userGateway,
    required HolidayService holidayManager,
  })  : _timetableGateway = timetableGateway,
        _userGateway = userGateway,
        _holidayManager = holidayManager;

  Future<Date?> tryCalculateNextLesson(String courseID) async {
    return tryCalculateXNextLesson(courseID, inLessons: 1);
  }

  Future<Date?> tryCalculateXNextLesson(String courseID,
      {int inLessons = 1}) async {
    assert(inLessons > 0);
    try {
      final lessons = await _timetableGateway.getLessonsOfGroup(courseID);
      final user = await _userGateway.get();
      final holidays = await _tryLoadHolidays(user);
      final results =
          _NextLessonCalculation(lessons, holidays, user.userSettings)
              .calculate(days: inLessons);
      if (results.isEmpty) return null;
      return results.elementAt(inLessons - 1);
    } catch (e, s) {
      log('Could not calculate next lesson: $e\n$s', error: e, stackTrace: s);
      return null;
    }
  }

  Future<List<Holiday?>> _tryLoadHolidays(AppUser user) async {
    try {
      return await _holidayManager.load(toStateOrThrow(user.state));
    } catch (e, s) {
      log('Could not load holidays for calculating next lessons: $e',
          error: e, stackTrace: s);
      return [];
    }
  }
}

class _NextLessonCalculation {
  final List<Lesson> lessons;
  final List<Holiday?> holidays;
  final UserSettings userSettings;

  _NextLessonCalculation(this.lessons, this.holidays, this.userSettings);

  List<Date> calculate({int days = 3}) {
    if (lessons.isEmpty) return [];
    List<Date> results = [];
    Date date = Date.today();
    while (results.length < days) {
      // LOOP TO NEXT DAY
      date = date.addDays(1);
      // CHECKS IF IS HOLIDAY
      if (_isHolidayAt(date)) continue;
      if (!_areLessonsAt(date)) continue;
      // ADDS DATE TO RESULTS
      results.add(date);
    }
    return results;
  }

  bool _areLessonsAt(Date date) {
    WeekType weekType = userSettings.getWeekTypeOfDate(date);
    WeekDay weekDay = WeekDay.values[date.weekDay - 1];
    for (final lesson in lessons) {
      if (weekDay != lesson.weekday) continue;
      if (lesson.weektype == WeekType.always || weekType == WeekType.always) {
        return true;
      }
      if (weekType == lesson.weektype) return true;
    }
    return false;
  }

  bool _isHolidayAt(Date date) {
    for (final holiday in holidays) {
      Date start = Date.fromDateTime(holiday!.start);
      Date end = Date.fromDateTime(holiday.end);
      if (date.isInsideDateRange(start, end)) return true;
    }
    return false;
  }
}
