// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/util/api.dart';
import 'package:time/time.dart';

class EventDialogApi {
  final SharezoneGateway _api;

  EventDialogApi(this._api);

  Future<Course> loadCourse(CourseId courseId) async {
    return (await _api.course.streamCourse(courseId.id).first)!;
  }

  Future<void> createEvent(
    CreateEventCommand command,
  ) async {
    //
    print('Event created: ${command.title}');
  }
}

enum EventType { event, exam }

class CreateEventCommand {
  final String title;
  final CourseId courseId;
  final String description;
  final Date date;
  final Time startTime;
  final Time endTime;
  final String location;
  final bool notifyCourseMembers;
  final EventType eventType;

  CreateEventCommand({
    required this.title,
    required this.description,
    required this.courseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.notifyCourseMembers,
    required this.eventType,
  });
}
