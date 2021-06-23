import 'dart:async';

import 'package:app_functions/app_functions.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:design/design.dart';

import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/references.dart';
import 'package:group_domain_implementation/group_domain_accessors_implementation.dart';

class CourseGateway {
  final References references;
  final String memberID;
  final ConnectionsGateway _connectionsGateway;

  final CourseMemberAccessor memberAccessor;

  factory CourseGateway(References references, String memberID,
      ConnectionsGateway connectionsGateway) {
    return CourseGateway._(
      references,
      memberID,
      connectionsGateway,
      FirestoreCourseMemberAccessor(references.firestore),
    );
  }

  const CourseGateway._(this.references, this.memberID,
      this._connectionsGateway, this.memberAccessor);

  Course createCourse(CourseData courseData, UserGateway userGateway) {
    final user = userGateway.data;
    CourseData course = courseData.copyWith(
      id: references.courses.doc().id,
    );

    references.courses.doc(course.id).set(course.toCreateJson(memberID));

    // Der Ersteller eines Kurses muss ich selber in die Members-Collection
    // hinzufügen. Aus Sicherheitsgründen darf nur der Ersteller Dokumente in
    // der Members-Collection hinzufügen. Deswegen prüfen die Security-Rules,
    // dass der Nutzer, die ein Dokument in der Members-Collection möchte, auch
    // der Ersteller des Kurses ist. Damit die Security-Rules direkt überprüfen
    // können, muss sichergestellt sein, dass erst der Kurs erstellt wurde und
    // *danach* das Dokument in der Members-Collection.
    //
    // Ohne `Futre.delayed` kommt es bei ca. 1 von 4 Fällen zu dem Bug, dass die
    // Security-Rules die Erstellung des Members-Dokument ablehnen, weil
    // Firestore denkt, dass das Kurs-Dokument noch nicht erstellt wurde. Durch
    // den Workaround mit dem kurzen Delay kann dieser Bug nicht mehr
    // reproduziert werden.
    //
    // Mit `await` oder `.then` zu warten, bis das Kurs-Dokument erstellt wurde,
    // verhindert zwar den Bug, ermöglicht aber auch nicht mehr der Erstellung
    // der Kurse im Offline-Modus, weswegen der `Future.delayed`-Workaround
    // bevorzugt wurde.
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      references.courses
          .doc(course.id)
          .collection(CollectionNames.members)
          .doc(memberID)
          .set(
            MemberData.create(id: memberID, role: MemberRole.owner, user: user)
                .toJson(),
          );
    });

    _connectionsGateway.addConnectionCreate(
      id: course.id,
      data: course.toUserCourse(MemberRole.owner).toJson(),
      type: GroupType.course,
    );
    return course.toUserCourse(MemberRole.owner);
  }

  Future<AppFunctionsResult<bool>> joinCourse(
    String courseID,
  ) async {
    return _connectionsGateway.joinWithId(
      id: courseID,
      type: GroupType.course,
    );
  }

  Future<AppFunctionsResult<bool>> leaveCourse(String courseID) async {
    return _connectionsGateway.leave(
      id: courseID,
      type: GroupType.course,
    );
  }

  Future<AppFunctionsResult<bool>> kickMember(
      String courseID, String kickedMemberID) async {
    return references.functions.leave(
      id: courseID,
      type: groupTypeToString(GroupType.course),
      memberID: kickedMemberID,
    );
  }

  Future<AppFunctionsResult<bool>> editCourse(Course course) async {
    return references.functions.groupEdit(
      id: course.id,
      data: course.toEditJson(),
      type: groupTypeToString(GroupType.course),
    );
  }

  Course getCourse(String id) {
    final connectionsData = _connectionsGateway.current();
    if (connectionsData != null) {
      return connectionsData.courses[id];
    } else {
      return null;
    }
  }

  Future<AppFunctionsResult<bool>> editCourseSettings(
      String courseID, CourseSettings courseSettings) async {
    return references.functions.groupEditSettings(
      id: courseID,
      settings: courseSettings.toJson(),
      type: groupTypeToString(GroupType.course),
    );
  }

  Future<AppFunctionsResult<bool>> generateNewMeetingID(String courseID) async {
    return references.functions.generateNewMeetingID(
      id: courseID,
      type: groupTypeToString(GroupType.course),
    );
  }

  Future<AppFunctionsResult<bool>> deleteCourse(String courseID) async {
    return references.functions.groupDelete(
      groupID: courseID,
      type: groupTypeToString(GroupType.course),
    );
  }

  /// CHANGES THE GENERAL COLOR OF THE COURSE
  Future<bool> editCourseGeneralDesign(
      {@required String courseID, Design design}) async {
    final course = _connectionsGateway.current().courses[courseID];
    if (course != null) {
      return editCourse(course.copyWith(design: design))
          .then((result) => result.hasData && result.data == true);
    }
    return false;
  }

  /// CHANGES THE PERSONAL COLOR OF THE COURSE
  Future<bool> editCoursePersonalDesign(
      {@required String courseID, Design personalDesign}) async {
    final course = _connectionsGateway.current().courses[courseID];
    if (course != null) {
      await _connectionsGateway.addCoursePersonalDesign(
        id: courseID,
        personalDesignData: personalDesign.toJson(),
        course: course,
      );
      return true;
    }
    return false;
  }

  Future<bool> removeCoursePersonalDesign(String courseID) async {
    final course = _connectionsGateway.current().courses[courseID];
    if (course != null) {
      await _connectionsGateway.removeCoursePersonalDesign(
        courseID: courseID,
        course: course,
      );
      return true;
    }
    return false;
  }

  Future<AppFunctionsResult<bool>> memberUpdateRole(
      {@required String courseID,
      @required String newMemberID,
      @required MemberRole newRole}) {
    return references.functions.memberUpdateRole(
      id: courseID,
      type: groupTypeToString(GroupType.course),
      role: memberRoleEnumToString(newRole),
      memberID: newMemberID,
    );
  }

  MemberRole getRoleFromCourseNoSync(String courseID) {
    if (_connectionsGateway.current() == null) return null;
    Map<String, Course> courses = _connectionsGateway.current().courses;
    if (courses.containsKey(courseID))
      return courses[courseID].myRole;
    else {
      Iterable<Course> filteredJoinedCourses =
          _connectionsGateway.newJoinedCourses.where((it) => it.id == courseID);
      if (filteredJoinedCourses.isNotEmpty)
        return filteredJoinedCourses.first.myRole;
      else
        return null;
    }
  }

  Stream<Course> streamCourse(String courseID) {
    return _connectionsGateway
        .streamConnectionsData()
        .map((connections) => connections.courses[courseID]);
  }

  Stream<List<Course>> streamCourses() {
    return _connectionsGateway.streamConnectionsData().map((connections) =>
        connections.courses.values.where((it) => it != null).toList()
          ..sortAlphabeticly());
  }

  Stream<Map<String, GroupInfo>> getGroupInfoStream(
      SchoolClassGateway schoolClassGateway) {
    final courseStream = streamCourses();
    final schoolClassStream = schoolClassGateway.stream();
    final streamGroup =
        CombineLatestStream([courseStream, schoolClassStream], (streamValues) {
      List<Course> courses = streamValues[0] ?? [];
      List<SchoolClass> schoolClasses = streamValues[1] ?? [];
      List<GroupInfo> groupInfos = [
        for (final course in courses) course.toGroupInfo(),
        for (final schoolClass in schoolClasses) schoolClass.toGroupInfo(),
      ];
      return groupInfos
          .asMap()
          .map((_, groupInfo) => MapEntry(groupInfo.id, groupInfo));
    });
    return streamGroup;
  }

  Future<List<Course>> getCourses() async {
    final connectionData = await _connectionsGateway.get();
    final courses = connectionData?.courses?.values?.toList() ?? [];
    return courses..sortAlphabeticly();
  }

  List<Course> getCurrentCourses() {
    return _connectionsGateway
            .current()
            ?.courses
            ?.values
            ?.where((it) => it != null)
            ?.toList() ??
        []
      ..sortAlphabeticly();
  }

  bool canEditCourse(Course course) => course.version2;
}

extension on List<Course> {
  void sortAlphabeticly() => sort((a, b) => a.name.compareTo(b.name));
}
