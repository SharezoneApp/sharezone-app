// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone_common/references.dart';

class MockTimetableGateway implements TimetableGateway {
  final _lessonsSubject = BehaviorSubject.seeded(<Lesson>[]);
  final _eventsSubject = BehaviorSubject.seeded(<CalendricalEvent>[]);

  @override
  Future<bool> createEvent(CalendricalEvent event) async {
    _eventsSubject.sink.add(_eventsSubject.value..add(event));
    return true;
  }

  @override
  Future<bool> createLesson(Lesson lesson) async {
    _lessonsSubject.sink.add(_lessonsSubject.value..add(lesson));
    return true;
  }

  void addLessons(List<Lesson> lessons) {
    lessons.forEach(createLesson);
  }

  void addEvents(List<CalendricalEvent> events) {
    events.forEach(createEvent);
  }

  @override
  Future<bool> deleteEvent(CalendricalEvent event) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteLesson(Lesson lesson) {
    throw UnimplementedError();
  }

  @override
  Future<bool> editEvent(CalendricalEvent event) {
    throw UnimplementedError();
  }

  @override
  Future<bool> editLesson(Lesson lesson) {
    throw UnimplementedError();
  }

  @override
  Future<CalendricalEvent> getEvent(String eventID) {
    throw UnimplementedError();
  }

  @override
  Future<List<Lesson>> getLessonsOfGroup(String groupID) {
    throw UnimplementedError();
  }

  @override
  Stream<bool> isEventStreamEmpty() {
    throw UnimplementedError();
  }

  @override
  String get memberID => throw UnimplementedError();

  @override
  References get references => throw UnimplementedError();

  @override
  Stream<List<CalendricalEvent>> streamEvents(Date startDate, [Date? endDate]) {
    if (endDate == null) {
      return Stream.value(_eventsSubject.valueOrNull!
          .where((event) =>
              event.date.toDateTime.millisecond >=
              startDate.toDateTime.millisecond)
          .toList());
    }

    return Stream.value(_eventsSubject.valueOrNull!
        .where((event) =>
            (event.date.toDateTime.millisecond >=
                startDate.toDateTime.millisecond) &&
            event.date.toDateTime.millisecond <=
                startDate.toDateTime.millisecond)
        .toList());
  }

  @override
  Stream<List<Lesson>> streamLessons() => _lessonsSubject;

  @override
  Stream<List<Lesson>> streamLessonsUnfilteredForDate(Date date) {
    throw UnimplementedError();
  }

  @override
  Stream<CalendricalEvent> streamSingleEvent(String eventID) {
    throw UnimplementedError();
  }

  @override
  Stream<Lesson> streamSingleLesson(String lessonID) {
    throw UnimplementedError();
  }

  void dispose() {
    _lessonsSubject.close();
    _eventsSubject.close();
  }

  @override
  Stream<List<CalendricalEvent>> streamEventsBefore(DateTime endDate) {
    throw UnimplementedError();
  }
}
