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
