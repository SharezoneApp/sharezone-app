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
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({
    Key? key,
    required this.editMode,
    required this.onChanged,
    required this.courseStream,
  }) : super(key: key);

  final bool editMode;
  final ValueChanged<Course> onChanged;
  final Stream<Course> courseStream;

  static Future<void> onTap(
    BuildContext context, {
    // Currently different callsite use different callbacks.
    // We should move to returning `CourseId` in the future for all callsites.
    void Function(Course)? onChanged,
    void Function(CourseId)? onChangedId,
  }) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;

    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!context.mounted) return;

    _showCourseListDialog(
        context,
        api,
        (newCourse) => onChangedId != null
            ? onChangedId(CourseId(newCourse.id))
            : onChanged!(newCourse));
  }

  static void _showCourseListDialog(BuildContext context, SharezoneGateway api,
          void Function(Course) onChanged) =>
      showDialog(
        context: context,
        builder: (context) => StreamBuilder<List<Course>>(
          stream: api.course.streamCourses(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final courseList = snapshot.data ?? [];
            _sortCourseListByAlphabet(courseList);
            return SimpleDialog(
              title: const Text('Wähle einen Kurs aus'),
              children: <Widget>[
                _CourseList(courseList: courseList, onChanged: onChanged),
                const Divider(),
                const _JoinCreateCourseFooter(),
              ],
            );
          },
        ),
      );

  static void _sortCourseListByAlphabet(List<Course> courseList) =>
      courseList.sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course>(
        stream: courseStream,
        builder: (context, snapshot) {
          return CourseTileBase(
            courseName: snapshot.data?.name,
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            onTap: editMode ? null : () => onTap(context, onChanged: onChanged),
          );
        });
  }
}

class CourseTileBase extends StatelessWidget {
  final String? courseName;
  final String? errorText;

  /// If null disables tile.
  final VoidCallback? onTap;

  const CourseTileBase({
    required this.courseName,
    required this.errorText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: const Text("Kurs"),
      subtitle: Text(
        errorText ?? courseName ?? HwDialogErrorStrings.emptyCourse,
        style: errorText != null ? const TextStyle(color: Colors.red) : null,
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      enabled: onTap != null,
      onTap: () => onTap!(),
    );
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList({
    Key? key,
    required this.courseList,
    required this.onChanged,
  }) : super(key: key);

  final List<Course> courseList;
  final ValueChanged<Course> onChanged;

  @override
  Widget build(BuildContext context) {
    if (courseList.isEmpty) return _EmptyCourseList();
    _sortCourseListByAlphabet(courseList);
    return Column(
      children: courseList.map((course) {
        final enabled =
            course.myRole.hasPermission(GroupPermission.contentCreation);
        return Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: course.getDesign().color),
          child: DialogTile(
            symbolText: course.abbreviation,
            text: course.name,
            trailing: !enabled
                ? const Icon(Icons.lock, color: Colors.grey, size: 20)
                : null,
            enabled: enabled,
            onPressed: () {
              onChanged(course);
              Navigator.pop(context);
            },
          ),
        );
      }).toList(),
    );
  }

  void _sortCourseListByAlphabet(List<Course> courseList) {
    courseList.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _EmptyCourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Du bist noch kein Mitglied eines Kurses 😔\nErstelle oder tritt einem Kurs bei 😃",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _JoinCreateCourseFooter extends StatelessWidget {
  const _JoinCreateCourseFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DialogTile(
          text: "Kurs beitreten",
          symbolIconData: Icons.vpn_key,
          onPressed: () => openGroupJoinPage(context),
        ),
        DialogTile(
          symbolIconData: Icons.add,
          text: "Kurs erstellen",
          onPressed: () => Navigator.pushNamed(context, CourseTemplatePage.tag),
        )
      ],
    );
  }
}
