// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_common/references.dart';

class ConnectionsData {
  final Map<String, SchoolClass> schoolClass;
  final Map<String, Course> courses;

  const ConnectionsData._({@required this.schoolClass, @required this.courses});

  factory ConnectionsData.fromData({@required Map<String, dynamic> data}) {
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
    Map<String, Course> courseMap = Map.of(courses);
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

  GroupInfo getGroupInfo(GroupKey groupKey) {
    if (groupKey.groupType == GroupType.course) {
      return courses[groupKey.id].toGroupInfo();
    } else if (groupKey.groupType == GroupType.schoolclass) {
      return schoolClass[groupKey.id].toGroupInfo();
    }
    return null;
  }

  List<GroupInfo> getGroups() {
    final courseList =
        courses.values.map((courseInfo) => courseInfo.toGroupInfo());
    final schoolClassList =
        schoolClass.values.map((schoolClass) => schoolClass.toGroupInfo());
    final list = <GroupInfo>[];
    list.addAll(courseList);
    list.addAll(schoolClassList);
    return list;
  }
}
