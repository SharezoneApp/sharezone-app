import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:time/time.dart';

class Lesson {
  final String lessonID, groupID;
  final GroupType groupType;
  final Date startDate, endDate;
  final Time startTime, endTime;
  final int periodNumber;
  final WeekDay weekday;
  final WeekType weektype;
  final String teacher, place;
  LessonLength get length => calculateLessonLength(startTime, endTime);

  Lesson(
      {@required this.lessonID,
      @required this.groupID,
      @required this.groupType,
      this.startDate,
      this.endDate,
      this.periodNumber,
      @required this.startTime,
      @required this.endTime,
      @required this.weekday,
      @required this.weektype,
      @required this.teacher,
      @required this.place});

  factory Lesson.fromData(Map<String, dynamic> data, {@required String id}) {
    return Lesson(
      lessonID: id,
      groupID: data['groupID'] as String,
      groupType: groupTypeFromString(data['groupType'] as String),
      startDate: Date.parse(data['startDate']),
      endDate: Date.parse(data['endDate']),
      startTime: Time.parse(data['startTime'] as String),
      endTime: Time.parse(data['endTime'] as String),
      periodNumber: data['periodNumber'] as int,
      weekday: weekDayEnumFromString(data['weekday'] as String),
      weektype: weekTypeEnumFromString(data['weektype'] as String),
      teacher: data['teacher'] as String,
      place: data['place'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupType': groupTypeToString(groupType),
      'startDate': startDate?.toDateString,
      'endDate': endDate?.toDateString,
      'startTime': startTime?.time,
      'endTime': endTime?.time,
      'periodNumber': periodNumber,
      'weekday': weekDayEnumToString(weekday),
      'weektype': weekTypeEnumToString(weektype),
      'teacher': teacher,
      'place': place,
    };
  }

  Lesson copyWith(
      {String lessonID,
      String groupID,
      GroupType groupType,
      Date startDate,
      Date endDate,
      Time startTime,
      Time endTime,
      int periodNumber,
      WeekDay weekday,
      WeekType weektype,
      String teacher,
      String place}) {
    return Lesson(
      groupType: groupType ?? this.groupType,
      lessonID: lessonID ?? this.lessonID,
      groupID: groupID ?? this.groupID,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      periodNumber: periodNumber ?? this.periodNumber,
      weekday: weekday ?? this.weekday,
      weektype: weektype ?? this.weektype,
      teacher: teacher ?? this.teacher,
      place: place ?? this.place,
    );
  }

  @override
  String toString() {
    return "Lesson: id:$lessonID, groupId: $groupID";
  }
}

LessonLength calculateLessonLength(Time start, Time end) {
  final startTimeDate = _parseTimeString(start.time);
  final endTimeDate = _parseTimeString(end.time);

  final lengthInMinutes = endTimeDate.difference(startTimeDate).inMinutes;
  return LessonLength(lengthInMinutes);
}

DateTime _parseTimeString(String time) {
  return DateTime(
      2019, 1, 1, int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
}
