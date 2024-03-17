// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';

import '../models/user_input.dart';

class CourseCreateGateway {
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final UserGateway userGateway;
  final ConnectionsGateway connectionsGateway;

  CourseCreateGateway(
    this.courseGateway,
    this.userGateway,
    this.schoolClassGateway,
    this.connectionsGateway,
  );

  Stream<List<SchoolClass>?> streamSchoolClasses() {
    return connectionsGateway.streamConnectionsData().map((data) {
      final schoolClasses = data?.schoolClass;
      return schoolClasses?.values.map((value) => value).toList();
    });
  }

  List<SchoolClass>? getCurrentSchoolClasses() {
    final schoolClasses = connectionsGateway.current()?.schoolClass;
    return schoolClasses?.values.map((value) => value).toList();
  }

  (CourseId, CourseName) createCourse(UserInput userInput) {
    final courseData = CourseData.create().copyWith(
      name: userInput.name,
      subject: userInput.subject,
      abbreviation: userInput.abbreviation,
    );

    final course = courseGateway.createCourse(courseData, userGateway);
    return (CourseId(course.id), course.name);
  }

  Future<(CourseId, CourseName)> createSchoolClassCourse(
    UserInput userInput,
    SchoolClassId schoolClassId,
  ) async {
    final courseId = courseGateway.generateCourseId();
    final courseData = CourseData.create().copyWith(
      name: userInput.name,
      subject: userInput.subject,
      abbreviation: userInput.abbreviation,
    );
    await schoolClassGateway.createCourse(
      '$schoolClassId',
      courseData,
      '$courseId',
    );
    return (courseId, courseData.name);
  }

  Future<void> deleteCourse(CourseId courseId) async {
    await courseGateway.deleteCourse('$courseId');
  }

  List<Course> get currentCourses => courseGateway.getCurrentCourses();
}
