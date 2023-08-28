// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:design/design.dart';
import 'package:sharezone/util/api/course_gateway.dart';

class CourseEditDesignBloc extends BlocBase {
  final String courseId;
  final CourseGateway courseGateway;

  final Stream<Design?> courseDesign;
  final Stream<Design?> personalDesign;

  CourseEditDesignBloc(this.courseId, this.courseGateway)
      : courseDesign = courseGateway
            .streamCourse(courseId)
            .map((course) => course?.design),
        personalDesign = courseGateway
            .streamCourse(courseId)
            .map((course) => course?.personalDesign);

  Future<void> submitCourseDesign({
    Design? initialDesign,
    required Design selectedDesign,
  }) async {
    if (_hasUserChangedDesign(initialDesign, selectedDesign)) {
      final result = await _editCourseDesign(selectedDesign);
      if (result == false) {
        throw ChangingDesignFailedException();
      }
    }
  }

  void submitPersonalDesign({
    Design? initialDesign,
    required Design selectedDesign,
  }) {
    if (_hasUserChangedDesign(initialDesign, selectedDesign)) {
      _editPersonalDesign(selectedDesign);
    }
  }

  void removePersonalDesign() {
    courseGateway.removeCoursePersonalDesign(courseId);
  }

  void _editPersonalDesign(Design selectedDesign) {
    courseGateway.editCoursePersonalDesign(
        personalDesign: selectedDesign, courseID: courseId);
  }

  Future<bool> _editCourseDesign(Design selectedDesign) async {
    try {
      return courseGateway.editCourseGeneralDesign(
        courseID: courseId,
        design: selectedDesign,
      );
    } catch (e) {
      return false;
    }
  }

  bool _hasUserChangedDesign(Design? initialDesign, Design selectedDesign) =>
      initialDesign != selectedDesign;

  @override
  void dispose() {}
}

/// Thrown when the design couldn't be changed.
class ChangingDesignFailedException implements Exception {}
