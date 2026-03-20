// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';
import 'package:sharezone/homework/homework_dialog/open_homework_dialog.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/src/sign_out_and_delete_anonymous_user.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/logic/lesson_delete_all_suggestion.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/substitution.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';
import 'package:sharezone/timetable/timetable_edit/lesson/timetable_lesson_edit_page.dart';
import 'package:sharezone/timetable/timetable_page/lesson/substitution_controller.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'substitution_section.dart';

enum _LessonDialogAction {
  edit,
  delete,
  design,
  addHomework,
  cancelLesson,
  addRoomSubstitution,
  updateRoomSubstitution,
  addTeacherSubstitution,
  updateTeacherSubstitution,
  removeTeacherSubstitution,
  removeCancelLesson,
  removePlaceChange,
  showSubstitutionPlusDialog,
  showTeachersPlusDialog,
}

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
    api.course.getRoleFromCourseNoSync(lesson.groupID)!,
  );
  final result = await showLongPressAdaptiveDialog<_LessonLongPressResult>(
    context: context,
    longPressList: [
      LongPress(
        title: context.l10n.timetableLessonDetailsChangeColor,
        popResult: _LessonLongPressResult.changeDesign,
        icon: const Icon(Icons.color_lens),
      ),
      if (hasPermissionsToManageLessons) ...[
        LongPress(
          title: context.l10n.commonActionsEdit,
          popResult: _LessonLongPressResult.edit,
          icon: const Icon(Icons.edit),
        ),
        LongPress(
          title: context.l10n.commonActionsDelete,
          popResult: _LessonLongPressResult.delete,
          icon: const Icon(Icons.delete),
        ),
      ],
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
            child: Text(context.l10n.commonActionsCancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          if (confirm)
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text(context.l10n.commonActionsDelete),
            ),
        ],
      );
    }
    return AlertDialog(
      title: Text(context.l10n.timetableLessonDetailsDeleteTitle),
      content: content(),
      contentPadding: const EdgeInsets.only(),
      actions: <Widget>[
        const CancelButton(),
        TextButton(
          onPressed: confirm ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(context.l10n.commonActionsDeleteUppercase),
        ),
      ],
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Text(context.l10n.timetableLessonDetailsDeleteDialogMessage),
        ),
        DeleteConfirmationCheckbox(
          text: context.l10n.timetableLessonDetailsDeleteDialogConfirm,
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
  BuildContext context,
  Lesson lesson,
  Date date,
  Design? design,
) async {
  final popOption = await showDialog<_LessonDialogAction>(
    context: context,
    builder:
        (context) => _TimetableLessonBottomModelSheet(
          lesson: lesson,
          design: design,
          date: date,
        ),
  );
  if (!context.mounted || popOption == null) return;

  switch (popOption) {
    case _LessonDialogAction.delete:
      _deleteLesson(context, lesson);
      break;
    case _LessonDialogAction.edit:
      _openTimetableEditPage(context, lesson);
      break;
    case _LessonDialogAction.design:
      editCourseDesign(context, lesson.groupID);
      break;
    case _LessonDialogAction.cancelLesson:
      _cancelLesson(context, lesson, date);
      break;
    case _LessonDialogAction.addHomework:
      _openHomeworkForLesson(context, lesson, date);
      break;
    case _LessonDialogAction.addRoomSubstitution:
      _addRoomSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.removeCancelLesson:
      _removeCancelSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.showSubstitutionPlusDialog:
      _showPlusDialog(context);
      break;
    case _LessonDialogAction.removePlaceChange:
      _removePlaceChangeSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.updateRoomSubstitution:
      _updateRoomSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.showTeachersPlusDialog:
      showTeachersInTimetablePlusDialog(context);
      break;
    case _LessonDialogAction.addTeacherSubstitution:
      _addTeacherSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.updateTeacherSubstitution:
      _updateTeacherSubstitution(context, lesson, date);
      break;
    case _LessonDialogAction.removeTeacherSubstitution:
      _removeTeacherSubstitution(context, lesson, date);
      break;
  }
}

void _showPlusDialog(BuildContext context) {
  showSharezonePlusFeatureInfoDialog(
    context: context,
    navigateToPlusPage: () => navigateToSharezonePlusPage(context),
    description: Text(
      context.l10n.timetableLessonDetailsSubstitutionPlusDescription,
    ),
  );
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
  BuildContext context,
  Lesson lesson,
) async {
  final timetableGateway =
      BlocProvider.of<SharezoneContext>(context).api.timetable;
  timetableGateway.deleteLesson(lesson);
  LessonDeleteAllSuggestion.recordLessonDeletion(context);

  await waitingForPopAnimation();
  if (!context.mounted) return;

  showSnackSec(
    text: context.l10n.timetableLessonDetailsDeletedConfirmation,
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
      builder:
          (context) => TimetableEditLessonPage(
            lesson,
            api.timetable,
            api.connectionsGateway,
            timetableBloc,
          ),
      settings: const RouteSettings(name: TimetableEditLessonPage.tag),
    ),
  );
  if (confirmed != null && confirmed) {
    await waitingForPopAnimation();
    if (!context.mounted) return;

    showSnackSec(
      text: context.l10n.timetableLessonDetailsEditedConfirmation,
      context: context,
      behavior: SnackBarBehavior.fixed,
      seconds: 2,
    );
  }
}

Future<void> _openHomeworkForLesson(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  await waitingForBottomModelSheetClosing();
  if (!context.mounted) return;
  await openHomeworkDialogAndShowConfirmationIfSuccessful(
    context,
    initialCourseId: CourseId(lesson.groupID),
    initialDueDate: date,
  );
}

Color? getIconGrey(BuildContext context) =>
    Theme.of(context).isDarkTheme ? Colors.grey : Colors.grey[600];

class _TimetableLessonBottomModelSheet extends StatelessWidget {
  final Lesson lesson;
  final Design? design;
  final Date date;

  const _TimetableLessonBottomModelSheet({
    required this.lesson,
    required this.date,
    this.design,
  });

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final hasPermissionsToManageLessons = hasPermissionToManageLessons(
      api.course.getRoleFromCourseNoSync(lesson.groupID)!,
    );
    return SimpleDialog(
      children: <Widget>[
        const SizedBox(height: 8),
        ListTile(
          leading: const CloseButton(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.note_add),
                tooltip: context.l10n.timetableLessonDetailsAddHomeworkTooltip,
                color: getIconGrey(context),
                onPressed:
                    () =>
                        Navigator.pop(context, _LessonDialogAction.addHomework),
              ),
              const _ChangeColorIcon(),
              if (hasPermissionsToManageLessons) ...const [
                _EditIcon(),
                DeleteIcon(),
              ],
              const SizedBox(width: 4),
            ],
          ),
        ),
        const Divider(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _LessonBasicSection(
            design: design,
            lesson: lesson,
            date: date,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _SubstitutionSection(
            date: date,
            hasPermissionsToManageLessons: hasPermissionsToManageLessons,
            lesson: lesson,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LessonBasicSection extends StatelessWidget {
  const _LessonBasicSection({
    required this.design,
    required this.lesson,
    required this.date,
  });

  final Design? design;
  final Lesson lesson;
  final Date date;

  @override
  Widget build(BuildContext context) {
    final courseName =
        BlocProvider.of<SharezoneContext>(
          context,
        ).api.course.getCourse(lesson.groupID)?.name ??
        "-";
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    final isABWeekEnabled = timetableBloc.current.isABWeekEnabled();
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.group),
          title: Text.rich(
            TextSpan(
              style: TextStyle(
                color:
                    Theme.of(context).isDarkTheme
                        ? Colors.white
                        : Colors.grey[800],
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: context.l10n.timetableLessonDetailsCourseName),
                TextSpan(
                  text: courseName,
                  style: TextStyle(color: design?.color),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(
            context.l10n.timetableLessonDetailsTimeRange(
              lesson.startTime.toString(),
              lesson.endTime.toString(),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.event),
          title: Text(
            context.l10n.timetableLessonDetailsWeekday(
              lesson.weekday.toLocalizedString(context),
            ),
          ),
        ),
        if (isABWeekEnabled)
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(
              context.l10n.timetableLessonDetailsWeekType(
                getWeekTypeText(lesson.weektype),
              ),
            ),
          ),
        _Location(lesson: lesson, date: date),
        _Teacher(lesson: lesson, date: date),
      ],
    );
  }
}

class _Teacher extends StatelessWidget {
  const _Teacher({required this.lesson, required this.date});

  final Lesson lesson;
  final Date date;

  String getTitle() {
    return lesson.teacher ?? "-";
  }

  @override
  Widget build(BuildContext context) {
    final substitutions = lesson.getSubstitutionFor(date);
    final newTeacher =
        substitutions.getTeacherChangedSubstitution()?.newTeacher;
    final hasNewTeacher = newTeacher != null;
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text.rich(
        TextSpan(
          text: context.l10n.timetableLessonDetailsTeacher,
          children: [
            TextSpan(
              text: getTitle(),
              style: TextStyle(
                decoration: hasNewTeacher ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
      subtitle:
          hasNewTeacher
              ? Text(context.l10n.timetableSubstitutionReplacement(newTeacher))
              : null,
    );
  }
}

Future<void> showTeachersInTimetablePlusDialog(BuildContext context) {
  return showSharezonePlusFeatureInfoDialog(
    context: context,
    navigateToPlusPage: () => navigateToSharezonePlusPage(context),
    title: Text(context.l10n.timetableLessonDetailsTeacherInTimetableTitle),
    description: Text(
      context.l10n.timetableLessonDetailsTeacherInTimetableDescription,
    ),
  );
}

class _Location extends StatelessWidget {
  const _Location({required this.date, required this.lesson});

  final Date date;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final substitutions = lesson.getSubstitutionFor(date);
    final newLocation =
        substitutions.getLocationChangedSubstitution()?.newLocation;
    return ListTile(
      leading: const Icon(Icons.place),
      title: Row(
        children: [
          Text(context.l10n.timetableLessonDetailsRoom),
          Text(
            lesson.place ?? "-",
            style: TextStyle(
              decoration:
                  newLocation != null ? TextDecoration.lineThrough : null,
            ),
          ),
          if (newLocation != null) ...[
            const SizedBox(width: 4),
            Text(context.l10n.timetableLessonDetailsArrowLocation(newLocation)),
          ],
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
      onPressed: () => Navigator.pop(context, _LessonDialogAction.delete),
      icon: const Icon(Icons.delete),
      tooltip: context.l10n.commonActionsDelete,
      color: getIconGrey(context),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, _LessonDialogAction.edit),
      icon: const Icon(Icons.edit),
      tooltip: context.l10n.commonActionsEdit,
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
      tooltip: context.l10n.timetableLessonDetailsChangeColor,
      onPressed: () => Navigator.pop(context, _LessonDialogAction.design),
    );
  }
}
