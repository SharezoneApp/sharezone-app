// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/util/api/course_gateway.dart';
import 'package:user/user.dart';

class SubmissionPermissions {
  final Stream<TypeOfUser> typeOfUserStream;
  final CourseGateway courseGateway;

  SubmissionPermissions(this.typeOfUserStream, this.courseGateway);

  Future<bool> isAllowedToViewSubmittedPermissions(HomeworkDto homework) async {
    return _isAdmin(homework.courseID) &&
        _isTeacher(await typeOfUserStream.first);
  }

  bool _isAdmin(String courseID) {
    final role =
        courseGateway.getRoleFromCourseNoSync(courseID) ?? MemberRole.standard;
    return role == MemberRole.admin || role == MemberRole.owner;
  }

  bool _isTeacher(TypeOfUser typeOfUser) => typeOfUser == TypeOfUser.teacher;
}
