// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';

import 'weekday.dart';

class Date implements Comparable<Date> {
  final String _iso8601String;

  factory Date(String dateString) {
    return Date._(dateString);
  }

  factory Date.parse(String dateString) {
    return Date._(dateString);
  }

  static Date? parseOrNull(String? dateString) {
    if (dateString == null) return null;
    return Date._(dateString);
  }

  const Date._(this._iso8601String);

  factory Date.fromDateTime(DateTime dateTime) {
    return Date._(dateTime.toIso8601String().substring(0, 10));
  }

  factory Date.today() => Date.fromDateTime(clock.now());

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

  @override
  int compareTo(Date other) => _iso8601String.compareTo(other._iso8601String);
}

extension DateTimeToDate on DateTime {
  Date toDate() {
    return Date.fromDateTime(this);
  }
}

class DateParser {
  final Date _date;

  const DateParser(this._date);

  /// Cache DateFormat instances to avoid expensive recreation.
  /// We key by Intl.defaultLocale to support runtime language changes.
  static final _yMMMEdCache = <String?, DateFormat>{};
  static final _yMMMdCache = <String?, DateFormat>{};
  static final _mmmEdCache = <String?, DateFormat>{};
  static final _yMMMMEEEEdCache = <String?, DateFormat>{};
  static final _mmmCache = <String?, DateFormat>{};

  String get toYMMMEd {
    final locale = Intl.defaultLocale;
    final formatter = _yMMMEdCache.putIfAbsent(
      locale,
      () => DateFormat.yMMMEd(locale),
    );
    return formatter.format(_date.toDateTime);
  }

  String get toYMMMd {
    final locale = Intl.defaultLocale;
    final formatter = _yMMMdCache.putIfAbsent(
      locale,
      () => DateFormat.yMMMd(locale),
    );
    return formatter.format(_date.toDateTime);
  }

  String get toMMMEd {
    final locale = Intl.defaultLocale;
    final formatter = _mmmEdCache.putIfAbsent(
      locale,
      () => DateFormat.MMMEd(locale),
    );
    return formatter.format(_date.toDateTime);
  }

  String get toYMMMMEEEEd {
    final locale = Intl.defaultLocale;
    final formatter = _yMMMMEEEEdCache.putIfAbsent(
      locale,
      () => DateFormat.yMMMMEEEEd(locale),
    );
    return formatter.format(_date.toDateTime);
  }

  String get toMMM {
    final locale = Intl.defaultLocale;
    final formatter = _mmmCache.putIfAbsent(
      locale,
      () => DateFormat.MMM(locale),
    );
    return formatter.format(_date.toDateTime);
  }
}

final _weekNumberDateFormatCache = <String?, DateFormat>{};

int getWeekNumber(DateTime date) {
  final locale = Intl.defaultLocale;
  final formatter = _weekNumberDateFormatCache.putIfAbsent(
    locale,
    () => DateFormat("D", locale),
  );
  final dayOfYear = int.parse(formatter.format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
