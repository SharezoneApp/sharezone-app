// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SchoolClassCoursesList extends StatelessWidget {
  const SchoolClassCoursesList({
    super.key,
    required this.schoolClassID,
  });

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    final isAdmin = bloc.isAdmin();
    return Column(
      children: <Widget>[
        CustomCard(
          child: StreamBuilder<List<Course>>(
            stream: bloc.streamCourses(schoolClassID),
            builder: (context, snapshot) {
              List<Course> courses = snapshot.data ?? [];
              return _List(
                courses: courses,
                schoolClassId: schoolClassID,
                isAdmin: isAdmin,
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _List extends StatelessWidget {
  final String schoolClassId;
  final List<Course> courses;
  final bool isAdmin;

  const _List({
    this.courses = const [],
    required this.schoolClassId,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Text("Kurse", style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 4),
        for (final course in courses)
          SchoolClassVariantCourseTile(
            course: course,
            schoolClassId: schoolClassId,
          ),
        if (courses.isEmpty)
          const ListTile(
            title: Text(
                "Es wurden noch keine Kurse zu dieser Klasse hinzugefügt.\n\nErstelle jetzt einen Kurs, der mit der Klasse verknüpft ist."),
          ),
        if (isAdmin) _AddExistingCourse(schoolClassId),
        if (isAdmin) _AddNewCourse(schoolClassId),
      ],
    );
  }
}

class _SchoolCoursesActions extends StatelessWidget {
  const _SchoolCoursesActions({
    required this.title,
    this.onTap,
    this.iconData,
  });

  final String title;
  final VoidCallback? onTap;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(18, 0, 16, 4),
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey[200],
        child: Icon(iconData),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class _AddExistingCourse extends StatelessWidget {
  const _AddExistingCourse(this.schoolClassID);

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<List<Course>>(
      stream: api.course.streamCourses(),
      builder: (context, snapshot) {
        return _SchoolCoursesActions(
          iconData: Icons.group_add,
          title: "Existierenden Kurs hinzufügen",
          onTap: () async {
            if (snapshot.hasData) {
              final courseList = snapshot.data!;
              final futureResult =
                  await _showCourseListDialog(context, courseList);
              if (futureResult != null && context.mounted) {
                showSimpleStateDialog(context, futureResult);
              }
            } else {
              showSnackSec(
                context: context,
                text: 'Bitte warten einen kurzen Augenblick.',
                seconds: 2,
              );
            }
          },
        );
      },
    );
  }

  Future<Future<bool>?> _showCourseListDialog(
    BuildContext context,
    List<Course> courseList,
  ) async {
    return showDialog<Future<bool>>(
        context: context,
        builder: (context) {
          _sortCourseListByAlphabet(courseList);
          return SimpleDialog(
            title: const Text("Wähle einen Kurs aus"),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 6),
                child: Text(
                    "Du kannst nur Kurse hinzufügen, in denen du auch Administrator bist.",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              Column(
                children: courseList
                    .map((course) => _CourseTile(
                        course: course, schoolClassID: schoolClassID))
                    .toList(),
              ),
            ],
          );
        });
  }

  void _sortCourseListByAlphabet(List<Course> courseList) {
    courseList.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({
    required this.course,
    required this.schoolClassID,
  });

  final Course course;
  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final schoolClassGateway =
        BlocProvider.of<SharezoneContext>(context).api.schoolClassGateway;
    final enabled = course.myRole.hasPermission(GroupPermission.administration);
    return DialogTile(
      symbolText: course.abbreviation.toUpperCase(),
      enabled: enabled,
      text: course.name,
      trailing: !enabled
          ? const Icon(Icons.lock, color: Colors.grey, size: 20)
          : null,
      onPressed: () {
        final futureResult = schoolClassGateway
            .addCourse(schoolClassID, course.id)
            .then((result) => result.hasData && result.data == true);
        Navigator.pop(context, futureResult);
      },
    );
  }
}

class _AddNewCourse extends StatelessWidget {
  const _AddNewCourse(this.schoolClassID);

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    return _SchoolCoursesActions(
      iconData: Icons.add,
      title: "Neuen Kurs hinzufügen",
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SchoolClassCourseTemplatePage(schoolClassID: schoolClassID),
          settings:
              const RouteSettings(name: SchoolClassCourseTemplatePage.tag),
        ),
      ),
    );
  }
}
