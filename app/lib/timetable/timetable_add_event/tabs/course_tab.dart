// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_event_page.dart';

class _CourseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return _TimetableAddSection(
      index: 1,
      title: 'Wähle einen Kurs aus',
      child: StreamBuilder<List<Course>>(
        stream: api.course.streamCourses(),
        builder: (context, snapshot) => _CourseList(snapshot.data),
      ),
    );
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList(this.courseList);

  final List<Course>? courseList;

  List<Widget> getLines(List<Course> courseList, Course? selectedCourse) {
    final list = <Widget>[];
    for (int i = 0; i < courseList.length; i += 2) {
      final first = _CourseTile(
        course: courseList[i],
        color: selectedCourse == courseList[i]
            ? Colors.lightGreen
            : Colors.lightBlue,
      );
      final second = i + 1 < courseList.length
          ? _CourseTile(
              course: courseList[i + 1],
              color: selectedCourse == courseList[i + 1]
                  ? Colors.lightGreen
                  : Colors.lightBlue,
            )
          : const Text("");
      list.add(_LineWithTwoWidgets(first: first, second: second));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    if (courseList == null) return Container();
    _sortCourseListByAlphabet();
    return StreamBuilder<Course>(
      stream: bloc.course,
      builder: (context, courseSnapshot) {
        final selectedCourse = courseSnapshot.data;
        if (courseList!.isEmpty) return const _EmptyCourseList();
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Column(
                children: <Widget>[
                  _LineWithTwoWidgets(
                    first: _JoinCourse(),
                    second: _CreateCourse(),
                  ),
                  ...getLines(courseList!, selectedCourse),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sortCourseListByAlphabet() {
    courseList!.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course, this.color});

  final Course course;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    final hasPermissions =
        course.myRole.hasPermission(GroupPermission.contentCreation);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Opacity(
        opacity: hasPermissions ? 1 : 0.5,
        child: _RectangleButton(
          title: course.name,
          leading: hasPermissions ? courseAvatar() : lockAvatar(),
          backgroundColor: hasPermissions
              ? color?.withOpacity(0.14)
              : Colors.grey.withOpacity(0.14),
          onTap: hasPermissions
              ? () async {
                  bloc.changeCourse(course);

                  await Future.delayed(const Duration(
                      milliseconds: 200)); // Waiting for selecting feedback
                  if (!context.mounted) return;

                  navigateToNextTab(context);
                }
              : null,
        ),
      ),
    );
  }

  Widget courseAvatar() => CircleAvatar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        child: Text(course.abbreviation),
      );
  Widget lockAvatar() => const CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        child: Icon(Icons.lock),
      );
}

class _LineWithTwoWidgets extends StatelessWidget {
  const _LineWithTwoWidgets({
    required this.first,
    required this.second,
  });

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: first),
        const SizedBox(width: 8),
        Expanded(child: second),
      ],
    );
  }
}

class _JoinCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return _CourseManagementButtons(
      title: "Kurs beitreten",
      iconData: Icons.vpn_key,
      onTap: () async {
        final course = await handleCourseDialogOption(
            context, CourseDialogOption.groupJoin);
        if (course != null) {
          bloc.changeCourse(course as Course);
        }
      },
    );
  }
}

class _CreateCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return _CourseManagementButtons(
      title: "Kurs erstellen",
      iconData: Icons.add,
      onTap: () async {
        final course = await handleCourseDialogOption(
            context, CourseDialogOption.courseCreate);
        if (course != null) {
          bloc.changeCourse(course as Course);
        }
      },
    );
  }
}

class _CourseManagementButtons extends StatelessWidget {
  const _CourseManagementButtons({
    required this.title,
    this.iconData,
    this.onTap,
  });

  final IconData? iconData;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _RectangleButton(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(iconData, color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Colors.grey.withOpacity(0.2),
      title: title,
      onTap: onTap,
    );
  }
}
