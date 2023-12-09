// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/src/sign_out_and_delete_anonymous_user.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_edit/lesson/timetable_lesson_edit_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../timetable_permissions.dart';

enum _LessonModelSheetAction { edit, delete, design }

enum _LessonLongPressResult { edit, delete, changeDesign, report }

Future<bool?> showDeleteLessonConfirmationDialog(BuildContext context) async {
  if (ThemePlatform.isCupertino) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => _DeleteLessonDialog(),
    );
  }
  return showDialog<bool>(
    context: context,
    builder: (context) => _DeleteLessonDialog(),
  );
}

Future<void> onLessonLongPress(BuildContext context, Lesson lesson) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final hasPermissionsToManageLessons = hasPermissionToManageLessons(
      api.course.getRoleFromCourseNoSync(lesson.groupID)!);
  final result = await showLongPressAdaptiveDialog<_LessonLongPressResult>(
    context: context,
    longPressList: [
      const LongPress(
        title: "Farbe ändern",
        popResult: _LessonLongPressResult.changeDesign,
        icon: Icon(Icons.color_lens),
      ),
      const LongPress(
        icon: reportIcon,
        title: "Melden",
        popResult: _LessonLongPressResult.report,
      ),
      if (hasPermissionsToManageLessons) ...const [
        LongPress(
          title: "Bearbeiten",
          popResult: _LessonLongPressResult.edit,
          icon: Icon(Icons.edit),
        ),
        LongPress(
          title: "Löschen",
          popResult: _LessonLongPressResult.delete,
          icon: Icon(Icons.delete),
        )
      ]
    ],
  );
  if (!context.mounted) return;

  switch (result) {
    case _LessonLongPressResult.changeDesign:
      editCourseDesign(context, lesson.groupID);
      break;
    case _LessonLongPressResult.edit:
      _openTimetableEditPage(context, lesson);
      break;
    case _LessonLongPressResult.delete:
      _deleteLesson(context, lesson);
      break;
    case _LessonLongPressResult.report:
      openReportPage(context, ReportItemReference.lesson(lesson.lessonID!));
      break;
    case null:
      break;
  }
}

class _DeleteLessonDialog extends StatefulWidget {
  @override
  __DeleteLessonDialogState createState() => __DeleteLessonDialogState();
}

class __DeleteLessonDialogState extends State<_DeleteLessonDialog> {
  bool confirm = false;

  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        content: content(),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context, false),
          ),
          if (confirm)
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text("Löschen"),
            ),
        ],
      );
    }
    return AlertDialog(
      title: const Text("Stunde löschen"),
      content: content(),
      contentPadding: const EdgeInsets.only(),
      actions: <Widget>[
        const CancelButton(),
        TextButton(
          onPressed: confirm ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text("LÖSCHEN"),
        ),
      ],
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Text(
              "Möchtest du wirklich die Schulstunde für den gesamten Kurs löschen?"),
        ),
        DeleteConfirmationCheckbox(
          text:
              "Mir ist bewusst, dass die Stunde für alle Teilnehmer aus dem Kurs gelöscht wird.",
          confirm: confirm,
          onChanged: (value) {
            if (value == null) return;
            setState(() => confirm = value);
          },
        ),
      ],
    );
  }
}

Future<void> showLessonModelSheet(
    BuildContext context, Lesson lesson, Design? design) async {
  final popOption = await showModalBottomSheet<_LessonModelSheetAction>(
    isScrollControlled: true,
    context: context,
    builder: (context) => _TimetableLessonBottomModelSheet(
      lesson: lesson,
      design: design,
    ),
  );
  if (!context.mounted) return;

  switch (popOption) {
    case _LessonModelSheetAction.delete:
      _deleteLesson(context, lesson);
      break;
    case _LessonModelSheetAction.edit:
      _openTimetableEditPage(context, lesson);
      break;
    case _LessonModelSheetAction.design:
      editCourseDesign(context, lesson.groupID);
      break;
    default:
      break;
  }
}

Future _deleteLesson(BuildContext context, Lesson lesson) async {
  await waitingForBottomModelSheetClosing();
  if (!context.mounted) return;

  final confirmed = await showDeleteLessonConfirmationDialog(context);
  if (confirmed == true && context.mounted) {
    _deleteLessonAndShowConfirmationSnackbar(context, lesson);
  }
}

Future<void> _deleteLessonAndShowConfirmationSnackbar(
    BuildContext context, Lesson lesson) async {
  final timetableGateway =
      BlocProvider.of<SharezoneContext>(context).api.timetable;
  timetableGateway.deleteLesson(lesson);

  await waitingForPopAnimation();
  if (!context.mounted) return;

  showSnackSec(
    text: 'Schulstunde wurde gelöscht',
    context: context,
    seconds: 2,
    behavior: SnackBarBehavior.fixed,
  );
}

Future<void> _openTimetableEditPage(BuildContext context, Lesson lesson) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final timetableBloc = BlocProvider.of<TimetableBloc>(context);
  final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (context) => TimetableEditLessonPage(
                lesson,
                api.timetable,
                api.connectionsGateway,
                timetableBloc,
              ),
          settings: const RouteSettings(name: TimetableEditLessonPage.tag)));
  if (confirmed != null && confirmed) {
    await waitingForPopAnimation();
    if (!context.mounted) return;

    showSnackSec(
      text: 'Schulstunde wurde erfolgreich bearbeitet',
      context: context,
      behavior: SnackBarBehavior.fixed,
      seconds: 2,
    );
  }
}

Color? getIconGrey(BuildContext context) =>
    Theme.of(context).isDarkTheme ? Colors.grey : Colors.grey[600];

class _TimetableLessonBottomModelSheet extends StatelessWidget {
  final Lesson lesson;
  final Design? design;

  const _TimetableLessonBottomModelSheet({
    required this.lesson,
    this.design,
  });

  @override
  Widget build(BuildContext context) {
    final courseName = BlocProvider.of<SharezoneContext>(context)
            .api
            .course
            .getCourse(lesson.groupID)
            ?.name ??
        "-";
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);

    final isABWeekEnabled = timetableBloc.current.isABWeekEnabled();
    final hasPermissionsToManageLessons = hasPermissionToManageLessons(
        api.course.getRoleFromCourseNoSync(lesson.groupID)!);
    return SafeArea(
      left: true,
      bottom: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text("Details",
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              Row(
                children: <Widget>[
                  const _ChangeColorIcon(),
                  ReportIcon(
                      item: ReportItemReference.lesson(lesson.lessonID!),
                      color: getIconGrey(context)),
                  if (hasPermissionsToManageLessons) ...const [
                    _EditIcon(),
                    DeleteIcon(),
                  ],
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
          const Divider(height: 16),
          ListTile(
            leading: const Icon(Icons.group),
            title: Text.rich(
              TextSpan(
                style: TextStyle(
                    color: Theme.of(context).isDarkTheme
                        ? Colors.white
                        : Colors.grey[800],
                    fontSize: 16),
                children: <TextSpan>[
                  const TextSpan(text: "Kursname: "),
                  TextSpan(
                      text: courseName, style: TextStyle(color: design?.color))
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text("${lesson.startTime} - ${lesson.endTime}"),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title:
                Text("Wochentag: ${weekDayEnumToGermanString(lesson.weekday)}"),
          ),
          if (isABWeekEnabled)
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text("Wochentyp: ${getWeekTypeText(lesson.weektype)}"),
            ),
          ListTile(
            leading: const Icon(Icons.place),
            title: Text("Raum: ${lesson.place ?? "-"}"),
          ),
        ],
      ),
    );
  }
}

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, _LessonModelSheetAction.delete),
      icon: const Icon(Icons.delete),
      tooltip: 'Löschen',
      color: getIconGrey(context),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, _LessonModelSheetAction.edit),
      icon: const Icon(Icons.edit),
      tooltip: 'Bearbeiten',
      color: getIconGrey(context),
    );
  }
}

class _ChangeColorIcon extends StatelessWidget {
  const _ChangeColorIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.color_lens),
      color: getIconGrey(context),
      tooltip: 'Farbe ändern',
      onPressed: () => Navigator.pop(context, _LessonModelSheetAction.design),
    );
  }
}
