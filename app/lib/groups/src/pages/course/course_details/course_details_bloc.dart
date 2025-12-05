// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:app_functions/app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/groups/analytics/group_analytics.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/models/splitted_member_list.dart';
import 'package:sharezone/util/api/course_gateway.dart';

class CourseDetailsBloc extends BlocBase {
  final CourseDetailsBlocGateway _gateway;
  final UserId memberID;
  final String courseID;

  final _memberSubject = BehaviorSubject<List<MemberData>>();

  CourseDetailsBloc(this._gateway, this.memberID)
    : courseID = _gateway.courseID {
    _memberSubject.addStream(_gateway.members, cancelOnError: false);
  }

  Course get initialData => _gateway.initialData;

  Stream<List<MemberData>> get members => _memberSubject;

  Stream<bool> get isLastMember =>
      _memberSubject.map((list) => list.length <= 1);

  Stream<Course?> get course => _gateway.course;

  Stream<MemberData> streamMemberData(UserId memberID) {
    return _gateway.streamMemberData(memberID.toString());
  }

  Future<AppFunctionsResult<bool>> deleteCourse() async {
    return _gateway.deleteCourse();
  }

  Stream<WritePermission> get writePermissionStream =>
      course
          .map((course) => course!.settings.writePermission)
          .asBroadcastStream();

  Future<AppFunctionsResult<bool>> leaveCourse() async {
    return _gateway.leaveCourse();
  }

  Future<AppFunctionsResult<bool>> kickMember(String kickedMemberID) async {
    return _gateway.kickMember(kickedMemberID);
  }

  Future<AppFunctionsResult<bool>> setIsPublic(bool value) {
    return _gateway.setIsPublic(value);
  }

  Future<bool> setWritePermission(WritePermission writePermission) {
    return _gateway
        .setWritePermission(writePermission)
        .then((result) => result.hasData && result.data == true);
  }

  SplittedMemberList sortMembers(List<MemberData> members) =>
      createSplittedMemberList(members);

  bool hasAdminPermission() =>
      initialData.myRole.hasPermission(GroupPermission.administration);

  Stream<bool> hasAdminPermissionStream() => course.map(
    (course) => course!.myRole.hasPermission(GroupPermission.administration),
  );

  bool isAdmin(MemberRole myRole) => _isAdmin(myRole);

  bool moreThanOneAdmin(List<MemberData> membersDataList) {
    if (membersDataList
            .where(
              (member) =>
                  member.role.hasPermission(GroupPermission.administration),
            )
            .length >
        1) {
      return true;
    } else {
      return false;
    }
  }

  Future<AppFunctionsResult<bool>> updateMemberRole(
    UserId newMemberID,
    MemberRole newRole,
  ) {
    return _gateway.updateMemberRole(
      newMemberID: newMemberID.toString(),
      newRole: newRole,
    );
  }

  @override
  Future<void> dispose() async {
    await _memberSubject.drain();
  }
}

class CourseDetailsBlocGateway {
  final CourseGateway _gateway;
  final Course _course;
  final String courseID;
  final GroupAnalytics _analytics;

  static const _groupType = GroupType.course;

  CourseDetailsBlocGateway(this._gateway, this._course, this._analytics)
    : courseID = _course.id;

  Course get initialData => _course;

  Stream<List<MemberData>> get members =>
      _gateway.memberAccessor.streamAllMembers(_course.id);

  Stream<MemberData> streamMemberData(String memberID) {
    return _gateway.memberAccessor.streamSingleMember(_course.id, memberID);
  }

  Stream<Course?> get course => _gateway.streamCourse(_course.id);

  Future<AppFunctionsResult<bool>> deleteCourse() async {
    _analytics.logDeletedGroup(groupType: _groupType);
    return _gateway.deleteCourse(_course.id);
  }

  Future<AppFunctionsResult<bool>> leaveCourse() async {
    _analytics.logLeftGroup(groupType: _groupType);
    return _gateway.leaveCourse(_course.id);
  }

  Future<AppFunctionsResult<bool>> kickMember(String kickedMemberID) async {
    _analytics.logKickedMember(groupType: _groupType);
    return _gateway.kickMember(courseID, kickedMemberID);
  }

  Future<AppFunctionsResult<bool>> setIsPublic(bool isPublic) {
    _analytics.logChangeGroupVisibility(
      isPublic: isPublic,
      groupType: _groupType,
    );
    return _gateway.editCourseSettings(
      courseID,
      _course.settings.copyWith(isPublic: isPublic),
    );
  }

  Future<AppFunctionsResult<bool>> setWritePermission(
    WritePermission writePermission,
  ) async {
    _analytics.logChangedWritePermission(
      writePermission,
      groupType: _groupType,
    );
    return _gateway.editCourseSettings(
      courseID,
      _course.settings.copyWith(writePermission: writePermission),
    );
  }

  Future<AppFunctionsResult<bool>> updateMemberRole({
    required String newMemberID,
    required MemberRole newRole,
  }) {
    _analytics.logUpdateMemberRole(newRole, groupType: _groupType);
    return _gateway.memberUpdateRole(
      courseID: courseID,
      newMemberID: newMemberID,
      newRole: newRole,
    );
  }
}

SplittedMemberList createSplittedMemberList(List<MemberData> viewList) {
  final admins = viewList.where((user) => _isAdmin(user.role)).toList();
  final creator = viewList.where((user) => _isCreator(user.role)).toList();
  final reader = viewList.where((user) => _isReader(user.role)).toList();

  admins.sort((userA, userB) => userA.name.compareTo(userB.name));
  creator.sort((userA, userB) => userA.name.compareTo(userB.name));
  reader.sort((userA, userB) => userA.name.compareTo(userB.name));

  return SplittedMemberList(admins: admins, creator: creator, reader: reader);
}

bool _isAdmin(MemberRole role) {
  return role == MemberRole.admin || role == MemberRole.owner;
}

bool _isCreator(MemberRole role) {
  return role == MemberRole.creator;
}

bool _isReader(MemberRole role) {
  return role == MemberRole.standard || role == MemberRole.none;
}
