// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/analytics/group_analytics.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/util/api.dart';

enum SchoolClassDeleteType {
  withCourses,
  withoutCourses,
}

class MySchoolClassBloc extends BlocBase {
  final SharezoneGateway gateway;
  final SchoolClass? schoolClass;
  final GroupAnalytics analytics;
  String? schoolClassId;

  static const _groupType = GroupType.schoolclass;

  MySchoolClassBloc({
    required this.gateway,
    required this.analytics,
    this.schoolClass,
  }) {
    schoolClassId = schoolClass?.id;
  }

  Future<AppFunctionsResult<bool>> createSchoolClass(String name) {
    final id = gateway.references.schoolClasses.doc().id;
    final schoolClassData = SchoolClassData.create().copyWith(
      id: id,
      name: name,
    );
    schoolClassId = id;
    return gateway.schoolClassGateway.createSchoolClass(schoolClassData);
  }

  Stream<List<SchoolClass>> streamSchoolClasses() {
    return gateway.schoolClassGateway.stream();
  }

  Stream<WritePermission> writePermissionStream() {
    return streamSchoolClass()
        .map((schoolClass) => schoolClass!.settings.writePermission)
        .asBroadcastStream();
  }

  Stream<SchoolClass?> streamSchoolClass() {
    if (schoolClassId == null) {
      return Stream.empty();
    }
    return gateway.schoolClassGateway.streamSingleSchoolClass(schoolClassId!);
  }

  Stream<List<MemberData>> streamMembers(String schoolClassID) {
    return gateway.schoolClassGateway.memberAccessor
        .streamAllMembers(schoolClassID);
  }

  Stream<MemberData> streamMember(String schoolClassID, String memberID) {
    return gateway.schoolClassGateway.memberAccessor
        .streamSingleMember(schoolClassID, memberID);
  }

  Future<AppFunctionsResult<bool>> updateMemberRole(
      String schoolClassID, UserId memberID, MemberRole newRole) {
    analytics.logUpdateMemberRole(newRole, groupType: _groupType);
    return gateway.schoolClassGateway
        .updateMemberRole(schoolClassID, memberID.toString(), newRole);
  }

  bool moreThanOneAdmin(List<MemberData> membersDataList) {
    if (membersDataList
            .where((member) =>
                member.role.hasPermission(GroupPermission.administration))
            .length >
        1) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<Course>> streamCourses(String schoolClassID) {
    return gateway.schoolClassGateway.streamCourses(schoolClassID);
  }

  Future<AppFunctionsResult<bool>> leaveSchoolClass() async {
    analytics.logLeftGroup(groupType: _groupType);
    return gateway.schoolClassGateway.leaveSchoolClass(schoolClassId!);
  }

  Future<AppFunctionsResult<bool>> deleteSchoolClass(
      SchoolClassDeleteType schoolClassDeleteType) async {
    analytics.logDeletedGroup(groupType: _groupType);
    return gateway.schoolClassGateway
        .deleteSchoolClass(schoolClassId!, schoolClassDeleteType);
  }

  Future<AppFunctionsResult<bool>> kickMember(String kickedMemberID) async {
    analytics.logKickedMember(groupType: _groupType);
    return gateway.schoolClassGateway
        .kickMember(schoolClassId!, kickedMemberID);
  }

  Future<AppFunctionsResult<bool>> setIsPublic(bool isPublic) {
    analytics.logChangeGroupVisibility(
        isPublic: isPublic, groupType: _groupType);
    return gateway.schoolClassGateway.editSchoolClassSettings(
        schoolClassId!, schoolClass!.settings.copyWith(isPublic: isPublic));
  }

  Future<bool> setWritePermission(WritePermission writePermission) {
    analytics.logChangedWritePermission(writePermission, groupType: _groupType);
    return gateway.schoolClassGateway
        .editSchoolClassSettings(schoolClassId!,
            schoolClass!.settings.copyWith(writePermission: writePermission))
        .then((result) => result.hasData && result.data == true);
  }

  bool isAdmin() {
    return schoolClass!.myRole.hasPermission(GroupPermission.administration);
  }

  Stream<bool> isAdminStream() {
    return streamSchoolClass()
        .map((sc) => sc!.myRole.hasPermission(GroupPermission.administration));
  }

  @override
  void dispose() {}
}
