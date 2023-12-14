// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/firebase_helper.dart';
import 'package:sharezone_common/references.dart';

class ConnectionsData {
  final Map<String, SchoolClass>? schoolClass;
  final Map<String?, Course> courses;

  const ConnectionsData._({
    required this.schoolClass,
    required this.courses,
  });

  static ConnectionsData? fromData({required Map<String, dynamic>? data}) {
    if (data == null) {
      return const ConnectionsData._(
        schoolClass: null,
        courses: {},
      );
    }

    Map<String, SchoolClass> schoolClasses = decodeMap(
        data[CollectionNames.schoolClasses],
        (key, data) => SchoolClass.fromData(data, id: key));
    return ConnectionsData._(
      schoolClass: schoolClasses,
      courses: decodeMap(data[CollectionNames.courses],
          (key, data) => Course.fromData(data, id: key)),
    );
  }

  ConnectionsData copyWithJoinedCourses(List<Course> joinedCourses) {
    Map<String?, Course> courseMap = Map.of(courses);
    for (Course course in joinedCourses) {
      if (!courseMap.containsKey(course.id)) {
        courseMap[course.id] = course;
      }
    }
    return ConnectionsData._(
      schoolClass: schoolClass,
      courses: courseMap,
    );
  }
}
