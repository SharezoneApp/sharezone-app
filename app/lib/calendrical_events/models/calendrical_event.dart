import 'package:group_domain_models/group_domain_models.dart';

import 'package:meta/meta.dart';
import 'package:date/date.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:time/time.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'calendrical_event_change_type.dart';
import 'calendrical_event_types.dart';

class CalendricalEvent {
  final String eventID, groupID, authorID;
  final GroupType groupType;
  final CalendricalEventType eventType;
  final Date date;
  final Time startTime, endTime;
  final String title, detail, place;
  final Map<String, CalendricalEventChangeType> lessonChanges;
  final bool sendNotification;
  final String latestEditor;

  CalendricalEvent({
    @required this.eventID,
    @required this.groupID,
    @required this.groupType,
    @required this.eventType,
    @required this.authorID,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.title,
    @required this.detail,
    @required this.place,
    @required this.lessonChanges,
    @required this.sendNotification,
    @required this.latestEditor,
  });

  factory CalendricalEvent.fromData(Map<String, dynamic> data,
      {@required String id}) {
    return CalendricalEvent(
      eventID: id,
      groupID: data['groupID'] as String,
      authorID: data['authorID'] as String,
      date: Date.parse(data['date']),
      startTime: Time.parse(data['startTime'] as String),
      endTime: Time.parse(data['endTime'] as String),
      title: data['title'] as String,
      groupType: groupTypeFromString(data['groupType'] as String),
      eventType: getEventTypeFromString(data['eventType'] as String),
      detail: data['detail'] as String,
      place: data['place'] as String,
      lessonChanges: decodeMap(
          data['lessonChanges'],
          (key, value) =>
              enumFromString(CalendricalEventChangeType.values, value)),
      sendNotification: data['sendNotification'] as bool ?? false,
      latestEditor: data['latestEditor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupType': groupTypeToString(groupType),
      'eventType': getEventTypeToString(eventType),
      'authorID': authorID,
      'date': date.toDateString,
      'startTime': startTime.time,
      'endTime': endTime.time,
      'title': title,
      'detail': detail,
      'place': place,
      'lessonChanges':
          lessonChanges.map((key, value) => MapEntry(key, enumToString(value))),
      'sendNotification': sendNotification,
      'latestEditor': latestEditor,
    };
  }

  CalendricalEvent copyWith({
    String eventID,
    String groupID,
    String authorID,
    GroupType groupType,
    CalendricalEventType eventType,
    Date date,
    Time startTime,
    Time endTime,
    String title,
    String detail,
    String place,
    Map<String, CalendricalEventChangeType> lessonChanges,
    bool sendNotification,
    String latestEditor,
  }) {
    return CalendricalEvent(
      authorID: authorID ?? this.authorID,
      eventID: eventID ?? this.eventID,
      groupID: groupID ?? this.groupID,
      groupType: groupType ?? this.groupType,
      eventType: eventType ?? this.eventType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      place: place ?? this.place,
      lessonChanges: lessonChanges ?? this.lessonChanges,
      sendNotification: sendNotification ?? this.sendNotification,
      latestEditor: latestEditor ?? this.latestEditor,
    );
  }

  LessonLength get length => calculateLessonLength(startTime, endTime);

  DateTime get startDateTime => DateTime(
      date.year, date.month, date.day, startTime.hour, startTime.minute);

  DateTime get endDateTime =>
      DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
}
