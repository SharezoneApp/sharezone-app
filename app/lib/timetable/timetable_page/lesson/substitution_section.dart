// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'timetable_lesson_details.dart';

class _SubstitutionSection extends StatelessWidget {
  const _SubstitutionSection({
    required this.date,
    required this.hasPermissionsToManageLessons,
    required this.lesson,
  });

  final Date date;
  final bool hasPermissionsToManageLessons;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final substitutions = lesson.getSubstitutionFor(date);
    final canceledSubstitution = substitutions.getLessonCanceledSubstitution();
    final locationSubstitution = substitutions.getLocationChangedSubstitution();
    final teacherSubstitution = substitutions.getTeacherChangedSubstitution();
    final hasUnlocked = context.watch<SubscriptionService>().hasFeatureUnlocked(
              SharezonePlusFeature.substitutions,
            ) ||
        !isStableStage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text(
            'Vertretungsplan',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            'Für ${DateFormat('dd.MM.yyyy').format(date.toDateTime)}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          // We show the beta chip as long as the update isn't on the stable
          // track.
          trailing: hasUnlocked ? const _BetaChip() : const SharezonePlusChip(),
        ),
        if (canceledSubstitution != null)
          _LessonCanceledCard(
            courseId: lesson.groupID,
            createdBy: canceledSubstitution.createdBy,
            hasPermissionsToManageLessons: hasPermissionsToManageLessons,
          ),
        if (locationSubstitution != null)
          _RoomChanged(
            newLocation: locationSubstitution.newLocation,
            courseId: lesson.groupID,
            enteredBy: locationSubstitution.updatedBy ??
                locationSubstitution.createdBy,
            hasPermissionsToManageLessons: hasPermissionsToManageLessons,
          ),
        if (hasPermissionsToManageLessons) ...[
          if (canceledSubstitution == null && locationSubstitution == null)
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Stunde entfallen lassen"),
              onTap: () => Navigator.pop(
                  context,
                  hasUnlocked
                      ? _LessonDialogAction.cancelLesson
                      : _LessonDialogAction.showSubstitutionPlusDialog),
            ),
          if (canceledSubstitution == null && locationSubstitution == null)
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: const Text("Raumänderung"),
              onTap: () => Navigator.pop(
                  context,
                  hasUnlocked
                      ? _LessonDialogAction.addRoomSubstitution
                      : _LessonDialogAction.showSubstitutionPlusDialog),
            ),
          if (canceledSubstitution == null)
            if (teacherSubstitution == null)
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Lehrkraft ändern"),
                onTap: () => Navigator.pop(
                    context,
                    hasUnlocked
                        ? _LessonDialogAction.addTeacherSubstitution
                        : _LessonDialogAction.showSubstitutionPlusDialog),
              )
            else
              _TeacherChanged(
                newTeacher: teacherSubstitution.newTeacher,
                enteredBy: teacherSubstitution.updatedBy ??
                    teacherSubstitution.createdBy,
                courseId: lesson.groupID,
                hasPermissionsToManageLessons: hasPermissionsToManageLessons,
              ),
        ] else
          const ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'Du hast keine Berechtigung, den Vertretungsplan zu ändern.',
            ),
            subtitle: Text('Bitte wende dich an deinen Kurs-Administrator.'),
          )
      ],
    );
  }
}

class _BetaChip extends StatelessWidget {
  const _BetaChip();

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('Beta'),
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
    );
  }
}

class _LessonCanceledCard extends StatelessWidget {
  const _LessonCanceledCard({
    required this.createdBy,
    required this.courseId,
    required this.hasPermissionsToManageLessons,
  });

  final String courseId;
  final UserId createdBy;
  final bool hasPermissionsToManageLessons;

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        child: ListTile(
          iconColor: color,
          textColor: color,
          leading: const Icon(Icons.cancel),
          title: const Text("Stunde entfällt"),
          subtitle: _EnteredBy(
            courseId: courseId,
            enteredBy: createdBy,
            color: color,
          ),
          trailing: hasPermissionsToManageLessons
              ? IconButton(
                  tooltip: 'Rückgängig machen',
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () => Navigator.pop(
                      context, _LessonDialogAction.removeCancelLesson),
                )
              : null,
        ),
      ),
    );
  }
}

class _RoomChanged extends StatelessWidget {
  const _RoomChanged({
    required this.newLocation,
    required this.enteredBy,
    required this.courseId,
    required this.hasPermissionsToManageLessons,
  });

  final String newLocation;
  final String courseId;
  final UserId enteredBy;
  final bool hasPermissionsToManageLessons;

  @override
  Widget build(BuildContext context) {
    const color = Colors.orange;
    return _OrangeCard(
      leading: const Icon(Icons.place_outlined),
      title: Text("Raumänderung: $newLocation"),
      subtitle: _EnteredBy(
        courseId: courseId,
        enteredBy: enteredBy,
        color: color,
      ),
      trailing: hasPermissionsToManageLessons
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Raum ändern',
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () => Navigator.pop(
                      context, _LessonDialogAction.updateRoomSubstitution),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Rückgängig machen',
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () => Navigator.pop(
                      context, _LessonDialogAction.removePlaceChange),
                ),
              ],
            )
          : null,
    );
  }
}

class _TeacherChanged extends StatelessWidget {
  const _TeacherChanged({
    required this.newTeacher,
    required this.enteredBy,
    required this.courseId,
    required this.hasPermissionsToManageLessons,
  });

  final String newTeacher;
  final String courseId;
  final UserId enteredBy;
  final bool hasPermissionsToManageLessons;

  @override
  Widget build(BuildContext context) {
    const color = Colors.orange;
    return _OrangeCard(
      leading: const Icon(Icons.person_outline),
      title: Text('Vertretung: $newTeacher'),
      subtitle: _EnteredBy(
        courseId: courseId,
        enteredBy: enteredBy,
        color: color,
      ),
      trailing: hasPermissionsToManageLessons
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Lehrkraft ändern',
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () => Navigator.pop(
                      context, _LessonDialogAction.updateTeacherSubstitution),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Rückgängig machen',
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () => Navigator.pop(
                      context, _LessonDialogAction.removeTeacherSubstitution),
                ),
              ],
            )
          : null,
    );
  }
}

class _OrangeCard extends StatelessWidget {
  const _OrangeCard({
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    const color = Colors.orange;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        child: ListTile(
          iconColor: color,
          textColor: color,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }
}

class _EnteredBy extends StatelessWidget {
  const _EnteredBy({
    required this.courseId,
    required this.enteredBy,
    required this.color,
  });

  final String courseId;
  final UserId enteredBy;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      initialData: 'Lädt...',
      future: context
          .read<SubstitutionController>()
          .getMemberName(courseId, enteredBy),
      builder: (context, snapshot) {
        // Showing '?' if the name could not be loaded. Probably because the
        // user is not in the course anymore.
        final name = snapshot.data ?? '?';
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Eingetragen von: $name",
              style: TextStyle(color: color.withOpacity(0.8)),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _cancelLesson(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final shouldNotifyMembers = await _showCancelLessonDialog(context);
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  controller.addCancelSubstitution(
    lessonId: lesson.lessonID!,
    date: date,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Stunde als "Entfällt" markiert',
    context: context,
  );
}

Future<void> _removeCancelSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  await _removeSubstitution(
    context: context,
    lesson: lesson,
    date: date,
    snackBarText: 'Entfallene Stunde wiederhergestellt',
    showConfirmationDialog: _removeCancelSubstitutionDialog,
    substitutionId:
        lesson.getSubstitutionFor(date).getLessonCanceledSubstitution()?.id,
  );
}

Future<void> _removeSubstitution({
  required BuildContext context,
  required Lesson lesson,
  required Date date,
  required String snackBarText,
  required Future<bool?> Function(BuildContext context) showConfirmationDialog,
  required SubstitutionId? substitutionId,
}) async {
  if (substitutionId == null) {
    // Substitution isn't available anymore. Probably because it was removed by
    // another user.
    return;
  }

  final shouldNotifyMembers = await showConfirmationDialog(context);
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  controller.removeSubstitution(
    lessonId: lesson.lessonID!,
    substitutionId: substitutionId,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: snackBarText,
    context: context,
  );
}

Future<void> _removePlaceChangeSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  await _removeSubstitution(
    context: context,
    lesson: lesson,
    date: date,
    snackBarText: 'Raumänderung entfernt',
    showConfirmationDialog: _removePlaceSubstitutionDialog,
    substitutionId:
        lesson.getSubstitutionFor(date).getLocationChangedSubstitution()?.id,
  );
}

Future<bool?> _removePlaceSubstitutionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _SubstitutionDialog(
      title: 'Raumänderung entfernen',
      actionText: 'Entfernen',
      description:
          'Möchtest du wirklich die Raumänderung für die Stunde entfernen?',
      notifyOptionText: 'Informiere deine Kursmitglieder über die Entfernung.',
    ),
  );
}

Future<void> _addRoomSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final result = await _showChangeRoomDialog(context);
  final shouldNotifyMembers = result.$1;
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  controller.addPlaceChangeSubstitution(
    lessonId: lesson.lessonID!,
    date: date,
    newLocation: result.$2,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Raumänderung eingetragen',
    context: context,
  );
}

Future<void> _addTeacherSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final result = await _showChangeTeacherDialog(context);
  final shouldNotifyMembers = result.$1;
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  controller.addTeacherSubstitution(
    lessonId: lesson.lessonID!,
    date: date,
    newTeacher: result.$2,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Vertretungslehrkraft eingetragen',
    context: context,
  );
}

Future<void> _updateTeacherSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final result = await _showChangeTeacherDialog(context);
  final shouldNotifyMembers = result.$1;
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  final substitution =
      lesson.getSubstitutionFor(date).getTeacherChangedSubstitution();
  if (substitution == null) {
    // Substitution isn't available anymore. Probably because it was removed by
    // another user.
    return;
  }

  controller.updateTeacherSubstitution(
    lessonId: lesson.lessonID!,
    newTeacher: result.$2,
    substitutionId: substitution.id,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Vertretungslehrkraft eingetragen',
    context: context,
  );
}

Future<void> _removeTeacherSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  await _removeSubstitution(
    context: context,
    lesson: lesson,
    date: date,
    snackBarText: 'Vertretungslehrkraft entfernt',
    showConfirmationDialog: _removeTeacherSubstitutionDialog,
    substitutionId:
        lesson.getSubstitutionFor(date).getTeacherChangedSubstitution()?.id,
  );
}

Future<bool?> _removeTeacherSubstitutionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _SubstitutionDialog(
      title: 'Vertretungslehrkraft entfernen',
      actionText: 'Entfernen',
      description:
          'Möchtest du wirklich die Vertretungslehrkraft für die Stunde entfernen?',
      notifyOptionText: 'Informiere deine Kursmitglieder über die Entfernung.',
    ),
  );
}

Future<bool?> _showCancelLessonDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _SubstitutionDialog(
      title: 'Stunde entfallen lassen',
      actionText: 'Entfallen lassen',
      description:
          'Möchtest du wirklich die Schulstunde für den gesamten Kurs entfallen lassen?',
      notifyOptionText:
          'Informiere deine Kursmitglieder, dass die Stunde entfällt.',
    ),
  );
}

Future<void> _updateRoomSubstitution(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final result = await _showChangeRoomDialog(context);
  final shouldNotifyMembers = result.$1;
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  final substitution =
      lesson.getSubstitutionFor(date).getLocationChangedSubstitution();
  if (substitution == null) {
    // Substitution isn't available anymore. Probably because it was removed by
    // another user.
    return;
  }

  controller.updatePlaceSubstitution(
    lessonId: lesson.lessonID!,
    newLocation: result.$2,
    substitutionId: substitution.id,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Raumänderung eingetragen',
    context: context,
  );
}

Future<bool?> _removeCancelSubstitutionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _SubstitutionDialog(
      title: 'Entfallene Stunde wiederherstellen',
      actionText: 'Wiederherstellen',
      description:
          'Möchtest du wirklich die Stunde wirklich wieder stattfinden lassen?',
      notifyOptionText:
          'Informiere deine Kursmitglieder, dass die Stunde stattfindet.',
    ),
  );
}

Future<(bool?, String)> _showChangeRoomDialog(BuildContext context) async {
  final textController = TextEditingController();
  final shouldNotify = await showDialog<bool>(
    context: context,
    builder: (context) => _SubstitutionDialog(
      title: 'Raumänderung',
      actionText: 'Raumänderung speichern',
      description: 'Möchtest du wirklich den Raum für die Stunde ändern?',
      notifyOptionText:
          'Informiere deine Kursmitglieder über die Raumänderung.',
      bottom: _ChangeRoomTextField(textController: textController),
    ),
  );
  return (shouldNotify, textController.text);
}

Future<(bool?, String)> _showChangeTeacherDialog(BuildContext context) async {
  String teacher = '';
  final shouldNotify = await showDialog<bool>(
    context: context,
    builder: (context) => _SubstitutionDialog(
      title: 'Vertretungslehrkraft ändern',
      actionText: 'Lehrkraft speichern',
      description: 'Möchtest du wirklich die Vertretungslehrkraft ändern?',
      notifyOptionText:
          'Informiere deine Kursmitglieder über die Lehrkraftänderung.',
      bottom:
          _ChangeTeacherTextField(onTeacherChanged: (value) => teacher = value),
    ),
  );
  return (shouldNotify, teacher);
}

class _ChangeRoomTextField extends StatelessWidget {
  const _ChangeRoomTextField({
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        leading: const Icon(Icons.place_outlined),
        title: TextField(
          autofocus: true,
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Neuer Raum',
            hintText: 'z.B. D203',
          ),
          maxLength: 32,
        ),
      ),
    );
  }
}

class _ChangeTeacherTextField extends StatelessWidget {
  const _ChangeTeacherTextField({
    required this.onTeacherChanged,
  });

  final ValueChanged<String> onTeacherChanged;

  @override
  Widget build(BuildContext context) {
    final teachers = BlocProvider.of<TimetableBloc>(context).currentTeachers;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TeacherField(
        teachers: teachers,
        onTeacherChanged: onTeacherChanged,
      ),
    );
  }
}

class _SubstitutionDialog extends StatefulWidget {
  const _SubstitutionDialog({
    required this.title,
    required this.description,
    required this.notifyOptionText,
    required this.actionText,
    this.bottom,
  });

  final String title;
  final String description;
  final String notifyOptionText;
  final String actionText;
  final Widget? bottom;

  @override
  _SubstitutionDialogState createState() => _SubstitutionDialogState();
}

class _SubstitutionDialogState extends State<_SubstitutionDialog> {
  bool shouldNotifyMembers = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(widget.description),
            ),
            SwitchListTile.adaptive(
              title: Text(
                widget.notifyOptionText,
                style: const TextStyle(fontSize: 14),
              ),
              secondary: const Icon(Icons.notifications),
              value: shouldNotifyMembers,
              onChanged: (value) {
                setState(() => shouldNotifyMembers = value);
              },
            ),
            if (widget.bottom != null) widget.bottom!,
          ],
        ),
      ),
      actions: <Widget>[
        const CancelButton(),
        TextButton(
          onPressed: () => Navigator.pop(context, shouldNotifyMembers),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(widget.actionText.toUpperCase()),
        ),
      ],
    );
  }
}
