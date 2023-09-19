// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../timetable_permissions.dart';

class CalenderEventCard extends StatelessWidget {
  const CalenderEventCard(
    this.view, {
    Key? key,
  }) : super(key: key);

  final EventView view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        width: double.infinity,
        child: CustomCard(
          onLongPress: () => onEventLongPress(context, view.event),
          onTap: () =>
              showTimetableEventDetails(context, view.event, view.design),
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
                Text(view.dateText,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({
    Key? key,
    required this.courseName,
    this.color,
  }) : super(key: key);

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
  const _Title({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Theme.of(context).isDarkTheme
              ? Colors.lightBlueAccent
              : darkBlueColor,
          fontSize: 16,
          fontWeight: FontWeight.w500),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

Future<void> onEventLongPress(
    BuildContext context, CalendricalEvent event) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final isAuthor = api.uID == event.authorID;
  final hasPermissionsToManageEvents = hasPermissionToManageEvents(
      api.course.getRoleFromCourseNoSync(event.groupID)!, isAuthor);
  final isExam = event.eventType == Exam();
  final result = await showLongPressAdaptiveDialog<_EventLongPressResult>(
    context: context,
    title: "${isExam ? "Prüfung" : "Termin"}: ${event.title}",
    longPressList: [
      const LongPress(
        title: "Farbe ändern",
        popResult: _EventLongPressResult.changeDesign,
        icon: Icon(Icons.color_lens),
      ),
      const LongPress(
        title: "Melden",
        popResult: _EventLongPressResult.report,
        icon: reportIcon,
      ),
      if (hasPermissionsToManageEvents) ...const [
        LongPress(
          title: "Bearbeiten",
          popResult: _EventLongPressResult.edit,
          icon: Icon(Icons.edit),
        ),
        LongPress(
          title: "Löschen",
          popResult: _EventLongPressResult.delete,
          icon: Icon(Icons.delete),
        )
      ]
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
