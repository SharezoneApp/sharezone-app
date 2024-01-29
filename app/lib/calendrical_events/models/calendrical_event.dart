// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:time/time.dart';

import 'calendrical_event_types.dart';

class CalendricalEvent {
  /// The date and time when the event was created.
  ///
  /// Clients with a lower version than 1.7.9 will not have this field.
  /// Therefore, we will always have events without a [createdOn] field in the
  /// database.
  final DateTime? createdOn;

  final String eventID, groupID, authorID;
  final GroupType groupType;
  final CalendricalEventType eventType;
  final Date date;
  final Time startTime, endTime;
  final String title;
  final String? detail, place;
  final bool sendNotification;
  final String? latestEditor;

  CalendricalEvent({
    required this.createdOn,
    required this.eventID,
    required this.groupID,
    required this.groupType,
    required this.eventType,
    required this.authorID,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.detail,
    required this.place,
    required this.sendNotification,
    required this.latestEditor,
  });

  factory CalendricalEvent.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return CalendricalEvent(
      createdOn: dateTimeFromTimestampOrNull(data['createdOn']),
      eventID: id,
      groupID: data['groupID'] as String,
      authorID: data['authorID'] as String,
      date: Date.parse(data['date'] as String),
      startTime: Time.parse(data['startTime'] as String),
      endTime: Time.parse(data['endTime'] as String),
      title: data['title'] as String,
      groupType: GroupType.values.byName(data['groupType'] as String),
      eventType: getEventTypeFromString(data['eventType'] as String),
      detail: data['detail'] as String?,
      place: data['place'] as String?,
      sendNotification: (data['sendNotification'] as bool?) ?? false,
      latestEditor: data['latestEditor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupType': groupType.name,
      'eventType': getEventTypeToString(eventType),
      'authorID': authorID,
      'date': date.toDateString,
      'startTime': startTime.time,
      'endTime': endTime.time,
      'title': title,
      'detail': detail,
      'place': place,
      'sendNotification': sendNotification,
      'latestEditor': latestEditor,
    };
  }

  CalendricalEvent copyWith({
    String? eventID,
    String? groupID,
    String? authorID,
    GroupType? groupType,
    CalendricalEventType? eventType,
    Date? date,
    Time? startTime,
    Time? endTime,
    String? title,
    String? detail,
    String? place,
    bool? sendNotification,
    String? latestEditor,
  }) {
    return CalendricalEvent(
      createdOn: createdOn,
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
