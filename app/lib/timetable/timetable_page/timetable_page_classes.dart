import 'package:collection/collection.dart';

class HourView {
  final int index;
  final String subject;
  final String room;

  const HourView({this.index, this.subject, this.room});

  @override
  String toString() {
    return "$runtimeType(index: $index, subject: $subject, room: $room)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourView &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          subject == other.subject &&
          room == other.room;

  @override
  int get hashCode => index.hashCode ^ subject.hashCode ^ room.hashCode;
}

class DayView {
  final String abbreviation;
  List<HourView> hours;

  DayView({this.abbreviation, this.hours}) {
    hours ??= [];
  }

  @override
  String toString() {
    return "$runtimeType(hours: $hours, abbreviation: $abbreviation)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayView &&
          runtimeType == other.runtimeType &&
          abbreviation == other.abbreviation;

  @override
  int get hashCode => abbreviation.hashCode ^ hours.hashCode;
}

class WeekView {
  final List<DayView> days;
  ListEquality<DayView> get equality => const ListEquality<DayView>();

  WeekView({this.days});

  int get length => days.length;

  @override
  String toString() {
    return "$runtimeType(days: $days)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekView &&
          runtimeType == other.runtimeType &&
          ListEquality<DayView>().equals(days, other.days);

  @override
  int get hashCode => equality.hash(days);
}
