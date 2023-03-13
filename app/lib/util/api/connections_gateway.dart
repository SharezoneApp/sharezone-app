// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:app_functions/app_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone_common/database_foundation.dart';
import 'package:sharezone_common/references.dart';

class ConnectionsGateway implements MyConnectionsAccesor {
  DataCollectionPackage<Course> joinedCoursesPackage;
  DataDocumentPackage<ConnectionsData> _connectionDataPackage;
  List<Course> newJoinedCourses = [];

  ConnectionsGateway(this.references, this.memberID) {
    _connectionDataPackage = DataDocumentPackage(
        reference: references.getConnectionsReference(memberID),
        objectBuilder: (data) => ConnectionsData.fromData(data: data),
        directlyLoad: true,
        loadNullData: true);
    joinedCoursesPackage = DataCollectionPackage(
        reference: references.users
            .doc(MemberIDUtils.getUIDFromMemberID(memberID))
            .collection("joinedCourses"),
        objectBuilder: (id, data) => Course.fromData(data, id: id).copyWith(
              sharecode: data['sharingLink'] as String,
              version2: false,
              myRole: MemberRole.creator,
            ));
    joinedCoursesPackage.stream.listen((joinedCourses) async {
      newJoinedCourses =
          (await Future.wait(joinedCourses.map((joinedCourse) async {
        final joinedUserData = (await references.courses
                    .doc(joinedCourse.id)
                    .collection("joinedUsers")
                    .doc(MemberIDUtils.getUIDFromMemberID(memberID))
                    .get())
                .data() ??
            {};
        return joinedCourse.copyWith(
            myRole: joinedUserData['powerLevel'] == 'owner'
                ? MemberRole.owner
                : MemberRole.creator);
      })))
              .toList();
      _connectionDataPackage.forceUpdate();
    });
  }

  final References references;
  final String memberID;

  /// Kombiniert aktuell noch ConnectionsData mit der alten joinedCourses Struktur
  @override
  Stream<ConnectionsData> streamConnectionsData() {
    return _connectionDataPackage.stream.map((connectionsData) {
      final newdata = (connectionsData ?? ConnectionsData.fromData(data: null))
          .copyWithJoinedCourses(newJoinedCourses);
      return newdata;
    });
  }

  ConnectionsData current() {
    if (_connectionDataPackage.data == null) return null;
    return _connectionDataPackage.data.copyWithJoinedCourses(newJoinedCourses);
  }

  Future<ConnectionsData> get() async {
    final connectionData = await _connectionDataPackage.once;
    return connectionData.copyWithJoinedCourses(newJoinedCourses);
  }

  Future<AppFunctionsResult> joinByKey({
    @required String publicKey,
    @required List<String> coursesForSchoolClass,
    int version = 2,
  }) {
    return references.functions.joinGroupByValue(
      enteredValue: publicKey,
      coursesForSchoolClass: coursesForSchoolClass,
      memberID: memberID,
      version: version,
    );
  }

  Future<AppFunctionsResult> joinByJoinLink({String joinLink}) {
    return references.functions.joinGroupByValue(
      enteredValue: joinLink,
      memberID: memberID,
    );
  }

  Future<void> addConnectionCreate(
      {@required String id,
      @required GroupType type,
      Map<String, dynamic> data}) {
    return references.getConnectionsReference(memberID).set({
      _getCamelCaseGroupType(type): {id: data},
    }, SetOptions(merge: true));
  }

  /// Warum wird nicht einfach [groupTypeToString(type)] verwendet? Für
  /// [addConnectionCreate] ist es notwenig, dass der Wert für z.B. Kurse
  /// "Courses" ist. Mit [groupTypeToString(type)] ist der Wert jedoch
  /// "courses", wodurch der Client diesen Kurs ignoriert (es entsteht dieser
  /// Bug: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/984)
  String _getCamelCaseGroupType(GroupType groupType) {
    switch (groupType) {
      case GroupType.course:
        return 'Courses';
      case GroupType.schoolclass:
        return 'SchoolClasses';
      case GroupType.school:
        return 'School';
    }
    throw UnimplementedError('There is no string for $groupType');
  }

  Future<void> addCoursePersonalDesign({
    @required String id,
    @required dynamic personalDesignData,
    @required Course course,
  }) {
    if (course.version2) {
      return references.getConnectionsReference(memberID).set({
        CollectionNames.courses: {
          id: {'personalDesign': personalDesignData},
        },
      }, SetOptions(merge: true));
    } else {
      return references.users
          .doc(MemberIDUtils.getUIDFromMemberID(memberID))
          .collection("joinedCourses")
          .doc(id)
          .set({'personalDesign': personalDesignData}, SetOptions(merge: true));
    }
  }

  Future<void> removeCoursePersonalDesign({String courseID, Course course}) {
    if (course.version2) {
      return references.getConnectionsReference(memberID).set({
        CollectionNames.courses: {
          courseID: {'personalDesign': FieldValue.delete()}
        }
      }, SetOptions(merge: true));
    } else {
      return references.users
          .doc(MemberIDUtils.getUIDFromMemberID(memberID))
          .collection("joinedCourses")
          .doc(courseID)
          .set(
              {'personalDesign': FieldValue.delete()}, SetOptions(merge: true));
    }
  }

  Future<AppFunctionsResult<bool>> joinWithId({
    @required String id,
    @required GroupType type,
  }) async {
    return references.functions.joinWithGroupId(
      id: id,
      type: groupTypeToString(type),
      uId: memberID,
    );
  }

  Future<AppFunctionsResult<bool>> leave(
      {@required String id, @required GroupType type}) {
    return references.functions.leave(
      id: id,
      type: groupTypeToString(type),
      memberID: memberID,
    );
  }

  Future<AppFunctionsResult<bool>> delete(
      {@required String id,
      @required GroupType type,
      SchoolClassDeleteType schoolClassDeleteType}) {
    return references.functions.groupDelete(
      groupID: id,
      type: groupTypeToString(type),
      schoolClassDeleteType: schoolClassTypeToString(schoolClassDeleteType),
    );
  }

  Future<void> dispose() async {
    await _connectionDataPackage.close();
    await joinedCoursesPackage.close();
  }
}
