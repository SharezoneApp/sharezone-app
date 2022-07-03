// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc_dependencies.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';

class TimetableAddEventBloc extends BlocBase {
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _startTimeSubject = BehaviorSubject<Time>();
  final _endTimeSubject = BehaviorSubject<Time>();
  final _placeSubject = BehaviorSubject<String>();
  final _titleSubject = BehaviorSubject<String>();
  final _dateSubject = BehaviorSubject<Date>();
  final _eventTypeSubject = BehaviorSubject<CalendricalEventType>();
  final _detailSubject = BehaviorSubject<String>();
  final _sendNotificationSubject = BehaviorSubject<bool>.seeded(false);

  final TimetableGateway gateway;
  final LessonLengthCache cache;

  final MarkdownAnalytics _markdownAnalytics;

  TimetableAddEventBloc(this.gateway, this.cache, this._markdownAnalytics);

  TimetableAddEventBloc.fromDependencies(
      TimetableAddEventBlocDependencies dependencies)
      : gateway = dependencies.gateway,
        cache = dependencies.lessonLengthCache,
        _markdownAnalytics = dependencies.markdownAnalytics;

  Stream<Course> get course => _courseSegmentSubject;
  Stream<Time> get startTime => _startTimeSubject;
  Stream<Time> get endTime => _endTimeSubject;
  Stream<String> get place => _placeSubject;
  Stream<String> get title => _titleSubject;
  Stream<Date> get date => _dateSubject;
  Stream<CalendricalEventType> get eventType => _eventTypeSubject;
  Stream<String> get detail => _detailSubject;
  Stream<bool> get sendNotification => _sendNotificationSubject;

  void changeStartTime(Time startTime) {
    _startTimeSubject.sink.add(startTime);
    /*
    _calculateEndTimeAndAddToStreamIfStartTimeIsNotGivenAndLessonsLengthIsGiven(
        startTime);
   */
  }

  void changeEndTime(Time endTime) {
    _endTimeSubject.sink.add(endTime);
    /*
    _calculateStartTimeAndAddToStreamIfEndTimeIsNotAndIfLessonsLengthIsGiven(
        endTime);
    */
  }

  Function(Course) get changeCourse => _courseSegmentSubject.sink.add;
  Function(String) get changePlace => _placeSubject.sink.add;
  Function(String) get changeTitle => _titleSubject.sink.add;
  Function(Date) get changeDate => _dateSubject.sink.add;
  Function(CalendricalEventType) get changeEventType =>
      _eventTypeSubject.sink.add;
  Function(String) get changeDetail => _detailSubject.sink.add;
  Function(bool) get changeSendNotification =>
      _sendNotificationSubject.sink.add;

  /*
  Future<void>
      _calculateEndTimeAndAddToStreamIfStartTimeIsNotGivenAndLessonsLengthIsGiven(
          Time startTime) async {
    if (_endTimeSubject.valueOrNull == null) {
      final lessonsLength = await cache.streamLessonLength().first;
      if (lessonsLength.isValid) {
        final endTime =
            _calculateEndTime(startTime, lessonsLength.lengthInMinutes);
        _endTimeSubject.sink.add(endTime);
      }
    }
  }

  Future<void>
      _calculateStartTimeAndAddToStreamIfEndTimeIsNotAndIfLessonsLengthIsGiven(
          Time endTime) async {
    if (_startTimeSubject.valueOrNull == null) {
      final lessonsLength = await cache.streamLessonLength().first;
      if (lessonsLength.isValid) {
        final startTime =
            _calculateStartTime(endTime, lessonsLength.lengthInMinutes);
        _startTimeSubject.sink.add(startTime);
      }
    }
  }
  */

  bool isStartTimeValid() {
    if (!isStartTimeEmpty()) {
      if (isStartBeforeEnd()) {
        return true;
      }
    }
    return false;
  }

  bool isEndTimeValid() {
    if (!isEndTimeEmpty()) {
      if (isStartBeforeEnd()) {
        return true;
      }
    }
    return false;
  }

  /*
Time _calculateEndTime(Time startTime, int lessonsLength) {
    return Time.fromTimeOfDay(TimeOfDay.fromDateTime(
        DateTime(2019, 1, 1, startTime.hour, startTime.minute)
            .add(Duration(minutes: lessonsLength))));
  }

  Time _calculateStartTime(Time endTime, int lessonsLength) {
    return Time.fromTimeOfDay(TimeOfDay.fromDateTime(
        DateTime(2019, 1, 1, endTime.hour, endTime.minute)
            .subtract(Duration(minutes: lessonsLength))));
  }
  */

  bool _isValid(TabController controller) {
    if (_isTitleValid(controller) &&
        _isCourseValid(controller) &&
        _isDateValid(controller) &&
        _isStartTimeValid(controller) &&
        _isEndTimeValid(controller) &&
        isStartBeforeEnd()) {
      return true;
    }
    return false;
  }

  CalendricalEvent submit(TabController controller) {
    if (_isValid(controller)) {
      final course = _courseSegmentSubject.valueOrNull;
      final startTime = _startTimeSubject.valueOrNull;
      final endTime = _endTimeSubject.valueOrNull;
      final place = _placeSubject.valueOrNull;
      final date = _dateSubject.valueOrNull;
      final title = _titleSubject.valueOrNull;
      final eventType = _eventTypeSubject.valueOrNull;
      final detail = _detailSubject.valueOrNull;
      final sendNotification = _sendNotificationSubject.valueOrNull;
      print(
          "isValid: true; ${course.toString()}; $startTime; $endTime; $place $date $sendNotification");

      final event = CalendricalEvent(
        groupID: course.id,
        groupType: GroupType.course,
        eventType: eventType,
        date: date,
        place: place,
        startTime: startTime,
        endTime: endTime,
        eventID: null, authorID: null, // WILL BE ADDED IN THE GATEWAY!
        title: title,
        detail: detail,
        sendNotification: sendNotification,
        latestEditor: gateway.memberID,
      );

      gateway.createEvent(event);

      _markdownAnalytics.logMarkdownUsedEvent();

      return event;
    }
    return null;
  }

  void _animateBackToTitle(TabController controller) {
    controller.animateTo(1);
  }

  void _animateBackToStartAndEndTime(TabController controller) {
    controller.animateTo(3);
  }

  void _animateBackToDate(TabController controller) {
    controller.animateTo(2);
  }

  void _animateBackToCourseTab(TabController controller) {
    controller.animateTo(0);
  }

  bool isStartTimeEmpty() => _startTimeSubject.valueOrNull == null;
  bool isEndTimeEmpty() => _endTimeSubject.valueOrNull == null;

  bool _isCourseValid(TabController controller) {
    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      _animateBackToCourseTab(controller);
      throw InvalidCourseException();
    }
    return true;
  }

  bool _isStartTimeValid([TabController controller]) {
    final validatorStartTime = NotNullValidator(_startTimeSubject.valueOrNull);
    if (!validatorStartTime.isValid()) {
      if (controller != null) {
        _animateBackToStartAndEndTime(controller);
      }
      throw InvalidStartTimeException();
    }
    return true;
  }

  bool _isEndTimeValid([TabController controller]) {
    final validatorEndTime = NotNullValidator(_endTimeSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      if (controller != null) {
        _animateBackToStartAndEndTime(controller);
      }
      throw InvalidEndTimeException();
    }
    return true;
  }

  bool _isDateValid(TabController controller) {
    final validatorDate = NotNullValidator(_dateSubject.valueOrNull);
    if (!validatorDate.isValid()) {
      _animateBackToDate(controller);
      throw InvalidDateException();
    }
    return true;
  }

  bool _isTitleValid(TabController controller) {
    final validatorDate = NotNullValidator(_titleSubject.valueOrNull);
    if (!validatorDate.isValid()) {
      _animateBackToTitle(controller);
      throw InvalidTitleException();
    }
    return true;
  }

  bool isStartBeforeEnd() {
    final startTime = _startTimeSubject.valueOrNull;
    final endTime = _endTimeSubject.valueOrNull;
    if (startTime != null && endTime != null) {
      return startTime.isBefore(endTime);
    }
    return false;
  }

  @override
  void dispose() {
    _courseSegmentSubject.close();
    _startTimeSubject.close();
    _endTimeSubject.close();
    _placeSubject.close();
    _dateSubject.close();
    _titleSubject.close();
    _eventTypeSubject.close();
    _detailSubject.close();
    _sendNotificationSubject.close();
  }
}
