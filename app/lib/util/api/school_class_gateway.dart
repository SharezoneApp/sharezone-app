// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:group_domain_implementation/group_domain_accessors_implementation.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone_common/references.dart';

class SchoolClassGateway {
  final References references;
  final String memberID;
  final ConnectionsGateway _connectionsGateway;
  final SchoolClassMemberAccessor memberAccessor;

  factory SchoolClassGateway(References references, String memberID,
      ConnectionsGateway connectionsGateway) {
    return SchoolClassGateway._(
      references,
      memberID,
      connectionsGateway,
      FirestoreSchoolClassMemberAccessor(references.firestore),
    );
  }

  const SchoolClassGateway._(this.references, this.memberID,
      this._connectionsGateway, this.memberAccessor);

  Future<AppFunctionsResult<bool>> leaveSchoolClass(String schoolClassID) {
    return _connectionsGateway.leave(
      id: schoolClassID,
      type: GroupType.schoolclass,
    );
  }

  Future<AppFunctionsResult<bool>> deleteSchoolClass(
      String schoolClassID, SchoolClassDeleteType schoolClassDeleteType) {
    return _connectionsGateway.delete(
      id: schoolClassID,
      type: GroupType.schoolclass,
      schoolClassDeleteType: schoolClassDeleteType,
    );
  }

  Future<AppFunctionsResult<bool>> updateMemberRole(
      String schoolClassID, String memberID, MemberRole newRole) {
    return references.functions.memberUpdateRole(
      id: schoolClassID,
      memberID: memberID,
      role: memberRoleEnumToString(newRole),
      type: groupTypeToString(GroupType.schoolclass),
    );
  }

  Future<AppFunctionsResult<bool>> createSchoolClass(
      SchoolClassData schoolClass) {
    return references.functions.groupCreate(
      memberID: memberID,
      id: schoolClass.id,
      data: schoolClass.toCreateJson(),
      type: groupTypeToString(GroupType.schoolclass),
    );
  }

  Future<AppFunctionsResult<bool>> generateNewMeetingID(String schoolClassID) {
    return references.functions.generateNewMeetingID(
      id: schoolClassID,
      type: groupTypeToString(GroupType.schoolclass),
    );
  }

  Future<AppFunctionsResult<bool>> createCourse(
      String schoolClassID, CourseData courseData) {
    String courseID = references.courses.doc().id;
    return references.functions.groupCreate(
      memberID: memberID,
      id: courseID,
      data: courseData.copyWith(
          id: courseID,
          referenceSchoolClassIDs: [schoolClassID]).toCreateJson(memberID),
      type: groupTypeToString(GroupType.course),
    );
  }

  Future<AppFunctionsResult<bool>> editSchoolClass(SchoolClass schoolClass) {
    return references.functions.groupEdit(
      id: schoolClass.id,
      data: schoolClass.toJson(),
      type: groupTypeToString(GroupType.schoolclass),
    );
  }

  Future<AppFunctionsResult<bool>> addCourse(
      String schoolClassID, String courseID) {
    return references.functions.schoolClassAddCourse(
      schoolClassID: schoolClassID,
      courseID: courseID,
    );
  }

  Future<AppFunctionsResult<bool>> removeCourse(
      String schoolClassID, String courseID) {
    return references.functions.schoolClassRemoveCourse(
      schoolClassID: schoolClassID,
      courseID: courseID,
    );
  }

  Future<AppFunctionsResult<bool>> editSchoolClassSettings(
      String schoolClassID, CourseSettings schoolClassSettings) async {
    return references.functions.groupEditSettings(
      id: schoolClassID,
      settings: schoolClassSettings.toJson(),
      type: groupTypeToString(GroupType.schoolclass),
    );
  }

  Future<AppFunctionsResult<bool>> kickMember(
      String schoolClassID, String kickedMemberID) async {
    return references.functions.leave(
      id: schoolClassID,
      type: groupTypeToString(GroupType.schoolclass),
      memberID: kickedMemberID,
    );
  }

  Stream<List<Course>> streamCourses(String schoolClassID) {
    return references.schoolClasses
        .doc(schoolClassID)
        .collection(CollectionNames.courses)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnap) => Course.fromData(docSnap.data(), id: docSnap.id))
            .toList());
  }

  Stream<List<String>> streamCoursesID(String schoolClassID) {
    return references.schoolClasses
        .doc(schoolClassID)
        .collection(CollectionNames.courses)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnap) => docSnap.id).toList());
  }

  Stream<List<SchoolClass>> stream() {
    return _connectionsGateway
        .streamConnectionsData()
        .map((connections) => connections?.schoolClass?.values?.toList());
  }

  Stream<SchoolClass> streamSingleSchoolClass(String id) {
    return _connectionsGateway.streamConnectionsData().map((connections) =>
        connections.schoolClass.values
            .where((schoolClass) => schoolClass.id == id)
            .first);
  }
}
