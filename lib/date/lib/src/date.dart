// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:intl/intl.dart';
import 'weekday.dart';

class Date {
  final String _iso8601String;

  factory Date(String dateString) {
    return Date._(dateString);
  }

  factory Date.parse(dynamic dateString) {
    if (dateString != null && dateString is String) {
      return Date._(dateString);
    } else {
      return null;
    }
  }

  const Date._(this._iso8601String);

  factory Date.fromDateTime(DateTime dateTime) {
    if (dateTime == null) return null;
    return Date._(dateTime.toIso8601String().substring(0, 10));
  }

  factory Date.today() => Date.fromDateTime(DateTime.now());

  /// Gibt das aktuelle [Date] als Stream zurück.
  ///
  /// Gibt ein [Date] nur am Anfang des Streams und bei Änderung des aktuellen
  /// [Date] zurück (wenn der Tag wechselt).
  /// Gibt also nicht mehrmals das selbe [Date] aus.
  static Stream<Date> streamToday({
    /// Wie oft überprüft wird, ob sich das aktuelle [Date] geändert hat.
    /// Falls [refreshRate] z.B. eine Sekunde ist, dann wird jede Sekunde eine
    /// Änderung von [Date.today] geprüft.
    Duration refreshRate = const Duration(seconds: 1),
  }) {
    return Stream.periodic(refreshRate).map((_) => Date.today()).distinct();
  }

  @override
  int get hashCode => _iso8601String.hashCode;

  @override
  bool operator ==(other) {
    return other is Date && _iso8601String == other._iso8601String;
  }

  @override
  String toString() {
    return _iso8601String;
  }

  bool isAfter(Date other) {
    return _iso8601String.compareTo(other._iso8601String) > 0;
  }

  bool isSameDay(Date other) {
    return _iso8601String == other._iso8601String;
  }

  bool isBefore(Date other) {
    return _iso8601String.compareTo(other._iso8601String) < 0;
  }

  bool isInsideDateRange(Date start, Date end) {
    // CHECKS IF DATE IS AT THE INTERVALL ENDS
    if (isSameDay(start) || isSameDay(end)) return true;
    // CHECKS IF DATE IS BETWEEN START AND END
    return isAfter(start) && isBefore(end);
  }

  int get weekDay => toDateTime.weekday;

  int get dayOfMonth => toDateTime.day;

  WeekDay get weekDayEnum => WeekDay.values[weekDay - 1];

  int get weekNumber => getWeekNumber(toDateTime);

  String get toDateString => _iso8601String;

  DateTime get toDateTime => DateTime.parse(_iso8601String);

  int get year => toDateTime.year;

  int get month => toDateTime.month;

  int get day => toDateTime.day;

  DateParser get parser => DateParser(this);

  // HOURS IS SET TO 2 IN ORDER TO PREVENT ISSUES WITH CHANGES OF TIME => E.G. OCTOBER AND MARCH
  Date addDays(int days) {
    return Date.fromDateTime(toDateTime.add(Duration(days: days, hours: 2)));
  }
}

class DateParser {
  final Date _date;

  const DateParser(this._date);

  String get toYMMMEd {
    return DateFormat.yMMMEd().format(_date.toDateTime);
  }

  String get toYMMMd {
    return DateFormat.yMMMd().format(_date.toDateTime);
  }

  String get toMMMEd {
    return DateFormat.MMMEd().format(_date.toDateTime);
  }

  String get toYMMMMEEEEd {
    return DateFormat.yMMMMEEEEd().format(_date.toDateTime);
  }

  String get toMMM {
    return DateFormat.MMM().format(_date.toDateTime);
  }
}

int getWeekNumber(DateTime date) {
  final dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
