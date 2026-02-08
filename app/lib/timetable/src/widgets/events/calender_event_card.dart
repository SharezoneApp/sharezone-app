// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../timetable_permissions.dart';

class CalenderEventCard extends StatelessWidget {
  const CalenderEventCard(this.view, {super.key});

  final EventView view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        width: double.infinity,
        child: CustomCard(
          onLongPress: () => onEventLongPress(context, view.event),
          onTap:
              () => showTimetableEventDetails(context, view.event, view.design),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CourseName(
                  color: view.design?.color,
                  courseName: view.courseName ?? "",
                ),
                const SizedBox(height: 6),
                _Title(title: view.title),
                const SizedBox(height: 6),
                Text(
                  view.dateText,
                  style:
                      view.upcomingSoon
                          ? const TextStyle(color: Colors.red)
                          : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({required this.courseName, this.color});

  final String courseName;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      courseName,
      style: TextStyle(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color:
            Theme.of(context).isDarkTheme
                ? Colors.lightBlueAccent
                : darkBlueColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

Future<void> onEventLongPress(
  BuildContext context,
  CalendricalEvent event,
) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final isAuthor = api.uID == event.authorID;
  final hasPermissionsToManageEvents = hasPermissionToManageEvents(
    api.course.getRoleFromCourseNoSync(event.groupID)!,
    isAuthor,
  );
  final isExam = event.eventType == EventType.exam;
  final result = await showLongPressAdaptiveDialog<_EventLongPressResult>(
    context: context,
    title:
        isExam
            ? context.l10n.timetableEventCardExamTitle(event.title)
            : context.l10n.timetableEventCardEventTitle(event.title),
    longPressList: [
      LongPress(
        title: context.l10n.timetableEventCardChangeColorAction,
        popResult: _EventLongPressResult.changeDesign,
        icon: const Icon(Icons.color_lens),
      ),
      LongPress(
        title: context.l10n.commonActionsReport,
        popResult: _EventLongPressResult.report,
        icon: reportIcon,
      ),
      if (hasPermissionsToManageEvents) ...[
        LongPress(
          title: context.l10n.commonActionsEdit,
          popResult: _EventLongPressResult.edit,
          icon: const Icon(Icons.edit),
        ),
        LongPress(
          title: context.l10n.commonActionsDelete,
          popResult: _EventLongPressResult.delete,
          icon: const Icon(Icons.delete),
        ),
      ],
    ],
  );
  if (!context.mounted) return;

  switch (result) {
    case _EventLongPressResult.changeDesign:
      editCourseDesign(context, event.groupID);
      break;
    case _EventLongPressResult.edit:
      openTimetableEventEditPage(context, event);
      break;
    case _EventLongPressResult.delete:
      deleteEvent(context, event);
      break;
    case _EventLongPressResult.report:
      openReportPage(context, ReportItemReference.event(event.eventID));
      break;
    case null:
      break;
  }
}

enum _EventLongPressResult { changeDesign, edit, delete, report }
