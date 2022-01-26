// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/api_errors.dart';

import 'course_member_accessor.dart';
import 'school_class_member_accessor.dart';

class GroupMemberAccessor {
  final CourseMemberAccessor courseMemberAccessor;
  final SchoolClassMemberAccessor schoolClassMemberAccessor;

  const GroupMemberAccessor({
    @required this.courseMemberAccessor,
    @required this.schoolClassMemberAccessor,
  });

  Stream<List<MemberData>> streamAllMembers(GroupKey groupKey) {
    if (groupKey.groupType == GroupType.course) {
      return courseMemberAccessor.streamAllMembers(groupKey.id);
    }
    if (groupKey.groupType == GroupType.schoolclass) {
      return schoolClassMemberAccessor.streamAllMembers(groupKey.id);
    }
    throw InvalidGroupKeyException();
  }

  Stream<MemberData> streamSingleMember(GroupKey groupKey, UserId memberID) {
    if (groupKey.groupType == GroupType.course) {
      return courseMemberAccessor.streamSingleMember(
          groupKey.id, memberID.toString());
    }
    if (groupKey.groupType == GroupType.schoolclass) {
      return schoolClassMemberAccessor.streamSingleMember(
          groupKey.id, memberID.toString());
    }
    throw InvalidGroupKeyException();
  }
}
