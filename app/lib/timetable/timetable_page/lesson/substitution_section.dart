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
    final isDropped = lesson.getSubstitutionFor(date) is SubstitutionCanceled;
    final hasUnlocked = context.watch<SubscriptionService>().hasFeatureUnlocked(
          SharezonePlusFeature.substitutions,
        );
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
        if (isDropped)
          _LessonCancelledCard(
            courseId: lesson.groupID,
            createdBy: lesson.getSubstitutionFor(date)!.createdBy,
          )
        else if (hasPermissionsToManageLessons) ...[
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
            createdBy: createdBy,
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

class _EnteredBy extends StatelessWidget {
  const _EnteredBy({
    required this.courseId,
    required this.createdBy,
    required this.color,
  });

  final String courseId;
  final UserId createdBy;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      initialData: 'Lädt...',
      future: context
          .read<SubstitutionController>()
          .getMemberName(courseId, createdBy),
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
  final shouldNotifyMembers = await _removeCancelSubstitutionDialog(context);
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
    text: 'Entfallene Stunde wiederhergestellt',
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

class _SubstitutionDialog extends StatefulWidget {
  const _SubstitutionDialog({
    required this.title,
    required this.description,
    required this.notifyOptionText,
    required this.actionText,
  });

  final String title;
  final String description;
  final String notifyOptionText;
  final String actionText;

  @override
  _SubstitutionDialogState createState() => _SubstitutionDialogState();
}

class _SubstitutionDialogState extends State<_SubstitutionDialog> {
  bool shouldNotifyMembers = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      content: Column(
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
        ],
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
