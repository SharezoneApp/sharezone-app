// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:date/weektype.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/timetable/src/bloc/timetable_selection_bloc.dart';
import 'package:sharezone/timetable/src/logic/timetable_element_dimensions.dart';
import 'package:sharezone/timetable/src/logic/timetable_period_dimensions.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_tile.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

Color? _getIconColor(BuildContext context) =>
    Theme.of(context).isDarkTheme ? Colors.grey : Colors.grey[600];

class TimetableDayView extends StatefulWidget {
  const TimetableDayView({
    super.key,
    required this.date,
    required this.weekType,
    required this.elements,
    required this.hourHeight,
    required this.width,
    required this.timetableBegin,
    required this.periods,
  });

  final double hourHeight;
  final Time timetableBegin;
  final List<TimetableElement> elements;
  final Periods periods;
  final double width;
  final Date date;
  final WeekType weekType;

  @override
  State createState() => _TimetableDayViewState();
}

class _TimetableDayViewState extends State<TimetableDayView> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([globalKey]));
  }

  EmptyPeriodSelection getEmptyPeriodSelection(Period period) =>
      EmptyPeriodSelection(
        date: widget.date,
        weekType: widget.weekType,
        period: period,
      );

  List<Widget> getPositionedPeriodElementTiles({
    required BuildContext context,
    List<Period> periodList = const [],
    EmptyPeriodSelection? selection,
    required TimetableSelectionBloc selectionBloc,
    required Time timetableBegin,
    required double hourHeight,
  }) {
    final list = <Widget>[];
    for (int i = 0; i < periodList.length; i++) {
      final widget = _PositionedPeriodElementTile(
        period: periodList[i],
        timetableBegin: timetableBegin,
        hourHeight: hourHeight,
        isSelected: selection == getEmptyPeriodSelection(periodList[i]),
        onHighlightChanged: (value) {
          if (value) {
            selectionBloc
                .onTapSelection(getEmptyPeriodSelection(periodList[i]));
          } else {
            selectionBloc.clearSelections();
          }
        },
        onTap: () {
          _openQuickCreateLessonDialog(
              context, getEmptyPeriodSelection(periodList[i]));
        },
      );

      // if (i == 3)
      //   list.add(
      //     Showcase(
      //       key: globalKey,
      //       child: widget,
      //       title: "Stunde eintragen",
      //       description:
      //           "Klicke einfach auf ein leeres Feld, um eine neue Stunde einzutragen.",
      //     ),
      //   );
      // else
      list.add(widget);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final selectionBloc = BlocProvider.of<TimetableSelectionBloc>(context);
    final periodList = widget.periods.getPeriods();
    return Expanded(
      flex: 3,
      child: StreamBuilder<EmptyPeriodSelection?>(
          stream: selectionBloc.emptyPeriodSelections,
          builder: (context, snapshot) {
            final selection = snapshot.data;
            return Stack(
              children: [
                ...getPositionedPeriodElementTiles(
                  context: context,
                  selection: selection,
                  selectionBloc: selectionBloc,
                  periodList: periodList,
                  hourHeight: widget.hourHeight,
                  timetableBegin: widget.timetableBegin,
                ),
                for (final element
                    in widget.elements
                      ..sort((e1, e2) => e1.priority.compareTo(e2.priority)))
                  TimetableElementTile(element, widget.hourHeight, widget.width,
                      widget.timetableBegin)
              ],
            );
          }),
    );
  }

  void _openQuickCreateLessonDialog(
      BuildContext context, EmptyPeriodSelection emptyPeriodSelection) {
    final selectionBloc = BlocProvider.of<TimetableSelectionBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => TimetableQuickCreateDialog(
        periodSelection: emptyPeriodSelection,
        selectionBloc: selectionBloc,
      ),
      isScrollControlled: true,
    );
  }
}

class TimetableQuickCreateDialog extends StatelessWidget {
  final EmptyPeriodSelection periodSelection;
  final TimetableSelectionBloc selectionBloc;

  const TimetableQuickCreateDialog({
    Key? key,
    required this.periodSelection,
    required this.selectionBloc,
  }) : super(key: key);

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

class _JoinGroupIconButton extends StatelessWidget {
  const _JoinGroupIconButton({
    Key? key,
  }) : super(key: key);

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
  const _CreateCourseIconButton({Key? key}) : super(key: key);

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

class _QuickCreateCourseTile extends StatelessWidget {
  const _QuickCreateCourseTile({
    Key? key,
    required this.course,
    required this.selectionBloc,
    required this.periodSelection,
  }) : super(key: key);

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

class _PositionedPeriodElementTile extends StatelessWidget {
  final Period period;
  final double hourHeight;
  final Time timetableBegin;
  final VoidCallback? onTap;
  final bool isSelected;
  final ValueChanged<bool> onHighlightChanged;

  const _PositionedPeriodElementTile({
    Key? key,
    required this.period,
    required this.hourHeight,
    required this.timetableBegin,
    this.onTap,
    required this.isSelected,
    required this.onHighlightChanged,
  }) : super(key: key);

  final borderRadius = const BorderRadius.all(Radius.circular(5));

  @override
  Widget build(BuildContext context) {
    final dimensions =
        TimetablePeriodDimensions(period, hourHeight, timetableBegin);
    return Positioned(
      left: 0.0,
      top: dimensions.topPosition,
      right: 0.0,
      height: dimensions.height,
      child: InkWell(
        borderRadius: borderRadius,
        onHighlightChanged: onHighlightChanged,
        onTap: onTap,
        child: isSelected ? _getWidgetSelected(context) : Container(),
      ),
    );
  }

  Widget _getWidgetSelected(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          borderRadius: borderRadius),
      child: const Center(child: Icon(Icons.add, color: Colors.white)),
    );
  }
}

class TimetableElementTile extends StatelessWidget {
  final TimetableElement timetableElement;
  final double hourHeight, width;
  final Time timetableBegin;

  const TimetableElementTile(
    this.timetableElement,
    this.hourHeight,
    this.width,
    this.timetableBegin, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = TimetableElementDimensions(
        timetableElement, hourHeight, width, timetableBegin);
    return Positioned(
      left: dimensions.leftPosition,
      top: dimensions.topPosition,
      height: dimensions.height,
      width: dimensions.width,
      child: _getChild(context),
    );
  }

  Widget _getChild(BuildContext context) {
    final runtimeType = timetableElement.data.runtimeType;
    if (runtimeType == Lesson) {
      return _getChildLesson(context);
    } else if (runtimeType == CalendricalEvent) {
      return _getChildEvent(context);
    } else {
      return Container();
    }
  }

  Widget _getChildLesson(BuildContext context) {
    return TimetableEntryLesson(
      lesson: timetableElement.data as Lesson,
      groupInfo: timetableElement.groupInfo,
    );
  }

  Widget _getChildEvent(BuildContext context) {
    return TimetableEntryEvent(
      event: timetableElement.data as CalendricalEvent,
      groupInfo: timetableElement.groupInfo,
    );
  }
}
