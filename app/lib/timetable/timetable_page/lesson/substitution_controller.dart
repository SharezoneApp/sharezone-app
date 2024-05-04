import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
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
    final substitution = SubstitutionCanceled(
      id: _generateId(),
      date: date,
      createdBy: userId,
    );
    gateway.addSubstitutionToLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      substitution: substitution,
    );
    analytics.log(NamedAnalyticsEvent(name: 'substitution_cancelled', data: {
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
    required String newPlace,
  }) {
    final substitution = SubstitutionPlaceChange(
      id: _generateId(),
      date: date,
      createdBy: userId,
      newPlace: newPlace,
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

  void updatePlaceSubstitution({
    required String lessonId,
    required SubstitutionId substitutionId,
    required bool notifyGroupMembers,
    required String newPlace,
  }) {
    gateway.updateSubstitutionInLesson(
      lessonId: lessonId,
      notifyGroupMembers: notifyGroupMembers,
      newPlace: newPlace,
      substitutionId: substitutionId,
    );
    analytics
        .log(NamedAnalyticsEvent(name: 'substitution_place_changed', data: {
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
