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
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/bloc/timetable_selection_bloc.dart';
import 'package:sharezone/timetable/src/logic/timetable_element_dimensions.dart';
import 'package:sharezone/timetable/src/logic/timetable_period_dimensions.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_tile.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

import 'quick_create/timetable_quick_create_dialog.dart';

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
                  TimetableElementTile(
                    element,
                    widget.hourHeight,
                    widget.width,
                    widget.timetableBegin,
                    widget.date,
                  )
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

class _PositionedPeriodElementTile extends StatelessWidget {
  final Period period;
  final double hourHeight;
  final Time timetableBegin;
  final VoidCallback? onTap;
  final bool isSelected;
  final ValueChanged<bool> onHighlightChanged;

  const _PositionedPeriodElementTile({
    required this.period,
    required this.hourHeight,
    required this.timetableBegin,
    this.onTap,
    required this.isSelected,
    required this.onHighlightChanged,
  });

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
  final Date date;

  const TimetableElementTile(
    this.timetableElement,
    this.hourHeight,
    this.width,
    this.timetableBegin,
    this.date, {
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
      child: _getChild(context, date),
    );
  }

  Widget _getChild(BuildContext context, Date date) {
    final runtimeType = timetableElement.data.runtimeType;
    if (runtimeType == Lesson) {
      return _getChildLesson(context, date);
    } else if (runtimeType == CalendricalEvent) {
      return _getChildEvent(context);
    } else {
      return Container();
    }
  }

  Widget _getChildLesson(BuildContext context, Date date) {
    return TimetableEntryLesson(
      lesson: timetableElement.data as Lesson,
      groupInfo: timetableElement.groupInfo,
      date: date,
    );
  }

  Widget _getChildEvent(BuildContext context) {
    return TimetableEntryEvent(
      event: timetableElement.data as CalendricalEvent,
      groupInfo: timetableElement.groupInfo,
    );
  }
}
