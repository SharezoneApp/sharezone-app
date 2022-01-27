// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone/timetable/src/models/time_type.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc_dependencies.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

class TimetableAddBloc extends BlocBase {
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _startTimeSubject = BehaviorSubject<Time>();
  final _endTimeSubject = BehaviorSubject<Time>();
  final _roomSubject = BehaviorSubject<String>();
  final _weekDaySubject = BehaviorSubject<WeekDay>();
  final _weekTypeSubject = BehaviorSubject<WeekType>();
  final _periodSubject = BehaviorSubject<Period>();
  final _timeTypeSubject = BehaviorSubject.seeded(TimeType.period);

  final TimetableGateway gateway;
  final LessonLengthCache cache;

  TimetableAddBloc(this.gateway, this.cache);

  TimetableAddBloc.fromDependencies(TimetableAddBlocDependencies dependencies)
      : gateway = dependencies.gateway,
        cache = dependencies.lessonLengthCache;

  Stream<Course> get course => _courseSegmentSubject;
  Stream<Time> get startTime => _startTimeSubject;
  Stream<Time> get endTime => _endTimeSubject;
  Stream<String> get room => _roomSubject;
  Stream<WeekDay> get weekDay => _weekDaySubject;
  Stream<WeekType> get weekType => _weekTypeSubject;
  Stream<Period> get period => _periodSubject;
  Stream<TimeType> get timeType => _timeTypeSubject;

  Function(Course) get changeCourse => _courseSegmentSubject.sink.add;

  Future<void> changeStartTime(Time startTime) async {
    _clearPeriod();
    _startTimeSubject.sink.add(startTime);
    final endTime = await _calculateEndTime(startTime);
    if (endTime != null) _endTimeSubject.sink.add(endTime);
  }

  void changeEndTime(Time endTime) {
    _clearPeriod();
    _endTimeSubject.sink.add(endTime);
  }

  void _clearPeriod() {
    _periodSubject.sink.add(null);
  }

  Function(String) get changeRoom => _roomSubject.sink.add;
  Function(WeekDay) get changeWeekDay => _weekDaySubject.sink.add;
  Function(WeekType) get changeWeekType => _weekTypeSubject.sink.add;
  Function(Period) get changePeriod => _periodSubject.sink.add;
  Function(TimeType) get changeTimeType => _timeTypeSubject.sink.add;

  Future<Time> _calculateEndTime(Time startTime) async {
    final lessonsLength = await cache.streamLessonLength().first;
    if (lessonsLength.isValid) {
      return startTime.add(lessonsLength.duration);
    }
    return null;
  }

  bool isTimeValid() {
    return _timeTypeSubject.valueOrNull == TimeType.individual
        ? isStartTimeValid() && isEndTimeValid()
        : isPeriodValid();
  }

  bool isStartTimeValid() {
    if (!isStartTimeEmpty() && isStartBeforeEnd()) return true;
    return false;
  }

  bool isEndTimeValid() {
    if (!isEndTimeEmpty() && isStartBeforeEnd()) return true;
    return false;
  }

  bool isPeriodValid() {
    if (!isPeriodEmpty()) return _periodSubject.valueOrNull.validate();
    return false;
  }

  bool _isValid(TabController controller) {
    if (_isCourseValid(controller) &&
        _isWeekDayValid(controller) &&
        _isTimeValid(controller) &&
        _isWeekDayValid(controller)) {
      return true;
    }
    return false;
  }

  Lesson submit(TabController controller) {
    if (_isValid(controller)) {
      final course = _courseSegmentSubject.valueOrNull;
      final startTime = _startTimeSubject.valueOrNull;
      final endTime = _endTimeSubject.valueOrNull;
      final room = _roomSubject.valueOrNull;
      final weekDay = _weekDaySubject.valueOrNull;
      final weekType = _weekTypeSubject.valueOrNull ?? WeekType.always;
      final period = _periodSubject.valueOrNull;
      final timeType = _timeTypeSubject.valueOrNull;
      print(
          "isValid: true; ${course.toString()}; $startTime; $endTime; $room $weekDay $period");

      final lesson = Lesson(
        groupID: course.id,
        groupType: GroupType.course,
        startDate: null,
        endDate: null,
        teacher: null,
        place: room,
        weekday: weekDay,
        weektype: weekType,
        startTime: timeType == TimeType.period ? period.startTime : startTime,
        endTime: timeType == TimeType.period ? period.endTime : endTime,
        periodNumber: timeType == TimeType.period ? period?.number : null,
        lessonID: null, // WILL BE ADDED IN THE GATEWAY!
      );

      gateway.createLesson(lesson);
      return lesson;
    }
    return null;
  }

  void _animateBackToStartAndEndTime(TabController controller) {
    controller.animateTo(2);
  }

  void _animateBackToWeekDay(TabController controller) {
    controller.animateTo(1);
  }

  void _animateBackToCourseTab(TabController controller) {
    controller.animateTo(0);
  }

  bool isStartTimeEmpty() => _startTimeSubject.valueOrNull == null;
  bool isEndTimeEmpty() => _endTimeSubject.valueOrNull == null;
  bool isPeriodEmpty() => _periodSubject.valueOrNull == null;

  bool _isCourseValid(TabController controller) {
    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      _animateBackToCourseTab(controller);
      throw InvalidCourseException();
    }
    return true;
  }

  bool _isTimeValid([TabController controller]) {
    if (_isIndividualType()) {
      return _isStartTimeValid(controller) &&
          _isEndTimeValid(controller) &&
          isStartBeforeEnd();
    } else {
      return _isPeriodValid(controller);
    }
  }

  bool _isIndividualType() {
    final _timeType = _timeTypeSubject.valueOrNull;
    return _timeType == TimeType.individual;
  }

  bool _isPeriodValid([TabController controller]) {
    final validatorPeriod = NotNullValidator(_periodSubject.valueOrNull);
    if (!validatorPeriod.isValid()) {
      if (controller != null) {
        _animateBackToStartAndEndTime(controller);
      }
      throw InvalidPeriodException();
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

  bool _isWeekDayValid(TabController controller) {
    final validatorWeekDay = NotNullValidator(_weekDaySubject.valueOrNull);
    if (!validatorWeekDay.isValid()) {
      _animateBackToWeekDay(controller);
      throw InvalidWeekDayException();
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
    _roomSubject.close();
    _weekDaySubject.close();
    _weekTypeSubject.close();
    _periodSubject.close();
    _timeTypeSubject.close();
  }
}
