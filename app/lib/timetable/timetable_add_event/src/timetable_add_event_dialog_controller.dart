// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:flutter/foundation.dart';
import 'package:time/time.dart';

import 'timetable_add_event_dialog_src.dart';

class AddEventDialogController extends ChangeNotifier {
  AddEventDialogController({required this.api, required this.isExam});
  final EventDialogApi api;
  final bool isExam;

  String _title = '';

  String get title => _title;
  bool showEmptyTitleError = false;

  set title(String value) {
    showEmptyTitleError = value.isEmpty;
    _title = value;
    notifyListeners();
  }

  String _description = '';

  String get description => _description;

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  CourseView? _course;

  CourseView? get course => _course;
  bool showEmptyCourseError = false;

  Future<void> selectCourse(CourseId courseId) async {
    final c = await api.loadCourse(courseId);
    _course = CourseView(id: courseId, name: c.name);
    showEmptyCourseError = false;
    notifyListeners();
  }

  Date _date = Date.fromDateTime(clock.now());

  Date get date => _date;

  set date(Date value) {
    _date = value;
    notifyListeners();
  }

  Time _startTime = Time(hour: 11, minute: 00);

  Time get startTime => _startTime;

  set startTime(Time value) {
    _startTime = value;
    notifyListeners();
  }

  Time _endTime = Time(hour: 12, minute: 00);

  Time get endTime => _endTime;

  set endTime(Time value) {
    _endTime = value;
    notifyListeners();
  }

  Future<bool> createEvent() async {
    bool hasError = false;
    if (title.isEmpty) {
      showEmptyTitleError = true;
      hasError = true;
    }
    if (course == null) {
      showEmptyCourseError = true;
      hasError = true;
    }
    if (hasError) {
      notifyListeners();
      return false;
    }

    await api.createEvent(CreateEventCommand(
      title: title,
      description: description,
      courseId: course!.id,
      date: date,
      startTime: startTime,
      endTime: endTime,
      location: location,
      notifyCourseMembers: notifyCourseMembers,
      eventType: isExam ? EventType.exam : EventType.event,
    ));

    return true;
  }

  bool _notifyCourseMembers = true;

  bool get notifyCourseMembers => _notifyCourseMembers;

  set notifyCourseMembers(bool value) {
    _notifyCourseMembers = value;
    notifyListeners();
  }

  String _location = '';

  String get location => _location;

  set location(String value) {
    _location = value;
    notifyListeners();
  }
}

class CourseView {
  final CourseId id;
  final String name;

  CourseView({required this.id, required this.name});
}
