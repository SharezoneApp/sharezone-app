import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class SubstitutionController {
  final TimetableGateway gateway;
  final Analytics analytics;
  final UserId userId;

  const SubstitutionController({
    required this.gateway,
    required this.analytics,
    required this.userId,
  });

  void addCancelSubstitution({
    required Lesson lesson,
    required Date date,
    required bool notifyGroupMembers,
  }) {
    final substitution = SubstitutionCanceled(
      id: _generateId(),
      date: date,
      notifyGroupMembers: notifyGroupMembers,
      createdBy: userId,
    );
    log('Adding substitution for lesson ${lesson.lessonID}');
    gateway.addSubstitutionToLesson(lesson.lessonID!, substitution);
    analytics.log(NamedAnalyticsEvent(name: 'substitution_cancelled', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  void removeSubstitution({
    required Lesson lesson,
    required SubstitutionId substitutionId,
  }) {
    gateway.removeSubstitutionFromLesson(lesson.lessonID!, substitutionId);
    analytics.log(NamedAnalyticsEvent(name: 'substitution_removed'));
  }

  void addPlaceChangeSubstitution({
    required Lesson lesson,
    required Date date,
    required bool notifyGroupMembers,
    required String newPlace,
  }) {
    final substitution = SubstitutionPlaceChange(
      id: _generateId(),
      date: date,
      notifyGroupMembers: notifyGroupMembers,
      newPlace: newPlace,
      createdBy: userId,
    );
    gateway.addSubstitutionToLesson(lesson.lessonID!, substitution);
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_place_changed', data: {
      'notify_group_members': notifyGroupMembers,
      'new_place': newPlace,
    }));
  }

  SubstitutionId _generateId() {
    return SubstitutionId(Id.generate().value);
  }
}
