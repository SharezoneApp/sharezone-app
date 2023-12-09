// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time {
  final String _time;

  factory Time({required int hour, int minute = 0}) {
    final numberFormat = NumberFormat(
      "00",
      // We need to set the locale to "de_DE", otherwise the number formatter
      // will use the device's locale, which can cause problems if the number
      // formatter does not work as we expect, e.g. if the device is set to
      // Arabic.
      //
      // If we go international with Sharezone, we should probably remove this
      // and instead use a number formatter that is locale independent.
      //
      // See: https://github.com/SharezoneApp/sharezone-app/issues/903
      "de_DE",
    );
    return Time._(
        "${numberFormat.format(hour)}:${numberFormat.format(minute)}");
  }

  const Time._(this._time);

  factory Time.now() {
    return Time.fromTimeOfDay(TimeOfDay.now());
  }

  const factory Time.parse(String timeString) = Time._;

  factory Time.fromTimeOfDay(TimeOfDay timeOfDay) {
    final numberFormat = NumberFormat("00");
    return Time._(
        "${numberFormat.format(timeOfDay.hour)}:${numberFormat.format(timeOfDay.minute)}");
  }

  factory Time.fromDateTime(DateTime dateTime) {
    return Time(hour: dateTime.hour, minute: dateTime.minute);
  }

  factory Time.fromTotalMinutes(int totalMinutes) {
    final hour = (totalMinutes ~/ 60) % 24;
    final minute = totalMinutes.remainder(60);
    return Time(hour: hour, minute: minute);
  }

  String get time => _time;

  int get hour => int.parse(_time.split(":")[0]);

  int get minute => int.parse(_time.split(":")[1]);

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: int.parse(_time.split(":")[0]),
      minute: int.parse(_time.split(":")[1]),
    );
  }

  int get totalMinutes => hour * 60 + minute;

  @override
  int get hashCode {
    return time.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is Time && totalMinutes == other.totalMinutes;
  }

  /// Addiert eine Duration zum Time-Objekt und gibt das Ergebnis zurück.
  /// Beispiel: 09:45 Uhr + 30 Min. = 10:15 Uhr
  ///
  /// Sollte das Ergebnis über 24 Stunden hinausgehen, fängt ein neuer "Tag"
  /// an. Beispiel: 23:59 Uhr + 2 Min. = 00:01 Uhr.
  Time add(Duration duration) {
    int hours = hour;
    int minutes = minute + duration.inMinutes;

    while (minutes >= 60) {
      minutes -= 60;
      hours = (hours + 1) % 24;
    }

    return Time(hour: hours, minute: minutes);
  }

  /// Returns a bool indicating whether the new time added to the [duration] is
  /// a new day.
  bool isNextDayWith(Duration duration) {
    const minutesOfADay = 24 * 60;
    return totalMinutes + duration.inMinutes >= minutesOfADay;
  }

  bool isBefore(Time other) {
    return totalMinutes < other.totalMinutes;
  }

  bool isAfter(Time other) {
    return totalMinutes > other.totalMinutes;
  }

  int differenceInMinutes(Time other) {
    return (totalMinutes - other.totalMinutes).abs();
  }

  int compareTo(Time other) {
    return totalMinutes.compareTo(other.totalMinutes);
  }

  @override
  String toString() {
    return _time;
  }
}

extension DateTimeToTime on DateTime {
  Time toTime() {
    return Time.fromDateTime(this);
  }
}
