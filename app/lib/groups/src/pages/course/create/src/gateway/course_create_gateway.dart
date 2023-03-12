// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import '../bloc/user_input.dart';

class CourseCreateGateway {
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final UserGateway userGateway;

  CourseCreateGateway(
      this.courseGateway, this.userGateway, this.schoolClassGateway);

  Course createCourse(UserInput userInput) {
    final courseData = CourseData.create().copyWith(
      name: userInput.name,
      subject: userInput.subject,
      abbreviation: userInput.abbreviation,
    );
    return courseGateway.createCourse(courseData, userGateway);
  }

  Future<AppFunctionsResult<bool>> createSchoolClassCourse(
      UserInput userInput, String schoolClassId) async {
    final courseData = CourseData.create().copyWith(
      name: userInput.name,
      subject: userInput.subject,
      abbreviation: userInput.abbreviation,
    );
    return schoolClassGateway.createCourse(schoolClassId, courseData);
  }

  List<Course> get currentCourses => courseGateway.getCurrentCourses();
}
