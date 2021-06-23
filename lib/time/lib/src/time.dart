import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Time {
  final String _time;

  factory Time({@required int hour, int minute = 0}) {
    final numberFormat = NumberFormat("00");
    return Time._(
        "${numberFormat.format(hour)}:${numberFormat.format(minute)}");
  }

  const Time._(this._time);

  factory Time.now() {
    return Time.fromTimeOfDay(TimeOfDay.now());
  }

  const factory Time.parse(String timeString) = Time._;

  factory Time.fromTimeOfDay(TimeOfDay timeOfDay) {
    if (timeOfDay == null) return null;
    final numberFormat = NumberFormat("00");
    return Time._(
        "${numberFormat.format(timeOfDay.hour)}:${numberFormat.format(timeOfDay.minute)}");
  }

  factory Time.fromTotalMinutes(int totalMinutes) {
    final hour = totalMinutes ~/ 60;
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

  Time copyWithAddedMinutes(int addedMinutes) {
    final newTotalMinutes = totalMinutes + addedMinutes;
    return Time.fromTotalMinutes(newTotalMinutes);
  }

  @override
  String toString() {
    return _time;
  }
}
