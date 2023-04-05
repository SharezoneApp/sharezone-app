// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';

class DashboardGateway {
  final HomeworkGateway homeworkGateway;
  final BlackboardGateway blackboardGateway;
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final UserGateway userGateway;

  DashboardGateway(
      this.homeworkGateway,
      this.blackboardGateway,
      this.timetableGateway,
      this.courseGateway,
      this.schoolClassGateway,
      this.userGateway);
}
