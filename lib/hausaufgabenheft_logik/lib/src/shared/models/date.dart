// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';

class Date extends Equatable implements Comparable<Date> {
  final int day;
  final int month;
  final int year;

  @override
  List<Object> get props => [day, month, year];

  const Date({required this.day, required this.month, required this.year});

  factory Date.now() {
    final now = clock.now();
    return Date(day: now.day, month: now.month, year: now.year);
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(year: dateTime.year, month: dateTime.month, day: dateTime.day);
  }

  DateTime asDateTime() => DateTime(year, month, day, 0, 0, 0, 0, 0);

  Date addDays(int daysToAdd) {
    final dateTime = asDateTime();
    DateTime newDateTime;
    newDateTime = dateTime.add(Duration(days: daysToAdd));
    return Date.fromDateTime(newDateTime);
  }

  @override
  int compareTo(Date other) {
    if (year.compareTo(other.year) != 0) {
      return year.compareTo(other.year);
    } else if (month.compareTo(other.month) != 0) {
      return month.compareTo(other.month);
    } else {
      return day.compareTo(other.day);
    }
  }

  bool operator >(Date other) {
    return compareTo(other) > 0;
  }

  bool operator <(Date other) {
    return compareTo(other) < 0;
  }
}
