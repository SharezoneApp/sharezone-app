// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';

class TimetableEditEventBloc extends BlocBase {
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _startTimeSubject = BehaviorSubject<Time>();
  final _endTimeSubject = BehaviorSubject<Time>();
  final _roomSubject = BehaviorSubject<String>();
  final _titleSubject = BehaviorSubject<String>();
  final _detailSubject = BehaviorSubject<String>();
  final _dateSubject = BehaviorSubject<Date>();
  final _sendNotificationSubject = BehaviorSubject<bool>();

  final CalendricalEvent initialEvent;
  final TimetableGateway gateway;
  final ConnectionsGateway connectionsGateway;
  final MarkdownAnalytics markdownAnalytics;

  TimetableEditEventBloc({
    this.gateway,
    this.initialEvent,
    this.connectionsGateway,
    @required this.markdownAnalytics,
  }) {
    Course course = connectionsGateway.current().courses[initialEvent.groupID];
    _changeCourse(course);
    changeStartTime(initialEvent.startTime);
    changeEndTime(initialEvent.endTime);
    changeRoom(initialEvent.place);
    changeDate(initialEvent.date);
    changeTitle(initialEvent.title);
    changeDetail(initialEvent.detail);
    changeSendNotification(initialEvent.sendNotification);
  }

  Stream<Course> get course => _courseSegmentSubject;
  Stream<Time> get startTime => _startTimeSubject;
  Stream<Time> get endTime => _endTimeSubject;
  Stream<String> get room => _roomSubject;
  Stream<String> get title => _titleSubject;
  Stream<String> get detail => _detailSubject;
  Stream<Date> get date => _dateSubject;
  Stream<bool> get sendNotification => _sendNotificationSubject;

  Function(Course) get _changeCourse => _courseSegmentSubject.sink.add;
  Function(Date) get changeDate => _dateSubject.sink.add;
  Function(Time) get changeStartTime => _startTimeSubject.sink.add;
  Function(Time) get changeEndTime => _endTimeSubject.sink.add;
  Function(String) get changeRoom => _roomSubject.sink.add;
  Function(String) get changeTitle => _titleSubject.sink.add;
  Function(String) get changeDetail => _detailSubject.sink.add;
  Function(bool) get changeSendNotification =>
      _sendNotificationSubject.sink.add;

  bool _isValid() {
    if (_isCourseValid() &&
        _isStartTimeValid() &&
        _isEndTimeValid() &&
        _isDateValid() &&
        _isTitleValid() &&
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
      final date = _dateSubject.valueOrNull;
      final title = _titleSubject.valueOrNull;
      final detail = _detailSubject.valueOrNull;
      final sendNotification = _sendNotificationSubject.valueOrNull;

      print(
          "isValid: true; ${course.toString()}; $startTime; $endTime; $room $title $date $detail");

      final event = initialEvent.copyWith(
        groupID: course.id,
        place: room,
        startTime: startTime,
        endTime: endTime,
        date: date,
        title: title,
        detail: detail,
        sendNotification: sendNotification,
        latestEditor: gateway.memberID,
      );

      gateway.editEvent(event);

      if (!markdownAnalytics.containsMarkdown(initialEvent.detail))
        markdownAnalytics.logMarkdownUsedEvent();
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

  bool _isDateValid() {
    final validatorEndTime = NotNullValidator(_dateSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      throw InvalidDateException();
    }
    return true;
  }

  bool _isTitleValid() {
    final validatorEndTime = NotNullValidator(_titleSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
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
    _roomSubject.close();
    _titleSubject.close();
    _detailSubject.close();
    _dateSubject.close();
    _sendNotificationSubject.close();
  }
}
