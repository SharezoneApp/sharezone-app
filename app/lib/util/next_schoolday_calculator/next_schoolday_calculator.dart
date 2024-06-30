// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:date/date.dart';
import 'package:holidays/holidays.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class NextSchooldayCalculator {

  final UserGateway _userGateway;
  final HolidayService _holidayManager;

  NextSchooldayCalculator({
    required UserGateway userGateway,
    required HolidayService holidayManager,
  })  : 
        _userGateway = userGateway,
        _holidayManager = holidayManager;

  Future<Date?> tryCalculateNextSchoolday() async {
    return tryCalculateXNextSchoolday(inSchooldays: 1);
  }

  Future<Date?> tryCalculateXNextSchoolday(
      {int inSchooldays = 1}) async {
    assert(inSchooldays > 0);
    try {
      final user = await _userGateway.get();
      final enabledWeekdays = user.userSettings.enabledWeekDays;
      final holidays = await _tryLoadHolidays(user);
      final results =
          _NextSchooldayCaluclation(enabledWeekdays, holidays)
              .calculate(days: inSchooldays);
      if (results.isEmpty) return Date.today().addDays(1);
      return results.elementAt(inSchooldays - 1);
    } catch (e, s) {
      log('Could not calculate next schoolday: $e\n$s', error: e, stackTrace: s);
      return null;
    }
  }

  Future<List<Holiday?>> _tryLoadHolidays(AppUser user) async {
    try {
      return await _holidayManager.load(toStateOrThrow(user.state));
    } catch (e, s) {
      log('Could not load holidays for calculating next schooldays: $e',
          error: e, stackTrace: s);
      return [];
    }
  }
}

class _NextSchooldayCaluclation {
  final EnabledWeekDays enabledWeekdays;
  final List<Holiday?> holidays;

  _NextSchooldayCaluclation(this.enabledWeekdays, this.holidays);

  List<Date> calculate({int days = 3}) {
    if (enabledWeekdays.getEnabledWeekDaysList().isEmpty) return [];
    List<Date> results = [];
    Date date = Date.today();
    while (results.length < days) {
      // LOOP TO NEXT DAY
      date = date.addDays(1);
      // CHECKS IF IS HOLIDAY
      if (_isHolidayAt(date)) continue;
      if (!_isSchooldayAt(date)) continue;
      // ADDS DATE TO RESULTS
      results.add(date);
    }
    return results;
  }

  bool _isSchooldayAt(Date date) {
    return enabledWeekdays.getEnabledWeekDaysList().contains(date.weekDayEnum);
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
