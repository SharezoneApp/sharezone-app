// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'package:sharezone/groups/src/pages/course/create/course_create_page.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_create_course.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'share_sharecode.dart';

class GroupOnboardingCreateCourse extends StatelessWidget {
  const GroupOnboardingCreateCourse({
    Key? key,
    required this.schoolClassId,
  }) : super(key: key);

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
              nextPage:
                  GroupOnboardingShareSharecode(schoolClassId: schoolClassId),
              nextTag: GroupOnboardingShareSharecode.tag,
            ),
          ),
        ],
      ),
      children: [
        if (schoolClassId != null)
          SchoolClassCourseCreateTemplateBody(
            schoolClassID: schoolClassId!,
            bottom: _CreateCustomCourse(schoolClassId: schoolClassId),
          )
        else
          CourseTemplatePageBody(
            bottom: _CreateCustomCourse(schoolClassId: schoolClassId),
          )
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

class _CreateCustomCourse extends StatelessWidget {
  const _CreateCustomCourse({
    Key? key,
    required this.schoolClassId,
  }) : super(key: key);

  final String? schoolClassId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          const Headline("Dein Kurs ist nicht dabei?"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add_circle, color: Colors.white),
                SizedBox(width: 8.0),
                Text("EIGENEN KURS ERSTELLEN",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            onPressed: () {
              if (schoolClassId != null) {
                openSchoolClassCourseCreatePage(context, schoolClassId!);
              } else {
                openCourseCreatePage(context);
              }
            },
          )
        ],
      ),
    );
  }
}
