import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

class QuickCreateCourseView {
  final String name, abbreviation;
  final Color abbreviationColor;
  final Design design;
  final Course course;

  const QuickCreateCourseView(
      {this.name,
      this.abbreviation,
      this.abbreviationColor,
      this.design,
      this.course});

  factory QuickCreateCourseView.fromCourseAndGroupInfo(
    Course course,
    // ignore:avoid_unused_constructor_parameters
    GroupInfo groupInfo,
  ) {
    return QuickCreateCourseView(
      name: course.name,
      abbreviationColor: course.getDesign().color.withOpacity(0.2),
    );
  }
}
