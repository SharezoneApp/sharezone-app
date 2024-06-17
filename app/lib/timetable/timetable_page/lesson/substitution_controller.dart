// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:sharezone/timetable/src/models/substitution.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class SubstitutionController {
  final TimetableGateway gateway;
  final Analytics analytics;
  final UserId userId;
  final CourseMemberAccessor courseMemberAccessor;

  const SubstitutionController({
    required this.gateway,
    required this.analytics,
    required this.userId,
    required this.courseMemberAccessor,
  });

  void addCancelSubstitution({
    required String lessonId,
    required Date date,
    required bool notifyGroupMembers,
  }) {
    final substitution = LessonCanceledSubstitution(
      id: _generateId(),
      date: date,
      createdBy: userId,
    );
    gateway.addSubstitutionToLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      substitution: substitution,
    );
    analytics.log(NamedAnalyticsEvent(name: 'substitution_canceled', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  void removeSubstitution({
    required String lessonId,
    required SubstitutionId substitutionId,
    required bool notifyGroupMembers,
  }) {
    gateway.removeSubstitutionFromLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      substitutionId: substitutionId,
    );
    analytics.log(NamedAnalyticsEvent(name: 'substitution_removed'));
  }

  void addPlaceChangeSubstitution({
    required String lessonId,
    required bool notifyGroupMembers,
    required Date date,
    required String newLocation,
  }) {
    final substitution = LocationChangedSubstitution(
      id: _generateId(),
      date: date,
      createdBy: userId,
      newLocation: newLocation,
    );
    gateway.addSubstitutionToLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      substitution: substitution,
    );
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_place_changed', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  void addTeacherSubstitution({
    required String lessonId,
    required bool notifyGroupMembers,
    required Date date,
    required String newTeacher,
  }) {
    final substitution = TeacherChangedSubstitution(
      id: _generateId(),
      date: date,
      createdBy: userId,
      newTeacher: newTeacher,
    );
    gateway.addSubstitutionToLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      substitution: substitution,
    );
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_teacher_changed', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  void updatePlaceSubstitution({
    required String lessonId,
    required SubstitutionId substitutionId,
    required bool notifyGroupMembers,
    required String newLocation,
  }) {
    gateway.updateSubstitutionInLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      newLocation: newLocation,
      substitutionId: substitutionId,
    );
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_place_changed', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  void updateTeacherSubstitution({
    required String lessonId,
    required SubstitutionId substitutionId,
    required bool notifyGroupMembers,
    required String newTeacher,
  }) {
    gateway.updateSubstitutionInLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      newTeacher: newTeacher,
      substitutionId: substitutionId,
    );
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_teacher_changed', data: {
      'notify_group_members': notifyGroupMembers,
    }));
  }

  Future<String?> getMemberName(String courseId, UserId userId) async {
    final member = await courseMemberAccessor.getMember(courseId, userId);
    return member?.name;
  }

  SubstitutionId _generateId() {
    return SubstitutionId(Id.generate().value);
  }
}
