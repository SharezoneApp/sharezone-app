// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date/date.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone_common/references.dart';

class TimetableGateway {
  final References references;
  final String memberID;

  const TimetableGateway(this.references, this.memberID);

  Future<bool> createLesson(Lesson lesson) {
    String lessonID = references.lessons.doc().id;
    Map<String, dynamic> data = lesson.copyWith(lessonID: lessonID).toJson();
    data['users'] = [memberID];
    return references.lessons
        .doc(lessonID)
        .set(data, SetOptions(merge: true))
        .then((_) => true);
  }

  Future<bool> editLesson(Lesson lesson) {
    return references.lessons
        .doc(lesson.lessonID)
        .set(lesson.toJson(), SetOptions(merge: true))
        .then((_) => true);
  }

  Future<bool> deleteLesson(Lesson lesson) {
    return references.lessons.doc(lesson.lessonID).delete().then((_) => true);
  }

  Future<bool> createEvent(CalendricalEvent event) {
    String eventID = references.events.doc().id;
    Map<String, dynamic> data =
        event.copyWith(eventID: eventID, authorID: memberID).toJson();
    data['users'] = [memberID];
    return references.events
        .doc(eventID)
        .set(data, SetOptions(merge: true))
        .then((_) => true);
  }

  Future<bool> editEvent(CalendricalEvent event) {
    return references.events
        .doc(event.eventID)
        .set(event.toJson(), SetOptions(merge: true))
        .then((_) => true);
  }

  Future<bool> deleteEvent(CalendricalEvent event) {
    return references.events.doc(event.eventID).delete().then((_) => true);
  }

  Stream<List<Lesson>> streamLessons() {
    return references.lessons
        .where('users', arrayContains: memberID)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((document) => Lesson.fromData(document.data(), id: document.id))
          .toList();
    });
  }

  Future<CalendricalEvent> getEvent(String eventID) {
    return references.events.doc(eventID).get().then((document) {
      return CalendricalEvent.fromData(document.data()!, id: document.id);
    });
  }

  Future<List<Lesson>> getLessonsOfGroup(String groupID) {
    return references.lessons
        .where('users', arrayContains: memberID)
        .where('groupID', isEqualTo: groupID)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs
          .map((document) => Lesson.fromData(document.data(), id: document.id))
          .toList();
    });
  }

  Stream<List<CalendricalEvent>> streamEvents(Date startDate, [Date? endDate]) {
    // Stream everyting after the start date
    if (endDate == null) {
      return references.events
          .where('users', arrayContains: memberID)
          .where('date', isGreaterThanOrEqualTo: startDate.toDateString)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((document) =>
                CalendricalEvent.fromData(document.data(), id: document.id))
            .toList();
      });
    }

    // Stream between a range
    return references.events
        .where('users', arrayContains: memberID)
        .where('date', isGreaterThanOrEqualTo: startDate.toDateString)
        .where('date', isLessThanOrEqualTo: endDate.toDateString)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((document) =>
              CalendricalEvent.fromData(document.data(), id: document.id))
          .toList();
    });
  }

  /// Streams the calendrical events that occurred before or on the specified
  /// date.
  ///
  /// The [date] parameter specifies the end date for the events to be included
  /// in the stream. If [descending] is `true`, the events are streamed in
  /// descending order; otherwise, they are streamed in ascending order.
  Stream<List<CalendricalEvent>> streamEventsBeforeOrOn(
    Date date, {
    bool descending = true,
  }) {
    return references.events
        .where('users', arrayContains: memberID)
        .where('date', isLessThanOrEqualTo: date.toDateString)
        .orderBy('date', descending: descending)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((document) =>
              CalendricalEvent.fromData(document.data(), id: document.id))
          .toList();
    });
  }

  Stream<bool> isEventStreamEmpty() {
    return references.events
        .where('users', arrayContains: memberID)
        .limit(1)
        .snapshots()
        .isEmpty
        .asStream();
  }

  Stream<Lesson> streamSingleLesson(String lessonID) {
    return references.lessons.doc(lessonID).snapshots().map((snapshot) {
      return Lesson.fromData(snapshot.data()!, id: snapshot.id);
    });
  }

  Stream<CalendricalEvent> streamSingleEvent(String eventID) {
    return references.events.doc(eventID).snapshots().map((snapshot) {
      return CalendricalEvent.fromData(snapshot.data()!, id: snapshot.id);
    });
  }

  Stream<List<Lesson>> streamLessonsUnfilteredForDate(Date date) {
    return references.lessons
        .where('users', arrayContains: memberID)
        .where('weekday', isEqualTo: date.weekDayEnum.name)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((document) => Lesson.fromData(document.data(), id: document.id))
          .toList();
    });
  }
}
