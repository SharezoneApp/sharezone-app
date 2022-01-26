// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/schoolGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/references.dart';

class SharezoneGateway {
  // ignore:unused_field
  final AuthUser _authUser;
  final String uID;
  final UserId userId;
  final HomeworkGateway homework;
  final BlackboardGateway blackboard;
  final FileSharingGateway fileSharing;
  final UserGateway user;

  final References references;
  final String memberID;
  final ConnectionsGateway connectionsGateway;
  final CourseGateway course;
  final SchoolClassGateway schoolClassGateway;
  final SchoolGateway schoolGateway;
  final TimetableGateway timetable;

  factory SharezoneGateway({
    @required String memberID,
    @required References references,
    @required AuthUser authUser,
  }) {
    final connectionsGateway = ConnectionsGateway(references, memberID);
    return SharezoneGateway._(
      connectionsGateway: connectionsGateway,
      memberID: memberID,
      references: references,
      course: CourseGateway(references, memberID, connectionsGateway),
      schoolClassGateway:
          SchoolClassGateway(references, memberID, connectionsGateway),
      schoolGateway: SchoolGateway(references, memberID, connectionsGateway),
      authUser: authUser,
      timetable: TimetableGateway(references, memberID),
    );
  }

  SharezoneGateway._({
    @required AuthUser authUser,
    @required this.connectionsGateway,
    @required this.memberID,
    @required this.references,
    @required this.course,
    @required this.schoolClassGateway,
    @required this.schoolGateway,
    @required this.timetable,
  })  : _authUser = authUser,
        uID = authUser.uid,
        userId = UserId(authUser.uid),
        homework = HomeworkGateway(
            userId: authUser.uid,
            firestore: references.firestore,
            typeOfUserStream: UserGateway(references, authUser)
                .userStream
                .map((user) => user?.typeOfUser)),
        blackboard = BlackboardGateway(
            authUser: authUser, firestore: references.firestore),
        fileSharing =
            FileSharingGateway(user: authUser, references: references),
        user = UserGateway(references, authUser);
}
