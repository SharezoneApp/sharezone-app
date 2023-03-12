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
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

class TimetableEditBloc extends BlocBase {
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _startTimeSubject = BehaviorSubject<Time>();
  final _endTimeSubject = BehaviorSubject<Time>();
  final _roomSubject = BehaviorSubject<String>();
  final _weekDaySubject = BehaviorSubject<WeekDay>();
  final _weekTypeSubject = BehaviorSubject<WeekType>();
  final _periodSubject = BehaviorSubject<Period>();

  final Lesson initialLesson;
  final TimetableGateway gateway;
  final ConnectionsGateway connectionsGateway;
  final TimetableBloc timetableBloc;

  TimetableEditBloc({
    @required this.gateway,
    @required this.initialLesson,
    @required this.connectionsGateway,
    @required this.timetableBloc,
  }) {
    Course course = connectionsGateway.current().courses[initialLesson.groupID];
    _changeCourse(course);
    changeStartTime(initialLesson.startTime);
    changeEndTime(initialLesson.endTime);
    changeRoom(initialLesson.place);
    changeWeekDay(initialLesson.weekday);
    changeWeekType(initialLesson.weektype);
    if (initialLesson.periodNumber != null) {
      final period = timetableBloc.current
          .getPeriods()
          .getPeriod(initialLesson.periodNumber);
      if (period != null) {
        _periodSubject.sink.add(period);
      }
    }
  }

  Stream<Course> get course => _courseSegmentSubject;
  Stream<Time> get startTime => _startTimeSubject;
  Stream<Time> get endTime => _endTimeSubject;
  Stream<String> get room => _roomSubject;
  Stream<WeekDay> get weekDay => _weekDaySubject;
  Stream<WeekType> get weekType => _weekTypeSubject;
  Stream<Period> get period => _periodSubject;

  Function(Course) get _changeCourse => _courseSegmentSubject.sink.add;
  Function(Time) get changeStartTime => _startTimeSubject.sink.add;
  Function(Time) get changeEndTime => _endTimeSubject.sink.add;
  Function(String) get changeRoom => _roomSubject.sink.add;
  Function(WeekDay) get changeWeekDay => _weekDaySubject.sink.add;
  Function(WeekType) get changeWeekType => _weekTypeSubject.sink.add;

  void changePeriod(Period period) {
    _periodSubject.sink.add(period);
    changeStartTime(period.startTime);
    changeEndTime(period.endTime);
  }

  bool _isValid() {
    if (_isCourseValid() &&
        _isWeekDayValid() &&
        _isStartTimeValid() &&
        _isEndTimeValid() &&
        _isWeekDayValid() &&
        isStartBeforeEnd()) {
      return true;
    }
    return false;
  }

  void submit() {
    if (_isValid()) {
      final course = _courseSegmentSubject.valueOrNull;
      final startTime = _startTimeSubject.valueOrNull;
      final endTime = _endTimeSubject.valueOrNull;
      final room = _roomSubject.valueOrNull;
      final weekDay = _weekDaySubject.valueOrNull;
      final weekType = _weekTypeSubject.valueOrNull;
      final period = _periodSubject.valueOrNull;

      print(
          "isValid: true; ${course.toString()}; $startTime; $endTime; $room $weekDay");

      final lesson = initialLesson.copyWith(
        groupID: course.id,
        teacher: null,
        place: room,
        weekday: weekDay,
        weektype: weekType,
        startTime: startTime,
        endTime: endTime,
        periodNumber: period?.number,
      );

      gateway.editLesson(lesson);
    }
  }

  bool isStartTimeEmpty() => _startTimeSubject.valueOrNull == null;
  bool isEndTimeEmpty() => _endTimeSubject.valueOrNull == null;

  bool _isCourseValid() {
    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      throw InvalidCourseException();
    }
    return true;
  }

  bool _isStartTimeValid() {
    final validatorStartTime = NotNullValidator(_startTimeSubject.valueOrNull);
    if (!validatorStartTime.isValid()) {
      throw InvalidStartTimeException();
    }
    return true;
  }

  bool _isEndTimeValid() {
    final validatorEndTime = NotNullValidator(_endTimeSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      throw InvalidEndTimeException();
    }
    return true;
  }

  bool _isWeekDayValid() {
    final validatorWeekDay = NotNullValidator(_weekDaySubject.valueOrNull);
    if (!validatorWeekDay.isValid()) {
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
  }
}
