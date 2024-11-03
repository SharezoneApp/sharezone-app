import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/course/create/pages/course_template_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../bloc/timetable_selection_bloc.dart';

class TimetableQuickCreateDialog extends StatelessWidget {
  final EmptyPeriodSelection periodSelection;
  final TimetableSelectionBloc selectionBloc;

  const TimetableQuickCreateDialog({
    super.key,
    required this.periodSelection,
    required this.selectionBloc,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height - (height / 5),
      child: StreamBuilder<List<Course>>(
        stream: BlocProvider.of<SharezoneContext>(context)
            .api
            .course
            .streamCourses(),
        builder: (context, snapshot) {
          final courses = snapshot.data ?? [];
          final isCourseListEmpty = courses.isEmpty;
          _sortCoursesByAlphabet(courses);
          return CustomScrollView(
            slivers: <Widget>[
              _AppBar(),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: isCourseListEmpty
                      ? _EmptyCourseList()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: courses
                              .map((course) => _QuickCreateCourseTile(
                                    course: course,
                                    selectionBloc: selectionBloc,
                                    periodSelection: periodSelection,
                                  ))
                              .toList(),
                        ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _sortCoursesByAlphabet(List<Course> courses) {
    courses.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
      centerTitle: false,
      forceElevated: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: <Widget>[
        const _CreateCourseIconButton(),
        const _JoinGroupIconButton(),
        CloseIconButton(color: _getIconColor(context)),
      ],
      title: Text("Stunde hinzufügen",
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _JoinGroupIconButton extends StatelessWidget {
  const _JoinGroupIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.vpn_key),
      tooltip: 'Kurs/Klasse beitreten',
      color: _getIconColor(context),
      onPressed: () => openGroupJoinPage(context),
    );
  }
}

class _CreateCourseIconButton extends StatelessWidget {
  const _CreateCourseIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Kurs erstellen',
      color: _getIconColor(context),
      onPressed: () => Navigator.pushNamed(context, CourseTemplatePage.tag),
    );
  }
}

class _EmptyCourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final modalSheetHeight = height - (height / 5);
    const appBarHeight = 56.0;
    return Material(
      color: Theme.of(context).isDarkTheme
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.white,
      child: SizedBox(
        height: modalSheetHeight - appBarHeight,
        child: Center(
          child: PlaceholderModel(
            iconSize: const Size(175, 175),
            title: "Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!",
            svgPath: 'assets/icons/ghost.svg',
            animateSVG: true,
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CourseManagementButton(
                      iconData: Icons.add,
                      title: "Kurs erstellen",
                      onTap: () =>
                          Navigator.pushNamed(context, CourseTemplatePage.tag),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CourseManagementButton(
                      iconData: Icons.vpn_key,
                      title: "Kurs beitreten",
                      onTap: () => openGroupJoinPage(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickCreateCourseTile extends StatelessWidget {
  const _QuickCreateCourseTile({
    required this.course,
    required this.selectionBloc,
    required this.periodSelection,
  });

  final Course course;
  final TimetableSelectionBloc selectionBloc;
  final EmptyPeriodSelection periodSelection;

  @override
  Widget build(BuildContext context) {
    final hasCreatorPermissions =
        course.myRole.hasPermission(GroupPermission.contentCreation);
    return ListTile(
      enabled: hasCreatorPermissions,
      title: Text(course.name),
      leading: CourseCircleAvatar(
        courseId: course.id,
        abbreviation: course.abbreviation,
      ),
      trailing: !hasCreatorPermissions ? const Icon(Icons.lock) : null,
      onTap: () {
        selectionBloc.createLesson(
          BlocProvider.of<SharezoneContext>(context).api.timetable,
          periodSelection,
          course,
        );
        Navigator.pop(context, course);
      },
    );
  }
}

Color? _getIconColor(BuildContext context) =>
    Theme.of(context).isDarkTheme ? Colors.grey : Colors.grey[600];
