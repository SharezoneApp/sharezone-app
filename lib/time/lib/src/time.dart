// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class Time {
  final String _time;

  factory Time({required int hour, int minute = 0}) {
    return Time._(_formatTime(hour: hour, minute: minute));
  }

  const Time._(this._time);

  factory Time.now() {
    return Time.fromTimeOfDay(TimeOfDay.now());
  }

  const factory Time.parse(String timeString) = Time._;

  factory Time.fromTimeOfDay(TimeOfDay timeOfDay) {
    return Time._(_formatTime(hour: timeOfDay.hour, minute: timeOfDay.minute));
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

  /// Returns a localized time string using the current [BuildContext].
  String format(BuildContext context) {
    return toTimeOfDay().format(context);
  }

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

  static String _formatTime({required int hour, required int minute}) {
    return '${_pad2(hour)}:${_pad2(minute)}';
  }

  static String _pad2(int value) => value.toString().padLeft(2, '0');
}

extension DateTimeToTime on DateTime {
  Time toTime() {
    return Time.fromDateTime(this);
  }
}
