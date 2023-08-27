// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/src/models/course_template.dart';

import 'events/course_create_event.dart';

class CourseCreateAnalytics {
  static const name = "course_create";
  static const fromTemplate = "template";
  static const fromOwn = "own";

  final Analytics _analytics;

  CourseCreateAnalytics(this._analytics);

  void logCourseCreateFromTemplate(CourseTemplate courseTemplate, String via) {
    _analytics.log(CourseCreateEvent(
        subject: courseTemplate.subject,
        name: name,
        type: fromTemplate,
        via: via));
  }

  void logCourseCreateFromOwn(String subject, String via) {
    _analytics.log(CourseCreateEvent(
        subject: subject, name: name, type: fromOwn, via: via));
  }
}
