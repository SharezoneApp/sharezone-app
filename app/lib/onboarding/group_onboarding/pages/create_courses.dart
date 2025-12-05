// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/pages/course/create/pages/course_template_page.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';

import 'share_sharecode.dart';

class GroupOnboardingCreateCourse extends StatelessWidget {
  const GroupOnboardingCreateCourse({super.key, required this.schoolClassId});

  static const tag = 'onboarding-course-page';
  final String? schoolClassId;

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingPageTemplate(
      title: getTitle(context),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          OnboardingNavigationBar(
            action: OnboardingNavigationBarContinueButton(
              nextPage: GroupOnboardingShareSharecode(
                schoolClassId: schoolClassId,
              ),
              nextTag: GroupOnboardingShareSharecode.tag,
            ),
          ),
        ],
      ),
      children: [
        if (schoolClassId != null)
          CourseTemplatePageBody(
            schoolClassId: SchoolClassId(schoolClassId!),
            withCreateCustomCourseSection: true,
          )
        else
          const CourseTemplatePageBody(withCreateCustomCourseSection: true),
      ],
    );
  }

  String getTitle(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    if (bloc.isTeacher && bloc.teacherType == TeacherType.courseTeacher) {
      return 'Welche Kurse unterrichtest du?';
    }
    return 'Welche Kurse sollen mit der Klasse verbunden werden?';
  }
}
