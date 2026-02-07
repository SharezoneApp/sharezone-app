// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:time/time.dart';
import 'package:date/weektype.dart';
import 'package:user/src/models/timetable/enabled_weekdays.dart';
import 'package:user/src/models/timetable/period.dart';

const defaultIsABWeekEnabled = false;
const defaultIsAWeekEvenWeek = true;
final defaultTimetableStartTime = Time(hour: 7, minute: 30);
const defaultPeriods = standardPeriods;
const defaultEnabledWeekDays = EnabledWeekDays.standard;
const defaultShowAbbreviation = true;
const defaultOpenUpcomingWeekOnNonSchoolDays = true;

class UserSettings {
  final Time timetableStartTime;
  final bool isABWeekEnabled;
  final bool isAWeekEvenWeek;
  final bool showAbbreviation;
  final bool openUpcomingWeekOnNonSchoolDays;
  final Periods periods;
  final EnabledWeekDays enabledWeekDays;

  UserSettings._({
    required this.isABWeekEnabled,
    required this.isAWeekEvenWeek,
    required this.timetableStartTime,
    required this.periods,
    required this.showAbbreviation,
    required this.openUpcomingWeekOnNonSchoolDays,
    required this.enabledWeekDays,
  });

  factory UserSettings.defaultSettings() {
    return UserSettings._(
      isABWeekEnabled: defaultIsABWeekEnabled,
      isAWeekEvenWeek: defaultIsAWeekEvenWeek,
      timetableStartTime: defaultTimetableStartTime,
      showAbbreviation: defaultShowAbbreviation,
      openUpcomingWeekOnNonSchoolDays: defaultOpenUpcomingWeekOnNonSchoolDays,
      periods: defaultPeriods,
      enabledWeekDays: defaultEnabledWeekDays,
    );
  }

  factory UserSettings.fromData(Map<String, dynamic>? data) {
    if (data == null) {
      return UserSettings.defaultSettings();
    } else {
      return UserSettings._(
        isABWeekEnabled: data['isABWeekEnabled'] ?? defaultIsABWeekEnabled,
        isAWeekEvenWeek: data['isAWeekEvenWeek'] ?? defaultIsAWeekEvenWeek,
        timetableStartTime:
            data['timetableStartTime'] != null
                ? Time.parse(data['timetableStartTime'])
                : defaultTimetableStartTime,
        periods: Periods.fromData(data['periods']),
        showAbbreviation: data['showAbbreviation'] ?? defaultShowAbbreviation,
        openUpcomingWeekOnNonSchoolDays:
            data['openUpcomingWeekOnNonSchoolDays'] ??
            defaultOpenUpcomingWeekOnNonSchoolDays,
        enabledWeekDays: EnabledWeekDays.fromData(data['enabledWeekDays']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'isABWeekEnabled': isABWeekEnabled,
      'isAWeekEvenWeek': isAWeekEvenWeek,
      'timetableStartTime': timetableStartTime.time,
      'periods': periods.toJson(),
      'showAbbreviation': showAbbreviation,
      'openUpcomingWeekOnNonSchoolDays': openUpcomingWeekOnNonSchoolDays,
      'enabledWeekDays': enabledWeekDays.toJson(),
    };
  }

  UserSettings copyWith({
    bool? isABWeekEnabled,
    bool? isAWeekEvenWeek,
    bool? showAbbreviation,
    bool? openUpcomingWeekOnNonSchoolDays,
    Time? timetableStartTime,
    Periods? periods,
    EnabledWeekDays? enabledWeekDays,
  }) {
    return UserSettings._(
      isABWeekEnabled: isABWeekEnabled ?? this.isABWeekEnabled,
      isAWeekEvenWeek: isAWeekEvenWeek ?? this.isAWeekEvenWeek,
      timetableStartTime: timetableStartTime ?? this.timetableStartTime,
      periods: periods ?? this.periods,
      showAbbreviation: showAbbreviation ?? this.showAbbreviation,
      openUpcomingWeekOnNonSchoolDays:
          openUpcomingWeekOnNonSchoolDays ??
          this.openUpcomingWeekOnNonSchoolDays,
      enabledWeekDays: enabledWeekDays ?? this.enabledWeekDays,
    );
  }

  WeekType getWeekTypeOfDate(Date date) {
    if (!isABWeekEnabled) return WeekType.always;
    final isWeekEven = date.weekNumber.isEven;
    if (isWeekEven) {
      return isAWeekEvenWeek ? WeekType.a : WeekType.b;
    } else {
      return isAWeekEvenWeek ? WeekType.b : WeekType.a;
    }
  }
}
