// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/logic/timetable_position_logic.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/src/models/timetable_element_properties.dart';
import 'package:sharezone/timetable/src/models/timetable_element_time_properties.dart';

class TimetableBuilder {
  final List<Lesson> lessons;
  final List<Date> dates;
  final List<CalendricalEvent> events;
  final Map<String, GroupInfo> groupInfo;

  const TimetableBuilder(
    this.lessons,
    this.dates,
    this.events,
    this.groupInfo,
  );

  List<TimetableElement> buildElements() {
    List<TimetableElement> entries = [];
    for (Date date in dates) {
      final filteredLessons = _getFilteredLessonsForDate(date);
      final filteredEvents = _getFilteredEventsForDate(date);
      final propertiesMap = calculatePropertiesForElements(Map.fromEntries([
        for (final lesson in filteredLessons)
          MapEntry(
            lesson.lessonID!,
            TimetableElementTimeProperties(
              lesson.lessonID!,
              date,
              lesson.startTime,
              lesson.endTime,
            ),
          ),
        for (final event in filteredEvents)
          MapEntry(
            event.eventID,
            TimetableElementTimeProperties(
                event.eventID, date, event.startTime, event.endTime),
          ),
      ]));

      entries.addAll(filteredLessons.map((lesson) => _buildElementForLesson(
            date,
            lesson,
            propertiesMap[lesson.lessonID]!,
          )));
      entries.addAll(filteredEvents.map((event) => _buildElementForEvent(
            event,
            propertiesMap[event.eventID] ?? TimetableElementProperties.standard,
          )));
    }
    return entries;
  }

  TimetableElement _buildElementForEvent(
      CalendricalEvent event, TimetableElementProperties properties) {
    return TimetableElement(
      date: event.date,
      start: event.startTime,
      end: event.endTime,
      data: event,
      groupInfo: groupInfo[event.groupID]!,
      priority: 1,
      properties: properties,
    );
  }

  TimetableElement _buildElementForLesson(
      Date date, Lesson lesson, TimetableElementProperties properties) {
    return TimetableElement(
      date: date,
      start: lesson.startTime,
      end: lesson.endTime,
      data: lesson,
      groupInfo: groupInfo[lesson.groupID]!,
      priority: 0,
      properties: properties,
    );
  }

  Iterable<Lesson> _getFilteredLessonsForDate(Date date) {
    WeekDay weekday = date.weekDayEnum;
    return lessons.where((lesson) {
      if (lesson.startDate != null && lesson.startDate!.isBefore(date))
        return false;
      if (lesson.endDate != null && lesson.endDate!.isAfter(date)) return false;
      return lesson.weekday == weekday;
    });
  }

  Iterable<CalendricalEvent> _getFilteredEventsForDate(Date date) {
    return events.where((event) {
      return event.date == date;
    });
  }

  Map<String, TimetableElementProperties> calculatePropertiesForElements(
      Map<String, TimetableElementTimeProperties> elementTimeProperties) {
    final positionLogic = TimetablePositionLogic(elementTimeProperties);
    return positionLogic.elementProperties;
  }
}
