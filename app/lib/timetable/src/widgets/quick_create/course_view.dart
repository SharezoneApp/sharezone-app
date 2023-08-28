// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

class QuickCreateCourseView {
  final String? name, abbreviation;
  final Color? abbreviationColor;
  final Design? design;
  final Course? course;

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
