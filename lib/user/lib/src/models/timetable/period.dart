// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

import 'package:quiver/core.dart';

const Periods standardPeriods = Periods({
  1: Period(
    number: 1,
    startTime: Time.parse("7:30"),
    endTime: Time.parse("8:30"),
  ),
  2: Period(
    number: 2,
    startTime: Time.parse("8:35"),
    endTime: Time.parse("9:35"),
  ),
  3: Period(
    number: 3,
    startTime: Time.parse("9:55"),
    endTime: Time.parse("10:55"),
  ),
  4: Period(
    number: 4,
    startTime: Time.parse("11:00"),
    endTime: Time.parse("12:00"),
  ),
  5: Period(
    number: 5,
    startTime: Time.parse("12:05"),
    endTime: Time.parse("13:05"),
  ),
  6: Period(
    number: 6,
    startTime: Time.parse("13:30"),
    endTime: Time.parse("14:30"),
  ),
  7: Period(
    number: 7,
    startTime: Time.parse("14:35"),
    endTime: Time.parse("15:35"),
  ),
});

class Period {
  final int number;
  final Time startTime, endTime;

  const Period(
      {@required this.number,
      @required this.startTime,
      @required this.endTime});

  factory Period.fromData(
      {@required int number, @required Map<String, dynamic> data}) {
    return Period(
      number: number,
      startTime: Time.parse(data['startTime']),
      endTime: Time.parse(data['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.time,
      'endTime': endTime.time,
    };
  }

  bool includesTime(Time time) {
    final startTimeIsSameOrBefore =
        startTime.isBefore(time) || startTime == time;
    final endTimeIsSameOrAfter = endTime.isAfter(time) || endTime == time;
    return startTimeIsSameOrBefore && endTimeIsSameOrAfter;
  }

  bool isBeforePeriod(Period previous) {
    if (previous == null) return false;
    return startTime.totalMinutes < previous.endTime.totalMinutes;
  }

  bool isAfterPeriod(Period next) {
    if (next == null) return false;
    return endTime.totalMinutes > next.startTime.totalMinutes;
  }

  bool validate() {
    if (startTime == null) return false;
    if (endTime == null) return false;
    if (startTime.totalMinutes > endTime.totalMinutes) return false;
    return true;
  }

  @override
  bool operator ==(other) {
    return other is Period &&
        number == other.number &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }

  @override
  int get hashCode {
    return hash3(number, startTime, endTime);
  }

  Period copyWith({
    Time startTime,
    Time endTime,
  }) {
    return Period(
      number: number,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class Periods {
  final Map<int, Period> _data;

  const Periods(this._data);

  factory Periods.fromData(Map<String, dynamic> data) {
    if (data == null) return standardPeriods;
    return Periods(
      decodeMap(
        data,
        (key, value) => Period.fromData(number: int.parse(key), data: value),
      ).map((key, value) => MapEntry(int.parse(key), value)),
    );
  }

  Map<String, dynamic> toJson() {
    return _data.map((key, value) =>
        MapEntry(key.toString(), value?.toJson() ?? emptyFirestoreValue()));
  }

  Period getPeriod(int number) {
    return _data[number];
  }

  List<Period> getPeriods() {
    return _data.values.where((period) => period != null).toList()
      ..sort((p1, p2) => p1.number.compareTo(p2.number));
  }

  Periods copyWithAddPeriod() {
    final newData = Map.of(_data);
    final newPeriod = _internalCalculatePossibleNextPeriod();
    if (newPeriod == null) {
      return Periods(newData);
    }
    newData[newPeriod.number] = newPeriod;
    return Periods(newData);
  }

  Period _internalCalculatePossibleNextPeriod() {
    if (getPeriods().isEmpty) {
      return Period(
          number: 1, startTime: Time(hour: 7), endTime: Time(hour: 8));
    } else {
      final lastPeriod = getPeriods()?.last;
      final durationOfLastPeriod =
          lastPeriod.endTime.differenceInMinutes(lastPeriod.startTime);
      final newEndTime =
          lastPeriod.endTime.copyWithAddedMinutes(durationOfLastPeriod);

      if (newEndTime.isAfter(Time(hour: 24))) return null;

      final newPeriod = Period(
          number: lastPeriod.number + 1,
          startTime: lastPeriod.endTime,
          endTime: newEndTime);

      return newPeriod;
    }
  }

  Periods copyWithEditPeriod(Period period) {
    final newData = Map.of(_data);
    newData[period.number] = period;
    return Periods(newData);
  }

  Periods copyWithRemovedPeriod(Period period) {
    final newData = Map.of(_data);
    if (newData.isNotEmpty) {
      newData[period.number] = null;
    }
    return Periods(newData);
  }

  bool validate() {
    Time lastTime;
    for (final period in _data.values) {
      if (period == null) return false;
      if (!period.validate()) return false;
      if (lastTime != null) {
        if (period.startTime.isBefore(lastTime)) return false;
      }
      lastTime = period.endTime;
    }
    return true;
  }

  bool isCloseToAnyPeriod(Time time) {
    for (final period in _data.values) {
      // Checks if time is in Period
      if (period.includesTime(time)) return true;
      if (period.startTime.differenceInMinutes(time) <= 30) return true;
      if (period.endTime.differenceInMinutes(time) <= 30) return true;
    }
    return false;
  }
}
