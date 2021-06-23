import 'package:meta/meta.dart';

class Date implements Comparable<Date> {
  final int day;
  final int month;
  final int year;

  const Date({
    @required this.day,
    @required this.month,
    @required this.year,
  });

  factory Date.now() {
    final now = DateTime.now();
    return Date(day: now.day, month: now.month, year: now.year);
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(year: dateTime.year, month: dateTime.month, day: dateTime.day);
  }

  DateTime asDateTime() => DateTime(year, month, day, 0, 0, 0, 0, 0);

  bool operator >(Date other) {
    return compareTo(other) > 0;
  }

  bool operator <(Date other) {
    return compareTo(other) < 0;
  }

  @override
  bool operator ==(dynamic other) {
    return compareTo(other) == 0;
  }

  @override
  int compareTo(Date other) {
    assert(other != null);
    if (year > other.year) {
      return 1;
    } else if (year < other.year) {
      return -1;
    } else {
      if (month > other.month) {
        return 1;
      } else if (month < other.month) {
        return -1;
      } else {
        if (day > other.day) {
          return 1;
        } else if (day < other.day) {
          return -1;
        }
        return 0;
      }
    }
  }

  @override
  int get hashCode => day.hashCode ^ month.hashCode ^ year.hashCode;

  @override
  String toString() {
    return 'Date(day: $day, month: $month, year: $year)';
  }

  /// Does NOT roll over to the next month, just plain stupid addition
  Date addDaysWithNoChecking(int days) {
    return Date(year: year, month: month, day: day + days);
  }

  Date addDays(int daysToAdd) {
    final dateTime = asDateTime();
    DateTime newDateTime;
    newDateTime = dateTime.add(Duration(days: daysToAdd));
    return Date.fromDateTime(newDateTime);
  }
}
