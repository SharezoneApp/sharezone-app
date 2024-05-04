part of 'timetable_lesson_sheet.dart';

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
    final substitution = lesson.getSubstitutionFor(date);
    final isDropped = substitution is SubstitutionCanceled;
    final newPlace =
        substitution is SubstitutionPlaceChange ? substitution.newPlace : null;
    final hasUnlocked = context.watch<SubscriptionService>().hasFeatureUnlocked(
          SharezonePlusFeature.substitutions,
        );
    final hasSubstitution = isDropped || newPlace != null;
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
          trailing: hasUnlocked ? null : const SharezonePlusChip(),
        ),
        if (hasSubstitution) ...[
          if (isDropped)
            _LessonCancelledCard(
              courseId: lesson.groupID,
              createdBy: lesson.getSubstitutionFor(date)!.createdBy,
            ),
          if (newPlace != null)
            _RoomChanged(
              newPlace: newPlace,
              courseId: lesson.groupID,
              enteredBy: lesson.getSubstitutionFor(date)!.createdBy,
            )
        ] else if (hasPermissionsToManageLessons) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text("Stunde entfallen lassen"),
            onTap: () => Navigator.pop(
                context,
                hasUnlocked
                    ? _LessonModelSheetAction.cancelLesson
                    : _LessonModelSheetAction.showSubstitutionPlusDialog),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text("Raumänderung"),
            onTap: () => Navigator.pop(
                context,
                hasUnlocked
                    ? _LessonModelSheetAction.changeRoom
                    : _LessonModelSheetAction.showSubstitutionPlusDialog),
          ),
        ],
      ],
    );
  }
}

class _LessonCancelledCard extends StatelessWidget {
  const _LessonCancelledCard({
    required this.createdBy,
    required this.courseId,
  });

  final String courseId;
  final UserId createdBy;

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
          trailing: IconButton(
            tooltip: 'Rückgängig machen',
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () => Navigator.pop(
                context, _LessonModelSheetAction.removeCancelLesson),
          ),
        ),
      ),
    );
  }
}

class _RoomChanged extends StatelessWidget {
  const _RoomChanged({
    required this.newPlace,
    required this.enteredBy,
    required this.courseId,
  });

  final String newPlace;
  final String courseId;
  final UserId enteredBy;

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
          leading: const Icon(Icons.place_outlined),
          title: Text("Raumänderung: $newPlace"),
          subtitle: _EnteredBy(
            courseId: courseId,
            enteredBy: enteredBy,
            color: color,
          ),
          trailing: IconButton(
            tooltip: 'Rückgängig machen',
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () => Navigator.pop(
                context, _LessonModelSheetAction.removePlaceChange),
          ),
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
  );
}

Future<void> _removeSubstitution({
  required BuildContext context,
  required Lesson lesson,
  required Date date,
  required String snackBarText,
  required Future<bool?> Function(BuildContext context) showConfirmationDialog,
}) async {
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
    substitutionId: lesson.getSubstitutionFor(date)!.id,
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

Future<void> _changeRoom(
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
    newPlace: result.$2,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Raumänderung eingetragen',
    context: context,
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
      bottom: Padding(
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
      ),
    ),
  );
  return (shouldNotify, textController.text);
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
