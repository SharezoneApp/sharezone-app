// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/weekday.dart';
import 'package:sharezone_common/helper_functions.dart';

const weekDayDefaults = {
  WeekDay.monday: true,
  WeekDay.tuesday: true,
  WeekDay.wednesday: true,
  WeekDay.thursday: true,
  WeekDay.friday: true,
  WeekDay.saturday: false,
  WeekDay.sunday: false,
};

class EnabledWeekDays {
  final Map<String, bool?> _internalMap;

  const EnabledWeekDays._(this._internalMap);

  static const EnabledWeekDays standard = EnabledWeekDays._({});

  factory EnabledWeekDays.fromData(Map<String, dynamic>? data) {
    return EnabledWeekDays._(decodeMap<bool?>(data, (key, value) => value));
  }

  bool? getValue(WeekDay weekDay) {
    return _internalMap[weekDay.name] ?? weekDayDefaults[weekDay];
  }

  EnabledWeekDays copyWith(WeekDay weekDay, bool newValue) {
    final newMap = Map.of(_internalMap);
    newMap[weekDay.name] = newValue;
    return EnabledWeekDays._(newMap);
  }

  List<WeekDay> getEnabledWeekDaysList() {
    return WeekDay.values.where((it) => getValue(it)!).toList();
  }

  Map<String?, bool?> toJson() {
    return _internalMap;
  }
}
