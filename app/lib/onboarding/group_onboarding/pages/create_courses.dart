import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:sharezone/groups/src/pages/course/create/course_create_page.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_create_course.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone_widgets/theme.dart';

import 'share_sharecode.dart';

class GroupOnboardingCreateCourse extends StatelessWidget {
  const GroupOnboardingCreateCourse({Key key, @required this.schoolClassId})
      : assert(schoolClassId != null),
        super(key: key);

  static const tag = 'onboarding-course-page';
  final Optional<String> schoolClassId;

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingPageTemplate(
      title: getTitle(context),
      children: [
        if (schoolClassId.isPresent)
          SchoolClassCourseCreateTemplateBody(
            schoolClassID: schoolClassId.value,
            bottom: _CreateCustomCourse(schoolClassId: schoolClassId),
          )
        else
          CourseTemplatePageBody(
            bottom: _CreateCustomCourse(schoolClassId: schoolClassId),
          )
      ],
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
    );
  }

  String getTitle(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    if (bloc.isTeacher && bloc.teacherType == TeacherType.courseTeacher)
      return 'Welche Kurse unterrichtest du?';
    return 'Welche Kurse sollen mit der Klasse verbunden werden?';
  }
}

class _CreateCustomCourse extends StatelessWidget {
  const _CreateCustomCourse({Key key, this.schoolClassId}) : super(key: key);

  final Optional<String> schoolClassId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Headline("Dein Kurs ist nicht dabei?"),
          RaisedButton(
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.add_circle, color: Colors.white),
                SizedBox(width: 8.0),
                Text("EIGENEN KURS ERSTELLEN",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            onPressed: () {
              if (schoolClassId.isPresent) {
                openSchoolClassCourseCreatePage(context, schoolClassId.value);
              } else {
                openCourseCreatePage(context);
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )
        ],
      ),
    );
  }
}
